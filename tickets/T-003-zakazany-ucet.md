# T-003 Uživatelka se nemůže přihlásit, heslo má správně

| | |
|---|---|
| Uživatel | anna.lab, PC01 |
| Hlášení | „Nepustí mě to do počítače, a heslo mám určitě správně.“ |
| Priorita | vysoká, uživatelka nemůže pracovat |
| Stav | vyřešeno 18. 10. 2026 |

## Diagnostika

1. Nové přihlášení Anny na PC01 (zkoušené přes VirtualBox Guest Control) bylo odmítnuto s chybou, že účet je omezený a nelze ho použít k přihlášení. DC01 přitom odpovídal, takže nešlo o síť.
2. Na DC01 stav účtu:
   ```powershell
   Get-ADUser anna.lab -Properties Enabled,LockedOut,PasswordExpired |
     Select-Object SamAccountName,Enabled,LockedOut,PasswordExpired
   ```
   `Enabled=False`, `LockedOut=False`, `PasswordExpired=False`. Účet není zamčený ani nemá prošlé heslo, je zakázaný.
3. Přehled zakázaných a zamčených účtů v doméně:
   ```powershell
   Search-ADAccount -AccountDisabled -UsersOnly
   Search-ADAccount -LockedOut -UsersOnly
   ```
   Mezi zakázanými je kromě vestavěných `krbtgt` a `Guest` jen `anna.lab`, zamčený není nikdo.
4. Kdo a kdy účet zakázal, ukáže v protokolu Security na DC01 událost 4725:
   ```powershell
   Get-WinEvent -FilterHashtable @{LogName='Security'; Id=4725} -MaxEvents 5
   ```
   Záznam ze 14:14:04 UTC pro `anna.lab`.

## Příčina

Účet `anna.lab` byl v Active Directory zakázaný. Závada byla v labu navozena záměrně.

## Řešení a ověření

Než se účet znovu povolí, je potřeba zjistit, proč byl zakázaný. Ve firmě to často znamená odchod zaměstnance nebo bezpečnostní opatření, takže se povolení ověřuje u vedoucího nebo podle tiketu, který zakázání nařídil. V labu šlo o zkoušku.

```powershell
Enable-ADAccount anna.lab
```

Po povolení se Anna přihlásí a na sdíleném disku čte, zapisuje i maže soubory. Heslo se neměnilo. Výsledky jsou v [evidence/T-003-account.json](../evidence/T-003-account.json).

## Odpověď uživateli

> Dobrý den, váš účet byl v systému vypnutý, proto vás počítač nepustil, i když jste heslo zadávala správně. Účet jsem po ověření znovu zapnul a přihlášení už funguje. Heslo měnit nemusíte.

## Poznámka

Uživatel popíše stejně tři různé situace. Zakázaný účet se povolí, zamčený účet (moc špatných pokusů o heslo) se odemkne a prošlé heslo se změní. Odemčení zakázanému účtu nepomůže a reset hesla také ne, proto je první krok zjistit, o kterou situaci jde.
