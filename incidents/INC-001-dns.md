# Počítač nenajde doménu

**Co hlásí uživatel:** „Nejde mi přihlášení, píše to, že doména není dostupná.“

## Jak závadu navodit

Na PC01 změnit DNS server z 10.10.10.10 na 10.10.10.99 (adresa, na které nic není). Adresu počítače ani kabel neměnit.

## Jak se projeví

```powershell
Resolve-DnsName -Type SRV _ldap._tcp.dc._msdcs.lab.example.test
nltest /dsgetdc:lab.example.test /force
```

Počítač nedostane odpověď na dotaz, kde běží řadič domény. Část odpovědí si pamatuje, takže se závada nemusí ukázat hned; paměť vyčistí `Clear-DnsClientCache`. Dříve přihlášený uživatel se může přihlásit pomocí uložených údajů; přihlášení selže hlavně u účtu, který se na počítači ještě nepřihlašoval.

## Jak ji najít

1. `ipconfig /all` – jakou má počítač adresu a jaký DNS server.
2. Zeptat se přímo správného serveru:
   ```powershell
   Resolve-DnsName -Type SRV _ldap._tcp.dc._msdcs.lab.example.test -Server 10.10.10.10
   ```
   Když tento dotaz odpoví, DNS na DC01 je z klienta dostupné. Porovnání s dotazem bez parametru `-Server` pomůže odhalit chybný DNS server klienta; samo neověřuje všechny doménové služby.

## Oprava a ověření

Vrátit DNS na 10.10.10.10, `Clear-DnsClientCache`, zopakovat oba příkazy z úvodu a `Test-ComputerSecureChannel`. Vypínat firewall není řešení.

## Výsledek 14. 10. 2026

| Krok | Výsledek |
|---|---|
| Před změnou | SRV dotaz vrátil `dc01.lab.example.test` |
| DNS 10.10.10.99 | SRV dotaz skončil timeoutem (`ERROR_TIMEOUT`) |
| Dotaz přímo na 10.10.10.10 | vrátil `dc01.lab.example.test`, server tedy fungoval |
| Po vrácení DNS 10.10.10.10 | SRV dotaz opět prošel, secure channel `True` |

V tomto běhu se měřil DNS dotaz; `nltest` a přihlášení nového uživatele se během závady nezkoušely. [Výsledky v JSON](../evidence/baseline.json) (část `DnsIncident`).

## Co si z toho odnést

Počítač může mít funkční síť, a přesto doménu nenajde. Server pro přihlášení hledá přes DNS, a když se ptá špatného DNS serveru, nedozví se, kde je.
