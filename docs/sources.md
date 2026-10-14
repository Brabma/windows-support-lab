# Technické zdroje

- [Windows Server 2025 Evaluation](https://www.microsoft.com/en-us/evalcenter/evaluate-windows-server-2025): instalační obraz a podmínky zkušební verze.
- [Windows 11 Enterprise Evaluation](https://www.microsoft.com/en-us/evalcenter/evaluate-windows-11-enterprise): instalační obraz a podmínky zkušební verze.
- [Windows Time service](https://learn.microsoft.com/en-us/windows-server/networking/windows-time-service/windows-time-service-tools-and-settings): synchronizace času a příkazy w32tm.
- [Událost 4740](https://learn.microsoft.com/en-us/windows/security/threat-protection/auditing/event-4740): audit zamčení účtu a pole Caller Computer Name.
- [Pravidla zamykání účtů](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/security-policy-settings/account-lockout-policy): práh a časová okna zamčení.
- [Jemně odstupňované politiky hesel](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/adac/fine-grained-password-policies): politika pro konkrétní uživatele nebo skupiny.
- [VirtualBox 7.2](https://docs.oracle.com/en/virtualization/virtualbox/7.2/user/): virtuální síť, snapshoty, Guest Additions a správa VM.

Inspirace rozsahem scénářů: [Help-Desk-Homelab](https://github.com/RyanRFrechette/Help-Desk-Homelab) a [active-directory-lab](https://github.com/DemRamenNoodles/active-directory-lab).
## Zdroje pro rozšíření projektu, ověřené 14. 10. 2026

- [AD DS overview](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview): úloha adresáře a doménového řadiče.
- [DNS overview](https://learn.microsoft.com/en-us/windows-server/networking/dns/dns-overview): překlad jmen a nalezení řadiče.
- [AD security groups](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/understand-security-groups): skupiny, rozsahy a přístupová oprávnění.
- [Group Policy overview](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/group-policy/group-policy-overview): zásady a jejich aplikování.
- [DHCP overview](https://learn.microsoft.com/en-us/windows-server/networking/technologies/dhcp/dhcp-top): automatická konfigurace a lease v plánované etapě.

Pro strukturu propojující infrastrukturu a servisní úkoly byl znovu přečten [RyanRFrechette/Help-Desk-Homelab](https://github.com/RyanRFrechette/Help-Desk-Homelab). [john-boehler/active-directory-homelab](https://github.com/john-boehler/active-directory-homelab) sloužil jako příklad rozsahu AD, GPO a přístupů. Cizí snímky, kód ani výsledky nepřebíráme. Texty a nový skript vznikly pro tento lab. Dosavadní praktické kontroly provedl Codex; samostatné opakování autorem čeká.
