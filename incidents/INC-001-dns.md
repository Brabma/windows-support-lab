# Počítač nenajde doménu

**Co hlásí uživatel:** „Nejde mi přihlášení, píše to, že doména není dostupná.“

## Jak závadu navodit

Na PC01 změnit DNS server z 10.10.10.10 na 10.10.10.99 (adresa, na které nic není). Adresu počítače ani kabel neměnit.

## Jak se projeví

```powershell
Resolve-DnsName -Type SRV _ldap._tcp.dc._msdcs.lab.example.test
nltest /dsgetdc:lab.example.test /force
```

Oba příkazy selžou. Počítač si část odpovědí pamatuje, takže se závada nemusí ukázat hned; paměť vyčistí `Clear-DnsClientCache`.

## Jak ji najít

1. `ipconfig /all` – jakou má počítač adresu a jaký DNS server.
2. Zeptat se přímo správného serveru:
   ```powershell
   Resolve-DnsName -Type SRV _ldap._tcp.dc._msdcs.lab.example.test -Server 10.10.10.10
   ```
   Když tohle odpoví, server je v pořádku a chyba je v nastavení počítače.

## Oprava a ověření

Vrátit DNS na 10.10.10.10, `Clear-DnsClientCache`, zopakovat oba příkazy z úvodu a `Test-ComputerSecureChannel`. Vypínat firewall není řešení.

## Co si z toho odnést

Počítač může mít funkční síť, a přesto doménu nenajde. Server pro přihlášení hledá přes DNS, a když se ptá špatného DNS serveru, nedozví se, kde je.
