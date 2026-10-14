# Pracovní požadavky: účet a přístupy zaměstnance

**Stav: připravený postup pro společnou práci. Celý nástup/odchod podle tohoto dokumentu zatím neproběhl.** Anna a Petr slouží k ověření rozdílných oprávnění; to není dokončený nový onboarding.

## CHG-001: nástup zaměstnance

Modelový požadavek: nový zaměstnanec potřebuje běžný doménový účet, přihlášení na PC01 a změny dokumentů v LabShare. Administrátorská práva nepotřebuje. Použít nový jednoznačný laboratorní účet; existující účty nepřepisovat.

| Krok správce | Co při něm sledovat | Důkaz dokončení |
|---|---|---|
| V AD Users and Computers najít OU Users | OU versus účet a skupina | objekt ve správné OU |
| Vytvořit běžný účet | UPN, jméno a Enabled | vybrané vlastnosti bez hesla |
| Přiřadit GG_LabStaff | přístup přes skupiny | členství a vnoření do DL |
| Přihlásit uživatele na PC01 | doménový versus místní účet | whoami a kontakt s DC |
| Otevřít sdílení a vytvořit testovací soubor | SMB a NTFS | čtení, zápis a odstranění probe |
| Ověřit GPO | uživatelská OU a výsledná politika | gpresult a chování |

Heslo zadat soukromě, neukládat do veřejného skriptu ani snímku. Reset hesla je samostatný požadavek; heslo stávajícího správce neměnit.

## CHG-002: změna pracovního zařazení

Odebrat pouze přístupovou skupinu, vytvořit novou přihlašovací relaci a ověřit odmítnutí LabShare. Přihlášení do domény může dál fungovat. Tento rozdíl jsme technicky ověřili na Anně v [INC-002](../incidents/INC-002-share.md), celý požadavek s novým účtem teprve provedeme.

## CHG-003: odchod zaměstnance

Zaznamenat původní stav a zakázat pouze nový testovací účet. Nemazat účet ani dokumenty. Při dostupném DC ověřit odmítnutí nového přihlášení; existující relace a cached logon nejsou totéž. Popsat návrat labu a ověřit funkčního správce.

Výstup každého požadavku: zadání → původní stav → změna → test → výsledek. Nevyplňovat úspěch před provedením.
