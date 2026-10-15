# Jak se ověřuje funkční stav

| Oblast | Kontrola |
|---|---|
| Síť a DNS | ipconfig /all; Resolve-DnsName pro LDAP SRV záznam domény |
| Doména | nltest /dsgetdc:lab.example.test; Test-ComputerSecureChannel |
| Sdílení | Čtení, vytvoření a smazání souboru jako Anna; zamítnutí přístupu jako Petr |
| Zásady | gpresult v Annině relaci a skutečné otevření Ovládacích panelů |
| Oprava incidentu | Opakování stejné kontroly před závadou, při ní a po opravě |
| Návrat | Odpovídající snapshoty obou VM; kontrola času, DNS a secure channel |

Konkrétní výsledky jsou v [ověření základu](../evidence/baseline.md). Každý [scénář](project.md#servisní-případy) uvádí vlastní podmínky úspěchu.

## Provedené ověření a jeho rozsah

| Výsledek | Konkrétní důkaz |
|---|---|
| DNS incident reprodukovaný a opravený | [INC-001](../incidents/INC-001-dns.md) |
| Po odebrání skupiny je přístup odmítnutý; po vrácení Anna čte, píše a maže, Petrovi je dál odepřeno; ACL se nezměnily | [INC-002, nové příkazové přihlašovací relace](../incidents/INC-002-share.md), [výsledky](../evidence/INC-002-share.json) |
| Kontrolní skript: DC01 13/13, PC01 8/8 | [metoda a skutečné výstupy](../evidence/health-checks.md) |
| GPO skutečně blokuje Ovládací panely | [základ a snímek](../evidence/baseline.md) |

INC-003 až INC-006 jsou postupy k vyzkoušení. U INC-002 každý test použil novou příkazovou relaci běžného účtu. DHCP, obnova zálohy a kontrola aktualizací budou následovat.

Původní výpisy jsou v soukromé složce. Veřejné důkazy se vybírají po jednotlivých polích a kontrolují; hesla, hostitelské údaje a kompletní původní logy se nezveřejňují.
