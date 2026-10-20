# T-001 Počítač nenajde doménu

| | |
|---|---|
| Uživatel | anna.lab, PC01 |
| Hlášení | „Nejde mi přihlášení, píše to, že doména není dostupná.“ |
| Priorita | vysoká, uživatel nemůže pracovat |
| Stav | vyřešeno 14. 10. 2026 |

## Diagnostika

1. `ipconfig /all` – adresa počítače je v pořádku, ale jako DNS server je nastavená `10.10.10.99` místo `10.10.10.10`.
2. Dotaz na záznam, podle kterého počítač hledá řadič domény:
   ```powershell
   Resolve-DnsName -Type SRV _ldap._tcp.dc._msdcs.lab.example.test
   ```
   Skončil `ERROR_TIMEOUT`.
3. Stejný dotaz přímo na server:
   ```powershell
   Resolve-DnsName -Type SRV _ldap._tcp.dc._msdcs.lab.example.test -Server 10.10.10.10
   ```
   Vrátil `dc01.lab.example.test`. Server funguje, chyba je v nastavení počítače.

## Příčina

Na PC01 byl nastavený špatný DNS server. Závada byla v labu navozena záměrně.

## Řešení a ověření

DNS vrácen na `10.10.10.10`, vyčištěna mezipaměť (`Clear-DnsClientCache`). SRV dotaz znovu vrací `dc01.lab.example.test` a `Test-ComputerSecureChannel` vrací `True`. Výsledky jsou v [evidence/baseline.json](../evidence/baseline.json), část `DnsIncident`.

## Odpověď uživateli

> Dobrý den, váš počítač měl špatně nastavenou adresu serveru, přes který hledá firemní síť. Nastavení jsem opravil, přihlášení by už mělo fungovat. Kdyby se problém vrátil, ozvěte se prosím.

## Poznámka

Síť může fungovat a počítač přesto doménu nenajde, protože řadič domény hledá přes DNS. Uživatel, který se na počítači už dřív přihlásil, se může dostat dovnitř díky uloženým údajům, takže závada se nemusí projevit u všech stejně.
