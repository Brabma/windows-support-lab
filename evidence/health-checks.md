# Opakovatelná provozní kontrola — 14. 10. 2026

Skript [Test-LabHealth.ps1](../scripts/Test-LabHealth.ps1) běžel na DC01 i PC01 v administrátorském Windows PowerShellu. Do obou strojů byl předaný přes VirtualBox Guest Control. Výsledky níže pocházejí z jeho skutečného běhu.

| Stroj | Kontroly | Výsledek |
|---|---|---|
| DC01 | doména, IPv4, DNS, chybějící brána, A/SRV odpovědi, TCP445, DNS/NTDS/Netlogon/ADWS/DFSR, publikované sdílení | 13/13, Passed=true |
| PC01 | doména, IPv4, DNS, chybějící brána, A/SRV odpovědi, TCP445 a secure channel | 8/8, Passed=true |

[Strukturované výsledky](health-checks.json) obsahují čas UTC a jednotlivá pozorování. Neslouží jako potvrzení všech uživatelských oprávnění, zálohy, aplikování GPO či aktuálnosti oprav. Tyto věci vyžadují jiné testy.

Při vývoji se opravilo příliš úzké očekávání DNS na DC: server ve skutečnosti používá vlastní DNS přes 127.0.0.1. PC01 používá 10.10.10.10. Síť se kvůli testu nepřenastavovala. Konečný veřejný skript rozlišuje role a kontroluje také skutečnou odpověď DNS.

Skript nic neopravuje. Při neúspěchu vypíše JSON s konkrétní kontrolou a skončí chybou. Mimo DC01 a PC01 se odmítne spustit.
