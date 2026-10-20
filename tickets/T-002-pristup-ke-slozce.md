# T-002 Uživatelka nemá přístup ke sdílené složce

| | |
|---|---|
| Uživatel | anna.lab, PC01 |
| Hlášení | „Nemůžu otevřít dokumenty na sdíleném disku, píše to přístup odepřen.“ |
| Priorita | střední, uživatelka může pracovat, ale ne se sdílenými soubory |
| Stav | vyřešeno 14. 10. 2026 |

## Diagnostika

Postup od sítě k oprávněním:

1. `Resolve-DnsName dc01.lab.example.test` vrací `10.10.10.10`, název serveru se překládá správně.
2. `Test-NetConnection DC01 -Port 445` – port pro sdílení souborů je dostupný. Server tedy běží a je vidět, nejde o síť.
3. Čtení `\\DC01\LabShare\welcome.txt` skončí `UnauthorizedAccessException`. Jde o odepřený přístup, ne o síťovou chybu.
4. Skupiny v Annině přihlášení (ukáže je `whoami /groups`): chybí `GG_LabStaff` a `DL_LabShare_Modify`.
5. Na DC01 `Get-SmbShareAccess LabShare` a `icacls C:\LabShare`: oprávnění složky se nezměnila.

## Příčina

Účet `anna.lab` byl odebraný ze skupiny `GG_LabStaff`, přes kterou má přístup ke složce. Účet i server přitom fungovaly. Závada byla v labu navozena záměrně.

## Řešení a ověření

Anna vrácena do `GG_LabStaff`. Po novém přihlášení soubor přečte, vytvoří i smaže vlastní testovací soubor. Petrovi zůstává přístup odepřený a oprávnění složky jsou stejná jako před závadou. Výsledky jsou v [evidence/INC-002-share.json](../evidence/INC-002-share.json).

Oprávnění se neopravovala přidáním `Everyone` s plným přístupem; to by problém skrylo a otevřelo složku všem.

## Odpověď uživateli

> Dobrý den, váš účet nebyl ve skupině, která má přístup ke sdíleným dokumentům. Přístup jsem obnovil. Odhlaste se prosím a znovu přihlaste, potom by mělo vše fungovat.

## Poznámka

Dostupný server neznamená povolený přístup. Změna skupiny se projeví až v novém přihlášení, protože Windows si skupiny načítá při přihlášení uživatele.
