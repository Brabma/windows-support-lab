# Účty, skupiny a přístup k souborům

Postup pro vyzkoušení životního cyklu doménového účtu. Anna a Petr už mají ověřená rozdílná oprávnění; následující celý postup s novým účtem ještě provedený není.

## Vytvoření účtu

V Active Directory Users and Computers otevřít OU Users a vytvořit nový běžný testovací účet. Prohlédnout přihlašovací jméno, UPN a stav Enabled. Heslo se do dokumentace nezapisuje.

Pak účet přidat do GG_LabStaff. Skupina je vnořená do DL_LabShare_Modify, které patří oprávnění ke sdílení. Díky tomu se při přidávání uživatele nemění ACL složky.

## Ověření přístupu

Přihlásit nový účet na PC01 a pomocí whoami zkontrolovat identitu. Otevřít LabShare, přečíst welcome.txt a vytvořit vlastní testovací soubor. Po ověření jej smazat. Pod stejným účtem zkontrolovat také gpresult a chování Ovládacích panelů.

## Odebrání skupiny

Odebrat přístupovou skupinu, ukončit relaci a znovu se přihlásit. Přihlášení do domény má dál fungovat, ale přístup ke složce už má být odmítnutý. Tento rozdíl už zachycuje [INC-002](../incidents/INC-002-share.md) na účtu Anny.

## Zakázání účtu

Na DC01 zakázat nový testovací účet a při dostupném řadiči zkusit nové přihlášení. Porovnat výsledek s pouhým odebráním skupiny. Již otevřená relace a uložené přihlášení jsou odlišné situace.

Na závěr vrátit původní nastavení a zapsat výsledky jednotlivých kroků. U každého bude důležité vysvětlit, zda se měnila identita, možnost přihlášení, nebo přístup k souborům.
