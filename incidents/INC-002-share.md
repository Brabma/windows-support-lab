# INC-002 — odepřený přístup ke sdílení

**Ověřeno 14. 10. 2026.** Pokus proběhl na PC01 pod účty Anny a Petra. Každý test použil nové příkazové přihlášení přes VirtualBox Guest Control; nešlo o odhlášení a přihlášení na plochu.

## Servisní záznam

**Hlášení:** Anna nemůže otevřít `\\DC01\LabShare\welcome.txt`; dostává odepřený přístup.

| Kontrola | Před poruchou | Během poruchy | Po opravě |
|---|---|---|---|
| Anna přečte soubor | ano | ne, UnauthorizedAccessException | ano |
| Anna vytvoří a smaže vlastní testovací soubor | ano | nezkoušeno po odmítnutí čtení | ano |
| DNS úplného názvu serveru | 10.10.10.10 | 10.10.10.10 | 10.10.10.10 |
| Spojení na TCP 445 | dostupné | dostupné | dostupné |
| Skupiny GG_LabStaff a DL_LabShare_Modify v novém tokenu Anny | původní přístup ověřen | obě chybí | obě přítomné |

V JSON znamená `false` u zápisu a mazání během poruchy, že se po odmítnutém čtení už nezkoušely.

**Příčina:** záměrně odebrané členství `anna.lab` ve skupině `GG_LabStaff`. Skupina je vnořená do `DL_LabShare_Modify`, která opravňuje přístup ke sdílení a souborům. Účet zůstával platný a server dostupný.

**Oprava:** vráceno původní členství a provedeno nové přihlášení pro ověření. Anna opět čte, zapisuje a maže svůj jedinečný testovací soubor. Petr má nadále odepřený přístup. SMB oprávnění i NTFS SDDL jsou před poruchou a po opravě shodné. Žádná záměrná porucha nezůstává.

**Co z toho plyne:** dostupný server neznamená povolený přístup. Nejprve ověř spojení, potom identitu a skupiny uživatele, oprávnění sdílení a NTFS. Oprava členství neznamená okamžitou změnu již existujícího přihlašovacího tokenu; ověřuj v nové relaci.

Kontroly: `Resolve-DnsName dc01.lab.example.test`, `Test-NetConnection DC01 -Port 445`, skupinové SID aktuální identity, členství v AD, `Get-SmbShareAccess LabShare` a NTFS ACL. Čistě DNS dotaz na krátké `DC01` při úvodní kontrole vracel SERVFAIL; úplné jméno vracelo správnou adresu a běžný Windows resolver i skutečné čtení přes krátkou UNC cestu fungovaly. Nastavení DNS kvůli tomu nebylo měněno; vyčištěna pouze klientská cache. Přesný mechanismus překladu krátkého jména nebyl měřen.

[Vybrané výsledky testů](../evidence/INC-002-share.json), závěrečné `Passed=true`. Hesla, původní výpisy, skupinové SID a úplné ACL zůstávají v soukromé složce; veřejný výřez obsahuje výsledky a kontroly zachování práv.

## Postup pro vlastní opakování

Před změnou Anna musí prokazatelně číst i zapisovat.

Na DC01 odeber pouze `anna.lab` ze skupiny GG_LabStaff. Neměň současně NTFS ani SMB ACL. Na PC01 Annu úplně odhlásit a znovu přihlásit, aby získala nový token. Reprodukuj přístup k `\\DC01\LabShare\welcome.txt`.

Diagnóza: `whoami /groups` na PC01, členství v AD na DC01, SMB oprávnění a `icacls C:\LabShare`. Ověř TCP 445 a rozlišení DC01. Síťová chyba není stejná jako Access denied. Zaznamenej, zda nebylo použito jiné uložené SMB přihlášení.

Oprava: vrátit původní členství; nová relace; zopakovat čtení i zápis. Petr musí nadále nemít přístup. Nedávat Everyone Full Control jen proto, aby test prošel.

Při opakování porovnej oprávnění sdílení, NTFS a členství uživatele. Která část se změnila a proč se výsledek projevil v nové relaci?
