# Windows Support Lab

Malá cvičná firemní síť ve dvou virtuálních počítačích. Jeden je server, který spravuje uživatele a jejich práva, druhý je běžný pracovní počítač. Na labu se dají vyzkoušet situace, které řeší technická podpora každý den: uživatel se nepřihlásí, nedostane se ke sdílené složce nebo mu nefunguje nastavení od firmy.

## Co v labu je

| Počítač | Role | Systém |
|---|---|---|
| DC01 | Server: přihlašování uživatelů (Active Directory), překlad jmen v síti (DNS), sdílená složka | Windows Server 2025 |
| PC01 | Pracovní stanice běžného uživatele | Windows 11 Enterprise |

Oba běží ve VirtualBoxu na jednom fyzickém počítači a jsou propojené vlastní sítí oddělenou od domácí. V doméně jsou dva uživatelé: Anna, která má přístup ke sdílené složce, a Petr, který ho nemá. Uživatelům je centrálně zakázaný přístup do Ovládacích panelů, aby bylo na čem zkoušet firemní zásady.

Server i pracovní stanice jsou propojené doménou. Přihlášení, oprávnění ke složce, skupinová zásada i první DNS incident prošly kontrolou; výsledky a snímek jsou v [ověření funkčního základu](evidence/baseline.md).

## Jak se v repozitáři vyznat

1. [Instalace](docs/01-installation.md) – jak oba počítače vzniknou.
2. [Nastavení domény](docs/02-baseline.md) – uživatelé, skupiny, sdílená složka, zásady.
3. [Zapojení](docs/architecture.md) – adresy, skupiny a proč je to takhle.
4. [Ověřování](docs/verification.md) a [technické zdroje](docs/sources.md).

## Scénáře závad

Každý scénář popisuje, co hlásí uživatel, jak závadu v labu navodit, jak ji najít a jak ověřit, že je opravená.

| Scénář | Co hlásí uživatel |
|---|---|
| [Počítač nenajde doménu](incidents/INC-001-dns.md) | „Nejde mi přihlášení, píše to, že doména není dostupná.“ |
| [Odepřený přístup ke složce](incidents/INC-002-share.md) | „Včera jsem se do složky dostala, dnes mi to píše přístup odepřen.“ |
| [Zakázaný účet](incidents/INC-003-account.md) | „Nepustí mě to do počítače, heslo mám správně.“ |
| [Zásada se neprojevila](incidents/INC-004-gpo.md) | „Kolega má Ovládací panely zamčené a já ne.“ |
| [Zapomenuté heslo a zamčený účet](incidents/INC-005-password.md) | „Zapomněl jsem heslo a teď už mě to nepustí vůbec.“ |
| [Posunutý čas na počítači](incidents/INC-006-time.md) | „Od rána se nepřihlásím, včera to šlo.“ |

## Skripty

- `scripts/New-LabVMs.ps1` – vytvoří oba virtuální počítače se správnou sítí a disky.
- `scripts/Get-LabDiagnostics.ps1` – vypíše základní stav: síť, DNS, dostupnost serveru, členství v doméně.
