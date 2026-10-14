# Odepřený přístup ke složce

**Co hlásí uživatel:** „Včera jsem se do složky dostala, dnes mi to píše přístup odepřen.“

## Jak závadu navodit

Na DC01 odebrat `anna.lab` ze skupiny `GG_LabStaff`. Oprávnění složky neměnit. Na PC01 Annu odhlásit a znovu přihlásit.

## Jak se projeví

Otevření `\\DC01\LabShare\welcome.txt` skončí hláškou o odepřeném přístupu.

## Jak ji najít

1. Je to opravdu oprávnění, a ne síť? `Test-NetConnection DC01 -Port 445` projde, takže server je dostupný. Chyba sítě vypadá jinak než „přístup odepřen“.
2. `whoami /groups` na PC01 – ve kterých skupinách uživatelka právě je.
3. Na DC01 členství skupiny v Active Directory.
4. Na DC01 oprávnění složky:
   ```powershell
   Get-SmbShareAccess LabShare
   icacls C:\LabShare
   ```
   Oprávnění složky jsou v pořádku, chybí jen členství ve skupině.

## Oprava a ověření

Vrátit Annu do skupiny, odhlásit a přihlásit, zopakovat čtení i zápis. Zkontrolovat, že Petr přístup dál nemá. Dát všem plný přístup, „aby to fungovalo“, není oprava.

## Co si z toho odnést

Přístup ke sdílené složce rozhodují tři věci: oprávnění sdílení, oprávnění na disku a členství uživatele ve skupině. Změna členství se projeví až po novém přihlášení, proto první rada uživateli bývá odhlásit se a přihlásit.
