# Skalbar & Säker Webbplattform i Virtualiserad Miljö

Detta projekt genomfördes som en del av kursen **IT-infrastruktur**. Syftet var att bygga en robust, skalbar och säker plattform från grunden med hjälp av virtualisering. 

---

## Viktigt: Läsordning
För att få bäst förståelse för projektets omfattning och genomförande, vänligen titta på filerna i denna mapp i följande ordning:

1.  **[Projektbeskrivning.pdf](./Projektbeskrivning.pdf)** – Ger en snabb överblick av projektet, mina bridrag och tillhörande bilder.
2.  **[RapportKeepersOfLogs.pdf](./RapportKeepersOfLogs.pdf)** – Innehåller den djupgående teoretiska analysen, tekniska specifikationer och reflektioner kring verktygen.

---

## Projektet i korthet
I detta projekt designade och implementerade vi en webbserver (Apache/PHP) med tillhörande databas och diverse tillhörande funktioner för att optimera säkerhet och skalbarhet.

### Roll & Ansvar
Som **gruppledare** ansvarade jag för projektledning, dagliga check-ins och koordinering av teamets sex medlemmar. Utöver ledarskapet implementerade jag följande kritiska funktioner:

* **Monitoreringsstack:** Centraliserad övervakning med **Zabbix** (hårdvarustatus) och **Uptime Kuma** (tillgänglighet).
* **Datavisualisering:** Skapade dashboards i **Grafana** för realtidsöverblick.
* **Incident Response:** Automatiserade larm via webhooks till Discord vid driftstörningar.
* **Lösenordshantering:** Dedikerad server med **VaultWarden** för säker, self-hosted hantering av projektets inloggningsuppgifter.

## Teknisk Stack
* **Virtualisering:** Proxmox VE
* **Nätverk & Säkerhet:** Twingate (ZTNA), OPNSense
* **Monitorering:** Zabbix, Uptime Kuma, Prometheus, Grafana
* **Loggning:** Graylog
* **Backup:** Proxmox Backup Server (PBS)
* **Server:** Debian/Ubuntu, Apache, MariaDB, VaultWarden

---
*Detta projekt påvisar förmågan att både leda ett tekniskt team och implementera komplexa säkerhets- och monitoreringslösningar i en modern IT-miljö.*
