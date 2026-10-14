# 2. Nastavení domény

Po každém kroku je uvedeno, čím se ověří, že opravdu funguje. Příkazy se spouštějí v PowerShellu uvnitř příslušného virtuálního počítače.

## Server DC01

**1. Jméno a síť.** Server Manager → Local Server: jméno DC01, správný čas, pevná adresa.
Ověření: `ipconfig /all` ukáže adresu 10.10.10.10 a DNS 10.10.10.10.

**2. Role serveru domény.** Add roles and features → Active Directory Domain Services. Po instalaci „Promote this server“ → nová doména `lab.example.test`, DNS ponechat zapnuté. Server se restartuje.

**3. Kontrola po restartu.**

```powershell
Get-ADDomain
Get-Service DNS,NTDS,Netlogon
Resolve-DnsName -Type SRV _ldap._tcp.dc._msdcs.lab.example.test
```

Služby mají být Running a poslední příkaz má vrátit DC01. To je záznam, podle kterého počítače v síti najdou server pro přihlášení.

**4. Uživatelé a skupiny.** Active Directory Users and Computers: vytvořit složky, účty a skupiny podle [zapojení](architecture.md).

## Pracovní stanice PC01

**5. Vidí počítač server?** Oba počítače zapnuté, stejná síť, stejný čas.

```powershell
Resolve-DnsName DC01.lab.example.test
Test-NetConnection DC01 -Port 389
nltest /dsgetdc:lab.example.test
```

Ping k tomuhle nestačí; firewall ho může blokovat, i když přihlašování funguje.

**6. Připojení do domény.** System → Advanced system settings → Computer Name → Change → Domain `lab.example.test`, přihlásit se účtem správce labu, restartovat. Na serveru přesunout PC01 do složky `Lab/Workstations`.

**7. Přihlášení běžného uživatele.** Přihlásit se jako `LAB\anna.lab`.

```powershell
whoami
Test-ComputerSecureChannel      # v PowerShellu spuštěném jako správce
nltest /dsgetdc:lab.example.test
```

`whoami` ukáže, kdo je přihlášený. Windows si ale přihlášení pamatuje, takže projde i bez spojení se serverem. Že spojení opravdu funguje, potvrdí až druhé dva příkazy.

## Sdílená složka

**8. Na serveru** vytvořit `C:\LabShare` se souborem `welcome.txt` a nastavit oprávnění podle zapojení.

```powershell
Get-SmbShareAccess LabShare
icacls C:\LabShare
```

**9. Na PC01** jako Anna otevřít `\\DC01\LabShare\welcome.txt`, vytvořit a smazat zkušební soubor. Jako Petr ověřit, že přístup odepřen.
Pozor: změna členství ve skupině se projeví až po novém přihlášení.

## Firemní zásada

**10.** Na serveru v Group Policy Management vytvořit `LAB-User-ControlPanel`, zapnout zákaz Ovládacích panelů a připojit ke složce `Users`. Na PC01 jako Anna:

```powershell
gpupdate /force
gpresult /r /scope:user
```

Zásada má být ve výpisu mezi použitými a Ovládací panely nemají jít otevřít.

## Záloha funkčního stavu

**11.** Oba počítače vypnout a u obou udělat snapshot `baseline-01`. Při návratu vždy obnovit oba najednou, jinak se rozejde jejich vzájemná důvěra a čas.

Teprve z tohoto bodu má smysl pouštět se do [scénářů závad](../README.md#scénáře-závad): po každém se dá vrátit do funkčního stavu.
