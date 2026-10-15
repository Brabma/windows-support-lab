# Zásada se neprojevila

**Co hlásí uživatel:** „Kolega má Ovládací panely zamčené a já ne.“

## Jak závadu navodit

Na DC01 v Active Directory Users and Computers přesunout účet `anna.lab` z OU `Lab/Users` o úroveň výš do OU `Lab`. Zásadu ani její připojení neměnit. Účet `petr.lab` zůstává v OU `Lab/Users`. Na PC01 se Anna odhlásí, znovu přihlásí a spustí `gpupdate /force`.

## Jak se projeví

Anně jdou Ovládací panely otevřít a zásada chybí ve výpisu použitých zásad. U Petra zůstávají zablokované.

## Jak ji najít

```powershell
gpresult /r /scope:user
```

Na DC01:

```powershell
Get-ADUser anna.lab | Select-Object DistinguishedName
Get-ADUser petr.lab | Select-Object DistinguishedName
```

Projít postupně:

1. Je přihlášený správný uživatel a je ve správné OU?
2. Je zásada k OU připojená a je připojení zapnuté (Link Enabled)?
3. Smí ji uživatel číst a použít (Security Filtering)? Od aktualizace MS16-072 musí uživatelskou zásadu číst i účet počítače. Při úpravě Security Filtering proto na záložce Delegation zůstává Authenticated Users (nebo Domain Computers) s oprávněním Read.
4. Je server dostupný? (`nltest /dsgetdc:lab.example.test`)

Tahle zásada se týká uživatele, ne počítače. Rozhoduje tedy, ve které OU je účet Anny, ne kde je PC01. Porovnání `DistinguishedName` obou účtů ukáže rozdíl.

## Oprava a ověření

Vrátit účet `anna.lab` do OU `Lab/Users`, na PC01 se odhlásit, přihlásit, spustit `gpupdate /force`, zkontrolovat `gpresult` a zkusit otevřít Ovládací panely.

## Co si z toho odnést

Zásada působí ve třech krocích: je vytvořená, je připojená k OU a je použitá u konkrétního uživatele. Selhat může každý z nich a `gpresult` ukáže, u kterého to skončilo. Stejný výsledek by mělo vypnutí připojení zásady, to by se ale projevilo u všech uživatelů v OU najednou.
