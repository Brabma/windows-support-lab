# 1. Instalace

## Server DC01

1. Z [Microsoft Evaluation Center](https://www.microsoft.com/en-us/evalcenter/evaluate-windows-server-2025) stáhnout instalační obraz Windows Server 2025 (x64, anglicky). Zkušební verze běží 180 dní.
2. Zapsat si kontrolní součet staženého souboru: `Get-FileHash -Algorithm SHA256 <soubor>`.
3. Ve VirtualBoxu připojit obraz k DC01 (Settings → Storage → optická mechanika) a spustit instalaci. Zvolit **Standard Evaluation (Desktop Experience)**, tedy verzi s grafickým rozhraním.
4. Instalovat na nový virtuální disk 64 GB. Heslo účtu Administrator použít jen pro lab.
5. Kvůli aktivaci a aktualizacím dočasně přepnout síťovou kartu na NAT (viz [zapojení](architecture.md)). Aktivaci je potřeba provést do 10 dnů; stav ukáže `slmgr /dlv`.
6. Počítač vypnout, kartu vrátit do vnitřní sítě, nastavit jméno DC01 a adresu podle tabulky. Pokračovat [nastavením domény](02-baseline.md).

## Pracovní stanice PC01

7. Stáhnout [Windows 11 Enterprise Evaluation](https://www.microsoft.com/en-us/evalcenter/evaluate-windows-11-enterprise) (x64, 90 dní). Edice Home se nehodí, neumí se připojit do domény.
8. Virtuální počítač má EFI, Secure Boot a virtuální čip TPM 2.0, které Windows 11 vyžaduje, 2 procesory a 4 GB paměti.
9. Připojit obraz a nainstalovat. Při instalaci spustit jen PC01.
10. Aktivaci a aktualizace dokončit přes dočasný NAT ještě před připojením do domény. Potom vypnout, vrátit vnitřní síť a nastavit jméno PC01, adresu 10.10.10.20/24, DNS 10.10.10.10, bez brány.

## Nároky na hostitelský počítač

| | Procesory | Paměť | Disk |
|---|---|---|---|
| DC01 | 2 | 2–4 GB | 64 GB, roste postupně |
| PC01 | 2 | 4 GB | 80 GB, roste postupně |

Na oba počítače, instalační obrazy a snapshoty je dobré mít aspoň 160 GB volného místa.

## Otázka na zopakování

Co dělá fyzický počítač, co virtuální, a proč DNS na PC01 ukazuje na DC01?
