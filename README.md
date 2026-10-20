# Windows Server a Active Directory

Domácí lab pro procvičování správy uživatelů, sdílených souborů a nastavení Windows. Windows Server a pracovní stanice připojená do domény běží jako dva virtuální počítače. Lze na nich sledovat, jak se změna na serveru projeví při přihlášení a práci uživatele.

## Jak je síť sestavená

- **DC01 s Windows Serverem 2025** uchovává účty a skupiny v Active Directory, zajišťuje přihlášení do domény a poskytuje sdílenou složku i skupinové zásady.
- **PC01 s Windows 11 Enterprise** představuje pracovní počítač uživatele. Zkouší se na něm přihlášení, přístup k souborům a použití zásad ze serveru.

Oba stroje běží ve VirtualBoxu na jednom fyzickém počítači. Jsou propojené vlastní sítí oddělenou od domácích zařízení.

## Co je vyzkoušené

- **Přihlášení do domény.** Účty testovacích uživatelů Anny a Petra jsou uložené na serveru. Přihlášení Anny je ověřené přímo na pracovní stanici.
- **Různá práva ke složce.** Anna může soubory číst, vytvářet a mazat, Petr má přístup odepřený. Oprávnění se přidělují přes skupiny.
- **Nastavení pomocí GPO.** Skupinová zásada blokuje běžným uživatelům Ovládací panely. Účinek je ověřený v uživatelské relaci ([snímek](evidence/anna-control-panel-blocked.png)).
- **Kontrola stavu PowerShellem.** Skript prověří síť, DNS, nalezení řadiče domény a dostupnost služeb. Uložený běh obsahuje 13 úspěšných kontrol serveru a 8 kontrol pracovní stanice; [výsledky jsou zde](evidence/README.md).

## K čemu slouží použité technologie

| Technologie | Úloha v projektu |
|---|---|
| **Active Directory** | Společná správa účtů, skupin a počítačů v doméně. |
| **DNS** | Překlad názvů na adresy a nalezení řadiče domény. |
| **SMB a oprávnění NTFS** | Sdílení souborů přes síť a určení, kdo je smí číst nebo měnit. |
| **Skupinové zásady (GPO)** | Nastavení pravidel ze serveru pro připojené počítače a uživatele. |
| **PowerShell** | Vytvoření virtuálních počítačů a kontrola konfigurace a služeb. |
| **VirtualBox** | Provoz dvou virtuálních počítačů a návrat k uloženému výchozímu stavu po pokusu. |

## Postupy a skripty

- [Nastavení sítě a serveru](docs/setup.md) – zapojení, účty, sdílení a zásady.
- [Kontrolní skript](scripts/Test-LabHealth.ps1) – vypíše výsledky jako JSON a při neúspěšné kontrole vrátí chybu.
- [Vytvoření virtuálních počítačů](scripts/New-LabVMs.ps1) – založení obou strojů přes PowerShell a VirtualBox.
