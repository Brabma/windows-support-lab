# Instalace a nastavení

## Počítače a síť

| Počítač | Systém | vCPU / RAM | Disk | Adresa | DNS |
|---|---|---|---|---|---|
| DC01 | Windows Server 2025 Standard Evaluation | 2 / 2 GB | 64 GB | 10.10.10.10/24 | vlastní (127.0.0.1) |
| PC01 | Windows 11 Enterprise Evaluation | 2 / 4 GB | 80 GB | 10.10.10.20/24 | 10.10.10.10 |

Oba mají jednu síťovou kartu ve vnitřní síti VirtualBoxu `windows-support-isolated`. Brána ani DHCP v síti nejsou. Na aktivaci a aktualizace se karta vypnutého počítače dočasně přepne na NAT a pak se vrátí zpět.

Klient musí mít jako DNS server řadič domény. Přes DNS hledá, kde běží přihlašovací služby, a veřejné DNS servery zkušební doménu neznají.

Windows 11 Home se do domény připojit nedá, proto edice Enterprise Evaluation. PC01 má EFI, Secure Boot a TPM 2.0.

## Server DC01

1. Nainstalovat Windows Server 2025 s grafickým rozhraním, aktivovat přes dočasný NAT, nastavit jméno DC01 a pevnou adresu.
2. Přidat roli Active Directory Domain Services a povýšit server na řadič nové domény `lab.example.test` s DNS.
3. Po restartu ověřit:

```powershell
Get-ADDomain
Get-Service DNS,NTDS,Netlogon
Resolve-DnsName -Type SRV _ldap._tcp.dc._msdcs.lab.example.test
dcdiag
```

Služby běží, SRV záznam vrací `dc01.lab.example.test` na portu 389 a testy `dcdiag` (Connectivity, Advertising, SysVolCheck, NetLogons, Services) prošly.

## Pracovní stanice PC01

1. Nainstalovat Windows 11, aktivovat přes dočasný NAT, nastavit jméno PC01, adresu a DNS 10.10.10.10.
2. Ověřit, že stanice najde řadič domény:

```powershell
Resolve-DnsName DC01.lab.example.test
Test-NetConnection DC01 -Port 389
nltest /dsgetdc:lab.example.test
```

3. Připojit do domény (System → Advanced system settings → Computer Name → Change → Domain) a na serveru přesunout počítač do OU `Lab/Workstations`.
4. Po restartu se přihlásit jako `LAB\anna.lab` a ověřit `whoami` a v PowerShellu správce `Test-ComputerSecureChannel`.

Ping k ověření nestačí, firewall ho může blokovat, i když přihlášení funguje.

## Uživatelé, skupiny a sdílení

OU: `Lab/Users`, `Lab/Groups`, `Lab/Workstations`. Běžní uživatelé nejsou správci, pro správu je samostatný účet.

| Účet | Skupina | Přístup k LabShare |
|---|---|---|
| anna.lab | GG_LabStaff (vnořená do DL_LabShare_Modify) | čtení a zápis |
| petr.lab | žádná | odepřený |

Složka `C:\LabShare` je sdílená jako `\\DC01\LabShare`. Skupina `DL_LabShare_Modify` má na sdílení Change a na NTFS Modify, správci Full. Platí přísnější z obou oprávnění. V malém labu je složka přímo na řadiči domény; ve firmě by byla na samostatném souborovém serveru.

```powershell
Get-SmbShareAccess LabShare
icacls C:\LabShare
```

Na PC01 Anna přečetla `welcome.txt`, vytvořila a smazala vlastní soubor; Petrovi byl přístup odepřen. Změna členství ve skupině se projeví až po novém přihlášení.

## Skupinová zásada

GPO `LAB-User-ControlPanel` zapíná *Prohibit access to Control Panel and PC settings* (User Configuration → Administrative Templates → Control Panel) a je připojená k OU `Lab/Users`. Výchozí zásada domény se nemění.

Na PC01 jako Anna:

```powershell
gpupdate /force
gpresult /r /scope:user
```

Zásada je ve výpisu mezi použitými a Ovládací panely nejdou otevřít.

## Výchozí stav

Po dokončení se oba vypnuté počítače uložily do snapshotu `baseline-01`. Obnovují se vždy oba najednou, jinak se rozejde čas a vztah stanice s doménou.

## Zdroje

- [Windows Server 2025 Evaluation](https://www.microsoft.com/en-us/evalcenter/evaluate-windows-server-2025), [Windows 11 Enterprise Evaluation](https://www.microsoft.com/en-us/evalcenter/evaluate-windows-11-enterprise)
- [AD DS](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview), [skupiny v AD](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/understand-security-groups), [Group Policy](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/group-policy/group-policy-overview)
- [VirtualBox 7.2](https://docs.oracle.com/en/virtualization/virtualbox/7.2/user/)
