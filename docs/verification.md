# Jak se ověřuje funkční stav

| Oblast | Kontrola |
|---|---|
| Síť a DNS | ipconfig /all; Resolve-DnsName pro LDAP SRV záznam domény |
| Doména | nltest /dsgetdc:lab.example.test; Test-ComputerSecureChannel |
| Sdílení | Čtení, vytvoření a smazání souboru jako Anna; zamítnutí přístupu jako Petr |
| Zásady | gpresult v Annině relaci a skutečné otevření Ovládacích panelů |
| Oprava incidentu | Opakování stejné kontroly před závadou, při ní a po opravě |
| Návrat | Odpovídající snapshoty obou VM; kontrola času, DNS a secure channel |

Konkrétní výsledky jsou v [ověření základu](../evidence/baseline.md). Každý [scénář](../README.md#scénáře-závad) uvádí vlastní podmínky úspěchu.
