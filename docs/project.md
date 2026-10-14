# Přehled labu a praktických pokusů

Základem jsou DC01 a PC01 ve stejné síti. Na jejich nastavení se dá sledovat, jak spolu souvisejí IP adresy, DNS, doménové přihlášení, skupiny a přístup k souborům. Účty Anna a Petr slouží k porovnání různých oprávnění.

## Hotové části

| Oblast | Co je nastavené | Kde je výsledek |
|---|---|---|
| Windows a virtualizace | Server 2025, Windows 11 a izolovaná síť | [funkční základ](../evidence/baseline.md) |
| Active Directory | doména, OU, účty, skupiny a připojený klient | [nastavení domény](02-baseline.md) |
| DNS | A a LDAP SRV záznamy, nalezení řadiče z klienta | [diagnostika](../evidence/health-checks.md) |
| Sdílení | LabShare, oprávnění SMB a NTFS přes vnořené skupiny | [pokus s přístupem](../incidents/INC-002-share.md) |
| GPO | uživatelská zásada blokující Ovládací panely | [výsledek v klientovi](../evidence/baseline.md) |
| PowerShell | kontrola konfigurace a dostupnosti služeb | [skript a jeho výsledky](../evidence/health-checks.md) |

## Servisní případy

Složka incidents obsahuje pokusy, při kterých se mění jedna část konfigurace a sleduje její vliv. První dva už mají skutečné výsledky; ostatní jsou postupy k vyzkoušení.

| Pokus | Co se na něm zkoumá | Stav |
|---|---|---|
| [INC-001: DNS](../incidents/INC-001-dns.md) | nalezení domény při nesprávném DNS | provedeno, opraveno |
| [INC-002: sdílení](../incidents/INC-002-share.md) | skupina, přihlašovací token a přístup ke složce | provedeno, opraveno |
| [INC-003: účet](../incidents/INC-003-account.md) | rozdíl mezi zakázaným a zamčeným účtem | k vyzkoušení |
| [INC-004: GPO](../incidents/INC-004-gpo.md) | propojení zásady s OU a její účinek | k vyzkoušení |
| [INC-005: heslo](../incidents/INC-005-password.md) | reset hesla, zamykání a účinná politika | k vyzkoušení |
| [INC-006: čas](../incidents/INC-006-time.md) | synchronizace času a získání Kerberos lístku | k vyzkoušení |

U každého pokusu se porovnává původní stav, chování po změně a výsledek po obnovení nastavení. Součástí je stručné vysvětlení příčiny.

## Další etapy

| Oblast | Co vyzkoušet | Co pozorovat |
|---|---|---|
| [Účty a skupiny](../operations/employee-lifecycle.md) | vytvoření účtu, přidání a odebrání skupiny, zakázání účtu | rozdíl mezi přihlášením a přístupem k souboru |
| DHCP | scope, lease a rezervace; přechod klienta ze statické adresy | přidělenou IP, masku a DNS; server zůstává staticky .10 |
| Síťová komunikace | zachycení DNS dotazu a komunikace klient–server | adresy, porty a protokoly ve skutečných paketech |
| GPO pro síťový disk | mapování podle přístupové skupiny | výslednou zásadu a zobrazení disku pod různými účty |
| Záloha a obnova | samostatná kopie a obnovení testovacího souboru | shodu obsahu a původní oprávnění |
| Služby a události | stav služby, její start a související události | návaznost času pokusu a záznamu v Event Vieweru |
| Testování aplikace | funkční a negativní testy, API a jednoduché SQL dotazy | očekávaný výsledek, skutečné chování a opakování po opravě |

Na další síťové pokusy stačí současné dva stroje. Přehled pojmů je v [concepts.md](concepts.md), jejich technické zdroje v [sources.md](sources.md).
