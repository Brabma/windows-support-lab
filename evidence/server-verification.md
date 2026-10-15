# Stav serveru

Výsledky kontrol na DC01 z 13. října 2026.

| Kontrola | Výsledek |
|---|---|
| Operační systém | Windows Server 2025 Standard Evaluation, build 26100 |
| Aktivace | úspěšná, zkušební doba 180 dní |
| Doména | `lab.example.test` (krátce LAB), server domény DC01 |
| Síť | 10.10.10.10/24, DNS 10.10.10.10 (výpis z 13. 10.; 14. 10. už server používal 127.0.0.1, viz [provozní kontrola](health-checks.md)), vnitřní síť labu |
| Služby | ADWS, DFSR, DNS, Netlogon a NTDS běží |
| Záznam pro hledání serveru | `_ldap._tcp.dc._msdcs.lab.example.test` vrací `dc01.lab.example.test`, port 389 |
| Diagnostika `dcdiag` | Connectivity, Advertising, SysVolCheck, NetLogons a Services prošly |

## Uživatelé a oprávnění

- Účty `anna.lab` a `petr.lab` jsou aktivní.
- Anna je ve skupině `GG_LabStaff`, ta je vložená do `DL_LabShare_Modify`.
- Sdílení `LabShare`: skupina `DL_LabShare_Modify` má Change, správci Full. Na disku má stejná skupina Modify.

## Zásada

`LAB-User-ControlPanel` je připojená k OU `Lab/Users` a nastavuje `HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoControlPanel=1`.

## Poznámky z instalace

- Instalace rolí trvala déle, než čekal instalační nástroj, a doběhla sama s výsledkem Success.
- První restart po vytvoření domény bylo potřeba vynutit z VirtualBoxu; další vypnutí už proběhla běžně.
- Před připojením pracovní stanice je uložený snapshot `server-ready-before-client`.

Připojení PC01, přístup ke složce a zásada z pohledu uživatele jsou doložené v [ověření funkčního základu](baseline.md).
