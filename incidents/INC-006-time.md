# Posunutý čas na počítači

**Požadavek:** „Od rána se nedostanu ke sdílené složce, včera to šlo.“

## Výchozí stav

PC01 přebírá čas z `dc01.lab.example.test`. Měření 14. října ukázalo rozdíl přibližně 0,25 sekundy. Závada se navozuje na klientovi; čas hostitele a DC01 se nemění. Před začátkem zaznamenat stav obou VM a připravit společné snapshoty.

## Jak závadu navodit

1. Při vypnutém PC01 na fyzickém hostiteli vypnout přebírání času přes VirtualBox. Zaznamenat původní hodnotu:

   ```powershell
   # Cesta podle instalace; výchozí je C:\Program Files\Oracle\VirtualBox\VBoxManage.exe.
   $vbox = 'D:\Program Files\Oracle\VBoxManage.exe'
   & $vbox getextradata PC01 'VBoxInternal/Devices/VMMDev/0/Config/GetHostTimeDisabled'
   & $vbox setextradata PC01 'VBoxInternal/Devices/VMMDev/0/Config/GetHostTimeDisabled' 1
   ```

2. Spustit PC01. Uvnitř klienta v PowerShellu správce:

   ```powershell
   Stop-Service w32time
   Set-Date -Date (Get-Date).AddHours(1)
   w32tm /stripchart /computer:DC01 /samples:3 /dataonly
   ```

3. V Annině relaci vymazat existující Kerberos lístky a vyžádat nový:

   ```powershell
   klist purge
   klist get cifs/DC01.lab.example.test
   ```

Kerberos při výchozí politice připouští rozdíl pěti minut. Po hodinovém posunu scénář očekává chybu při získání nového lístku; skutečný výsledek zatím není změřený. Pokud klient lístek získá, zaznamená se i tento výsledek spolu s odchylkou času a událostmi Kerberos, nikoli předpokládané selhání. Samotné odhlášení nestačí jako spolehlivý test: zapamatované přihlášení nebo již otevřené spojení ke složce může stále fungovat.

## Diagnostika

```powershell
w32tm /stripchart /computer:DC01 /samples:3 /dataonly
Get-Service w32time
```

Stripchart změří rozdíl vůči DC01 i při zastavené místní službě. `w32tm /query /status` při zastavené službě hlásí chybu; po jejím spuštění ukáže zdroj a poslední synchronizaci.

## Oprava a ověření

Na PC01 jako správce obnovit službu a doménový zdroj:

```powershell
Start-Service w32time
w32tm /config /syncfromflags:domhier /update
w32tm /resync /rediscover
w32tm /query /source
w32tm /query /status
w32tm /stripchart /computer:DC01 /samples:3 /dataonly
```

Velký jednorázový posun může služba nejprve posoudit jako časový výkyv. Pokud se hodiny ihned nesrovnají, nastavit na PC01 přibližný aktuální čas podle DC01 pomocí `Set-Date -Date '<aktuální datum a čas z DC01>'` a synchronizaci zopakovat. Cílem je rozdíl pod několik sekund a zdroj DC01.

V Annině relaci znovu získat lístek pomocí `klist get cifs/DC01.lab.example.test` a otevřít `\\DC01.lab.example.test\LabShare\welcome.txt`. Ve správcovském PowerShellu má `Test-ComputerSecureChannel` vrátit `True`; kontrolu doplňuje úspěšné získání lístku a čtení souboru.

## Návrat nastavení VirtualBoxu

PC01 vypnout. Při kontrole 14. října nebyla původní extradata hodnota nastavená; obnoví ji odstranění klíče (příkaz bez poslední hodnoty):

```powershell
& $vbox setextradata PC01 'VBoxInternal/Devices/VMMDev/0/Config/GetHostTimeDisabled'
& $vbox getextradata PC01 'VBoxInternal/Devices/VMMDev/0/Config/GetHostTimeDisabled'
```

Pokud před cvičením existovala konkrétní hodnota, vrátit ji. Po startu znovu ověřit čas a doménu. Úplný návrat používá odpovídající snapshoty obou vypnutých VM.

Přepínače a způsob opravy popisuje [dokumentace Windows Time service](https://learn.microsoft.com/en-us/windows-server/networking/windows-time-service/windows-time-service-tools-and-settings).
