# Zakázaný účet

**Co hlásí uživatel:** „Nepustí mě to do počítače, heslo mám správně.“

## Jak závadu navodit

Na DC01 v Active Directory Users and Computers zakázat účet `anna.lab` (Disable Account). Na PC01 Annu odhlásit.

## Jak se projeví

Nové přihlášení skončí hláškou, že účet byl zakázán. Server musí být při pokusu zapnutý; bez něj by Windows mohl pustit uživatele podle zapamatovaného přihlášení.

## Jak ji najít

Na DC01:

```powershell
Get-ADUser anna.lab -Properties Enabled,LockedOut,PasswordExpired |
  Select-Object SamAccountName,Enabled,LockedOut,PasswordExpired
```

Výpis rozliší tři různé příčiny, které uživatel popisuje stejně:

| Stav | Co znamená | Řešení |
|---|---|---|
| `Enabled = False` | účet někdo zakázal | povolit účet |
| `LockedOut = True` | příliš mnoho špatných hesel | odemknout účet |
| `PasswordExpired = True` | vypršela platnost hesla | nastavit nové heslo |

## Oprava a ověření

Účet povolit (Enable Account), přihlásit se na PC01, ověřit `whoami` a přístup ke sdílené složce. Měnit heslo není potřeba.

## Co si z toho odnést

Zakázaný a zamčený účet nejsou totéž. Odemčení zakázanému účtu nepomůže a reset hesla také ne; nejdřív je potřeba zjistit, o který stav jde.
