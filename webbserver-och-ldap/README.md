# Konfiguration och härdning av en webbserver, och implementation av OpenLDAP och SSSD

Denna uppgift, som utfördes som en del av kursen **IT-säkerhet Unix, Linux och Mac**, bestod av två delar. 
Den första delen gick ut på att konfigurera en webbserver, som jag valde att göra med Apache, MariaDB och WordPress, att härda denna samt att skriva teknisk dokumentation. 
Den andra delen av uppgiften gick ut på att implementera LDAP på en separat server, demonstrera dess funktion i en video och skapa ett skript som förenklar någon del av denna implementation. 
Detta valde jag att utföra med hjälp av OpenLDAP samt att konfigurera SSSD och skapa ett skript som utför konfigurationen av SSSD i ett kommando.

---

## Innehåll

I denna mapp har jag lagt den tekniska dokumentationen för den första delen av uppgiften och bash-skriptet. 
Demonstrationen av OpenLDAP och SSSD kan ses här under.


### Se demonstrationen
[![Se videon på YouTube](https://img.youtube.com/vi/H2eNq4NP1y0/0.jpg)](https://www.youtube.com/watch?v=H2eNq4NP1y0)

### Teknisk stack

* **Webbserver:** Apache, MariaDB, WordPress
* **Härdning:** OpenSCAP, CIS Level 1 Workstation
* **LDAP:** OpenLDAP, SSSD
* **Scripting:** Bash
