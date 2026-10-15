# Opakovatelná provozní kontrola — 14. 10. 2026

Skript [Test-LabHealth.ps1](../scripts/Test-LabHealth.ps1) běžel na DC01 i PC01 v administrátorském Windows PowerShellu. Do obou strojů byl předaný přes VirtualBox Guest Control. Výsledky níže pocházejí z jeho skutečného běhu.

| Stroj | Kontroly | Výsledek |
|---|---|---|
| DC01 | doména, IPv4, DNS, chybějící brána, A/SRV odpovědi, TCP445, DNS/NTDS/Netlogon/ADWS/DFSR, publikované sdílení | 13/13, Passed=true |
| PC01 | doména, IPv4, DNS, chybějící brána, A/SRV odpovědi, TCP445 a secure channel | 8/8, Passed=true |

[Strukturované výsledky](health-checks.json) obsahují čas UTC a jednotlivá pozorování. Neslouží jako potvrzení všech uživatelských oprávnění, zálohy, aplikování GPO či aktuálnosti oprav. Tyto věci vyžadují jiné testy.

DC01 používá vlastní DNS přes 127.0.0.1, PC01 se ptá na 10.10.10.10; skript rozlišuje obě role a ověřuje skutečnou odpověď DNS. Kontrola TCP 445 na DC01 dokládá místní naslouchání služby; síťovou cestu ověřuje PC01.

Od 15. října skript při spuštění ze souboru přidává `ScriptSha256`, aby se nový výsledek dal spojit s konkrétní verzí. Historický výstup z 14. října hash neobsahuje a není dodatečně přepisovaný. Jeho zdroj patří k revizi `9fd02c7`. Při vložení kódu přímo do relace bude hash `null`; pro dohledatelné měření spouštět uložený soubor.

Opakovaná kontrola 15. října: [DC01 prošel 13/13](health-dc01-20261015.json) a hash spuštěného souboru se shodoval s veřejným skriptem. PC01 byl vypnutý, proto se klientská kontrola neopakovala; výsledek 8/8 výše pochází ze 14. října.

Skript nic neopravuje. Při neúspěchu vypíše JSON s konkrétní kontrolou a skončí chybou. Mimo DC01 a PC01 se odmítne spustit.
