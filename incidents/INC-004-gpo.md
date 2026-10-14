# Zásada se neprojevila

**Co hlásí uživatel:** „Kolega má Ovládací panely zamčené a já ne.“

## Jak závadu navodit

Na DC01 v Group Policy Management vypnout připojení zásady `LAB-User-ControlPanel` ke složce `Users` (Link Enabled). Zásadu samotnou nemazat. Na PC01 jako Anna spustit `gpupdate /force`.

## Jak se projeví

Ovládací panely jdou otevřít a zásada chybí ve výpisu použitých zásad.

## Jak ji najít

```powershell
gpresult /r /scope:user
```

Projít postupně:

1. Je přihlášený správný uživatel a je ve správné složce Active Directory?
2. Je zásada ke složce připojená a je připojení zapnuté?
3. Smí ji uživatel číst (Security Filtering)?
4. Je server dostupný? (`nltest /dsgetdc:lab.example.test`)

Tahle zásada se týká uživatele, ne počítače. Rozhoduje tedy, kde v Active Directory je účet Anny, ne kde je PC01.

## Oprava a ověření

Zapnout připojení zásady, `gpupdate /force`, zkontrolovat `gpresult` a zkusit otevřít Ovládací panely.

## Co si z toho odnést

Zásada existuje ve třech krocích: je vytvořená, je připojená ke složce a je použitá u konkrétního uživatele. Selhat může každý z nich a `gpresult` ukáže, u kterého to skončilo.
