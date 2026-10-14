# Provozní kontrola labu

Účel: po startu, změně nebo návratu z odpovídajících snapshotů ověřit, že adresář, DNS a souborová služba stále fungují. Chybu neskrývat automatickou opravou.

1. Spustit DC01, počkat na služby a pak PC01. Otevřít konzole, aby bylo vidět, které prostředí se spravuje.
2. V každé VM v administrátorském PowerShellu spustit [Test-LabHealth.ps1](../scripts/Test-LabHealth.ps1). Skript je třeba nejprve předat do VM. Nepoužívá VirtualBox ani uložená hesla.

```powershell
# Uvnitř DC01 nebo PC01 ve složce s předaným skriptem:
.\Test-LabHealth.ps1
```

Výstup je JSON. `Checks` obsahuje název kontroly, `Passed`, `Observed` a případné `Error`. Neúspěšná kontrola vyžaduje vysvětlení. Skript nic neopravuje, neresetuje spojení ani nemění DNS. Administrátorský test neověřuje práva běžného uživatele.

3. Pod běžnou Annou ověřit čtení dokumentu. Při změně přístupu ověřit i zápis vlastního dočasného souboru a jeho smazání. Petrovi má být přístup odmítnutý. Netestovat běžná práva pouze jako Domain Admin.
4. Při změně GPO přečíst `gpresult /r /scope:user` a vyzkoušet skutečné chování. Samotné `gpupdate` není důkazem účinku.
5. Zapsat kontrolovaný stav, zjištění a další krok. Původní výpis nepublikovat automaticky.

`DNSHostA` ověřuje úplné jméno serveru, `DNSLdapSrv` nalezení LDAP služby. `SMBTcp445` je pouze dostupnost portu. `SecureChannel` na klientovi kontroluje vztah počítače s doménou, nikoli přístup Anny k souboru.

Při neúspěchu ověřit IP a DNS, úplné jméno a nalezení DC, dostupnost služby, pak identitu a práva. Ping je pomocná kontrola; jeho selhání samo o sobě neprokazuje nefunkční server.
