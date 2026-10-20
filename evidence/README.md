# Výsledky kontrol

| Soubor | Co obsahuje |
|---|---|
| [baseline.json](baseline.json) | výchozí stav 14. 10. 2026: stanice v doméně, přístup Anny a Petra, použitá GPO, průběh tiketu T-001 |
| [INC-002-share.json](INC-002-share.json) | tiket T-002: přístup před závadou, během ní a po opravě, kontrola, že se oprávnění složky nezměnila |
| [T-003-account.json](T-003-account.json) | tiket T-003: stav účtu před zakázáním, odmítnuté přihlášení, diagnostika, událost 4725 a ověření po povolení |
| [health-checks.json](health-checks.json) | běh `Test-LabHealth.ps1` 14. 10.: DC01 13/13, PC01 8/8 |
| [health-dc01-20261015.json](health-dc01-20261015.json) | opakovaný běh na DC01 15. 10.: 13/13, včetně SHA-256 spuštěného skriptu |
| [anna-control-panel-blocked.png](anna-control-panel-blocked.png) | Ovládací panely zablokované zásadou v Annině relaci |

Hash v souboru z 15. 10. se shoduje se skriptem v tomto repozitáři. Kontrolní skript ověřuje konfiguraci a dostupnost služeb, ne oprávnění běžných uživatelů; ta se ověřují zvlášť pod jejich účty.

Výpisy jsou zkrácené na vybraná pole. Hesla a úplné logy v repozitáři nejsou.
