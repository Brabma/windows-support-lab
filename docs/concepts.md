# Pojmy a jejich použití v labu

Přehled propojuje pojmy s nastavením DC01 a PC01. DHCP, práce s událostmi a obnova ze zálohy jsou další pokusy.

| Pojem | Význam v labu | Kde se ověří |
|---|---|---|
| Server a klient | DC01 poskytuje služby, PC01 je využívá | role v Server Manageru, otevření sdílení z PC01 |
| Virtuální stroj | samostatný OS využívající prostředky hostitele | VirtualBox, vCPU a RAM |
| IP adresa a podsíť | .10 a .20 identifikují rozhraní ve stejné 10.10.10.0/24 | Get-NetIPConfiguration |
| Maska /24 | prvních 24 bitů určuje síťovou část IPv4 | odpovídá 255.255.255.0 |
| Výchozí brána | cesta k jiným sítím | zde chybí; pro spojení těchto dvou strojů ve stejné síti není potřeba |
| DNS, A a SRV | A vrací IPv4, SRV pomáhá nalézt doménové služby | Resolve-DnsName a LDAP SRV |
| DHCP | automaticky přiděluje konfiguraci na dobu lease | později; nyní obě adresy ruční |
| Port a protokol | způsob komunikace a vstupní bod služby | TCP 445 pro SMB; dostupný port neprokazuje oprávnění |
| Doména a AD DS | společný adresář účtů, počítačů a skupin | lab.example.test, Get-ADDomain, Get-ADUser |
| Doménový řadič | server poskytující AD DS | DC01, NTDS a Netlogon |
| OU | uspořádání objektů a cíl odkazů zásad | Lab/Users, Groups, Workstations; OU sama nedává práva ke složce |
| Skupina a SID | skupina sdružuje identity; SID je bezpečnostní identifikátor | GG_LabStaff vnořená do DL_LabShare_Modify |
| Přihlašovací token | identita a skupiny použitelné v relaci | změnu skupiny ověřujeme novým přihlášením |
| Ověření identity | kdo přistupuje | LAB\anna.lab; doménové protokoly zahrnují Kerberos, konkrétní protokol SMB přístupu se nezachytával |
| Autorizace | co identita smí | Anna mění dokumenty, Petr má přístup odmítnutý |
| SMB a UNC | sdílení souborů a síťová cesta | \\DC01\LabShare\welcome.txt |
| NTFS a ACL | souborový systém a přístupová oprávnění | Get-Acl C:\LabShare; po síti omezují přístup také oprávnění sdílení |
| GPO a výsledná zásada | centrální nastavení a skutečný účinek | GPO na OU Users, gpresult a blokované Ovládací panely |
| Windows služba | proces spravovaný systémem | Get-Service DNS,NTDS,Netlogon |
| Událost | záznam činnosti nebo chyby | porovnání času pokusu s událostí v Event Vieweru je další krok |
| Snapshot a záloha | stav VM versus samostatná kopie pro obnovu | baseline-01 existuje; obnova zálohy je další etapa |

Technické odkazy: [sources.md](sources.md).
