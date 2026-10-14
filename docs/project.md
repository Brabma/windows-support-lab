# Scénář projektu: IT pro malou kancelář

Kancelář má jeden server, jeden cvičný pracovní počítač a dva zaměstnance. Anna pracuje se společnými dokumenty; Petr ke stejnému sdílení oprávnění nemá. Správce zajišťuje funkční přihlášení, nalezení serveru, přístup podle skupin a jednotné nastavení Windows.

Jde o model běžných správních úkolů. Zařízení, účty a soubory jsou laboratorní. Technická kontrola Codexem a samostatné provedení autorem jsou dva různé stavy.

## Dosud postavené prostředí

| Úkol | Výsledek | Ověření |
|---|---|---|
| Připravit server a stanici | DC01 a PC01 v izolované síti | verze OS a konfigurace VM, [evidence](../evidence/baseline.md) |
| Zprovoznit adresář firmy | AD DS, doména lab.example.test a OU | stav služeb, doména a členství PC01 |
| Umožnit klientovi najít server | vlastní DNS, A a LDAP SRV | dotaz z PC01 a kontakt s DC |
| Zavést účty a přístupové role | Anna → GG_LabStaff → DL_LabShare_Modify | AD členství a test pod Annou/Petrem |
| Zpřístupnit dokumenty | SMB LabShare a NTFS Modify | čtení/zápis/smazání vlastního probe, kontrola zamítnutí |
| Nastavit pracovní prostředí | GPO blokující Ovládací panely | gpresult, registr a skutečný dialog Restrictions |
| Opakovat provozní kontrolu | skript Test-LabHealth.ps1 | [zachycené výsledky](../evidence/health-checks.md) |

## Servisní případy

| Případ | Co se diagnostikuje | Stav |
|---|---|---|
| [INC-001: počítač nenajde doménu](../incidents/INC-001-dns.md) | DNS klienta versus dostupnost správného serveru | reprodukováno a opraveno Codexem |
| [INC-002: Anna nemůže otevřít složku](../incidents/INC-002-share.md) | síť versus přístupová skupina, nový token | reprodukováno a opraveno Codexem přes nové příkazové relace |
| [INC-003: uživatel se nepřihlásí](../incidents/INC-003-account.md) | zakázaný účet versus zamčení a heslo | připravené zadání |
| [INC-004: nastavení Windows se neuplatní](../incidents/INC-004-gpo.md) | GPO, odkaz na OU a výsledná zásada | připravené zadání; původní GPO již ověřená |
| [INC-005: zapomenuté heslo a zamčený účet](../incidents/INC-005-password.md) | reset hesla, zamčení a jejich rozlišení | připravené zadání v navazující dokumentaci |
| [INC-006: posunutý čas](../incidents/INC-006-time.md) | doménový čas a získání Kerberos lístku | připravené zadání; porucha není v tomto běhu provedena |

Záznam případu obsahuje hlášení, stav před změnou, kontroly, prokázanou příčinu, opravu a opakovaný test. Screenshot doplňuje výsledek; nenahrazuje vysvětlení.

## Práce během učení

Před změnou otevřít příslušný nástroj, přečíst současný stav a vysvětlit souvislosti. U přístupů nejprve zobrazit účet a skupiny, pak oprávnění sdílení a nakonec zkusit soubor pod běžným účtem. Teprve potom měnit konfiguraci.

Používané nebo k procvičení připravené nástroje: Server Manager, Active Directory Users and Computers, DNS Manager, Group Policy Management, Průzkumník, Event Viewer a PowerShell. Dosavadní příkazové ověření nedokládá samostatnou práci autora ve všech těchto konzolách.

## Další etapy

Tyto položky jsou plán práce, nikoli hotové součásti infrastruktury.

| Etapa | Výstup | Podmínka dokončení |
|---|---|---|
| Nástup zaměstnance | [provedený požadavek na účet a přístup](../operations/employee-lifecycle.md) | nový běžný účet se přihlásí a má právě přidělené přístupy |
| Změna přístupů a odchod | záznam odebrání skupiny a zakázání účtu | ověřen nový pokus o přístup a obnoven výchozí lab |
| DHCP | scope např. 10.10.10.100–150, DNS .10, server staticky .10 | PC dostane lease a DNS; doména a SMB fungují; zdokumentován návrat na statickou .20 |
| GPO pro síťový disk | mapování disku podle skupiny | Anna disk dostane, Petr ne; kontrola výsledné zásady |
| Záloha a obnova souboru | samostatná záloha a obnovený testovací dokument | shodný hash obsahu a správná oprávnění; snapshot nestačí |
| Události a služby | vysvětlený záznam z Event Vieweru a kontrola služby | korelace události s časem pokusu; rozlišen důkaz a hypotéza |
| Aktualizace | provozní postup a audit oprav | ověřená cesta k aktualizacím, návrat sítě a funkční testy |

DHCP lze ověřit na stejných dvou VM. Nevytváří se most do domácí LAN. Výchozí brána se u izolovaného segmentu nenastavuje jen pro vyplnění políčka. DHCP není router ani DNS. Zdroje: [Microsoft AD DS](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview), [Microsoft DHCP](https://learn.microsoft.com/en-us/windows-server/networking/technologies/dhcp/dhcp-top).
