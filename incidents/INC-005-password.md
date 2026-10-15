# Zapomenuté heslo a zamčený účet

**Požadavek:** „Zapomněl jsem heslo a teď už mě to nepustí vůbec.“

## Výchozí stav a příprava

Scénář používá účet `petr.lab`, PC01 a řadič DC01. Oba stroje mají společný návratový bod `baseline-01`. Příkazy správy účtu patří do PowerShellu správce na DC01.

V nastavení z 14. října je zamykání vypnuté (`LockoutThreshold=0`). Před cvičením zkontrolovat doménovou i případnou individuální politiku:

```powershell
$originalPolicy = Get-ADDefaultDomainPasswordPolicy
$originalPolicy |
  Select-Object LockoutThreshold,LockoutDuration,LockoutObservationWindow
Get-ADUserResultantPasswordPolicy petr.lab
Get-ADUser petr.lab -Properties LockedOut |
  Select-Object SamAccountName,Enabled,LockedOut
```

Prázdný výsledek druhého příkazu znamená použití doménové politiky.

V Group Policy Management vytvořit zásadu `LAB-Account-Lockout` a připojit ji ke kořeni `lab.example.test`, s pořadím odkazu 1. V Computer Configuration → Policies → Windows Settings → Security Settings → Account Policies → Account Lockout Policy nastavit práh 5 pokusů, dobu zamčení 10 minut a vynulování počítadla po 10 minutách. Nastavení se týká doménových účtů, proto zásada patří na kořen domény, nikoli na OU uživatelů. Výchozí zásada domény se nemění; alternativou pro jednotlivé účty je jemně odstupňovaná politika hesel.

Na DC01 spustit `gpupdate /force` a zopakovat první dva příkazy. Pokračovat až při účinném prahu 5 pro Petra. Na PC01 s dostupným DC01 opakovat přihlášení Petra chybným heslem a sledovat stav účtu; počet dialogů nemusí přesně odpovídat počtu zaznamenaných pokusů.

## Diagnostika

```powershell
Get-ADUser petr.lab -Properties LockedOut,BadLogonCount,LastBadPasswordAttempt |
  Select-Object SamAccountName,LockedOut,BadLogonCount,LastBadPasswordAttempt
Get-WinEvent -FilterHashtable @{LogName='Security';Id=4740} -MaxEvents 10
```

`LockedOut=True` rozlišuje zamčení od zakázaného účtu. Událost 4740 v Security na DC01 obsahuje účet a pole Caller Computer Name. V tomto labu je audit User Account Management / Success zapnutý; právě tato auditní podkategorie zaznamenává zamčení. Pole se může lišit podle původu pokusu, při opakování pomáhá dohledat zařízení se starým heslem.

## Oprava

Pokud je heslo známé, stačí odemčení:

```powershell
Unlock-ADAccount petr.lab
```

Při zapomenutém hesle nejprve ověřit totožnost žadatele. Potom v Active Directory Users and Computers použít Reset Password a zapnout „User must change password at next logon“. Programový postup zadává dočasné heslo skrytě:

```powershell
$temporaryPassword = Read-Host 'Dočasné heslo pro laboratorní účet' -AsSecureString
Set-ADAccountPassword petr.lab -Reset -NewPassword $temporaryPassword
Set-ADUser petr.lab -ChangePasswordAtLogon $true
Unlock-ADAccount petr.lab
```

## Ověření a návrat

Petr se na PC01 přihlásí a při prvním přihlášení si nastaví nové heslo; dotaz na DC01 vrátí `LockedOut=False`. Přístup Petra ke sdílení zůstává odepřený podle jeho oprávnění.

Po cvičení odstranit odkaz i zásadu `LAB-Account-Lockout` a na DC01 spustit `gpupdate /force`. V téže správcovské relaci obnovit hodnoty uložené před cvičením:

```powershell
Set-ADDefaultDomainPasswordPolicy -Identity lab.example.test `
  -LockoutThreshold $originalPolicy.LockoutThreshold `
  -LockoutDuration $originalPolicy.LockoutDuration `
  -LockoutObservationWindow $originalPolicy.LockoutObservationWindow
Get-ADDefaultDomainPasswordPolicy |
  Select-Object LockoutThreshold,LockoutDuration,LockoutObservationWindow
```

Ověření má vrátit původní práh 0 a obě desetiminutová okna. Pro úplný návrat včetně původního hesla obnovit odpovídající snapshoty obou vypnutých VM.

[Politiky zamykání](../docs/sources.md) vysvětlují rozdíl mezi odemčením, resetem hesla a povolením zakázaného účtu.

