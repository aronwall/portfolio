# Installation av Apache, Wordpress och MariaDB, och grundläggande härdning av Ubuntu 24.04 LTS

Väl konfigurerade och säkra webbservrar är en hörnsten i modern infrastruktur. Att kunna installera, göra grundläggande konfiguration av och härda en webbserver är något som alla IT-tekniker, säkerhetstekniker och systemadministratörer bör vara bekväma med. I denna artikel kommer jag gå igenom hur detta kan göras på Ubuntu 24.04 med Apache, Wordpress och MariaDB som alla är populära alternativ för detta syfte, samt visa hur man kan härda ett system med OpenSCAP.

## 1. Installera och testa verktyg

**Vi börjar med att säkerställa att vi har de senaste versionerna av alla paket installerade**
*sudo apt update && sudo apt upgrade -y*

**Vi öppnar vår brandvägg för http, lägger till en “default deny all incoming”-regel och ser till att den är aktiv**
*sudo ufw allow http*
*sudo ufw default deny incoming*
*sudo ufw enable*

**Vi installerar Apache och curl som vi kommer att använda framöver och testar att apache funkar som den ska genom att hämta default-sidan**
*sudo apt install apache2 curl -y*
*curl <span>http</span>://localhost*

Om en lång html-sida med text returneras vet vi att Apache är igång och fungerar

**Vi installerar MariaDB, skapar en databas för wordpress, en användare wpuser med ett lösenord och kör sedan FLUSH PRIVILEGES för att läsa in användarkonton igen**
*sudo apt install mariadb-server -y*
*sudo mariadb -u root*
*CREATE DATABASE wordpress;*
*GRANT ALL PRIVILEGES ON wordpress.\* TO wpuser@localhost IDENTIFIED BY 'MittLösen123';* 
(Välj självklart ett unikt och säkert eget lösenord, eller använd en lösenordsgenerator såsom pwgen)
*FLUSH PRIVILEGES;*
*EXIT;*
<img width="888" height="417" alt="MariaDB" src="https://github.com/user-attachments/assets/0dbcf386-34c8-4f06-94c2-3f9cf9c0dc5d" />

**Vi hämtar den senaste versionen av Wordpress, som kommer hamna i mappen vi just nu befinner oss i**
*curl -sO https://wordpress.org/latest.tar.gz*

**Wordpress använder sig av språket php, som vi därför också behöver hämta moduler för, kolla versionen, verifiera att det är aktiverat med kommandot a2enmod och sedan starta om Apache**
*sudo apt install php libapache2-mod-php php-mysql php-common php-xmlrpc php-json php-opcache php-gd -y*
*php -version*
*sudo a2enmod php8.3*
*sudo systemctl restart apache2*
<img width="783" height="242" alt="php" src="https://github.com/user-attachments/assets/0870aa3d-c14e-4cba-bec9-3ce9766acb64" />

**Vi testar att php fungerar med Apache genom att skapa en php-fil som vi testar att öppna i vår webbläsare**
*sudo nano /var/www/html/info.php*
I filen skriver vi:
*<?php*
*phpinfo();*
Spara och stäng nano, öppna en webbläsare och skriv in “http://localhost/info.php” i adressfältet. En sida med info om php bör öppnas.

**Det är dags att installera Wordpress och vi börjar med att ta bort testfilerna, för att sedan köra installationen, förflytta oss till nya mappen “wordpress” och kopiera sample-config-filen till en ny fil**
*sudo rm /var/www/html/**
*tar zxf latest.tar.gz*
*cd wordpress*
*cp wp-config-sample.php wp-config.php*

**Vi öppnar den nyskapade konfig-filen i nano och ändrar värdena “DB_NAME”, “DB_USER” och “DB_PASSWORD” till det vi valde i MariaDB tidigare, sparar och stänger nano igen.**
<img width="886" height="242" alt="WP-config" src="https://github.com/user-attachments/assets/2f1d9e50-de8c-4f45-b208-4a3ce58af1a6" />

**Vi flyttar filerna i mappen “wordpress” till /var/www/html, hoppar över till den mappen och ändrar ägaren och gruppen av filerna till www-data, som är den användare som Apache körs som**
*sudo mv \* /var/www/html*
*cd /var/www/html*
*sudo chown -R www-data:www-data*

**Vi döper om index.html så att man direkt hamnar på wordpress default-sida istället för apaches default-sida**
*sudo mv index.html index.old*

Vi har nu en fungerande webbserver och kan gå igenom konfigurationen av Wordpress på <span>http</span>://localhost/wp-admin!

## 2. Installera och kör OpenSCAP

**Vi börjar med att installera OpenSCAP och tillhörande konfig-filer**
*sudo apt install libopenscap25 openscap-scanner ssg-base ssg-debderived*

**Vi förflyttar oss till vår hemkatalog, hämtar säkerhetsguiden för OpenSCAP med wget och packar upp den**
*cd ~*
*wget <span>https</span>://github.com/ComplianceAsCode/content/releases/download/v0.1.76/scap-security-guide-0.1.76.zip*
*unzip scap-security-guide-0.1.76.zip*

**Vi kör OpenSCAP och låter den generera en rapport i XML-format och en rapport i html-format att ha som utgångspunkt. OpenSCAP körs med en compliance-standard och mot en specifik version av ett operativsystem, och berättar sedan helt enkelt vilka delar av standarden ens system är compliant mot standarden och vad som inte är det. Jag har i den här guiden valt att köra mot cis_level1_workstation, en grundläggande säkerhetsstandard för workstations.**
*sudo oscap xccdf eval --profile cis_level1_workstation --results cis-results1.xml --report cis-report1.html /home/\*dittanvändarnamn\*/scap-security-guide-0.1.76/ssg-ubuntu2404-ds.xml*

HTML-rapporten som genererades kan sedan öppnas i en webbläsare. För ett helt compliant system behöver man gå igenom hela rapporten och se till att allt uppfylls. Jag kommer att välja ett par punkter som exempel för att härda. En fördel med OpenSCAP är att det ger oss exakta kommandon för att åtgärda problem.

**Åtgärda ägarskap och permissions för känsliga filer**
*sudo chgrp shadow /etc/gshadow-*
*sudo chmod 0640 /etc/gshadow-*
*sudo chmod 0640 /etc/shadow-*
*sudo chmod 0640 /etc/gshadow*
*sudo chmod 0640 /etc/shadow*
<img width="693" height="95" alt="filrättigheter" src="https://github.com/user-attachments/assets/fc09a0a1-5ebe-4d93-bbde-292df0d193ea" />

**Inaktivera tjänsten Apport, som kan förhindra annan härdning**
*sudo systemctl mask --now apport.service*

**Ta bort paket för det osäkra protokollet FTP**
*sudo apt-get remove ftp*

**Sätt en umask, som sätter default-permissions när en fil skapas, vilket förhindrar för höga rättigheter på filer**
*sudo nano /etc/bash.bashrc*
Lägg till en rad längst ner med texten “umask 027”
*sudo nano /etc/login.defs*
Ändra värdet efter “UMASK” till 027
*sudo nano /etc/profile*
Lägg till en rad längst ner med text “umask 027”

Vi har nu provat på att installera Apache, Wordpress och MariaDB, satt upp en fungerande webbserver och provat på att härda systemet där servern hostas med OpenSCAP. Detta skulle kunna ses som utgångspunkten för att kunna hosta en egen webbplats på ett mycket säkert system, eller kan bara vara ett värdefullt projekt att ha provat på för att lära sig systemadministration och härdning.

Aron Wallroth, student inom IT-säkerhet, Mars 2026
