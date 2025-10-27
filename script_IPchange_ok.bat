 @echo off

SET NomConnexion=Ethernet

SET IP=192.168.71.10

SET Passerelle=192.168.71.254



set choix=

echo 1: dhcp

echo 2: fixe %IP%

echo 3: autre IP

echo 4: quitter



:debut

set /p choix=Quelle configuration souhaitez-vous appliquer?:

(

if not %choix%=='' set choix=%choix:~0,1%

if %choix%==1 goto dhcp

if %choix%==2 goto fixed

if %choix%==3 goto custom

if %choix%==4 goto end

)

echo %choix% n'est pas bon !

goto début



:dhcp

echo Mise a jour de la configuration TCP/IP du PC en DHCP.

netsh interface IP set address "%NomConnexion%" dhcp

netsh interface IP set dns "%NomConnexion%" dhcp

goto fin



:fixed



echo Mise a jour de la configuration TCP/IP du PC vers l'adresse %IP%

REM le NomConexion doit être trouvé avec la commande : netsh interface show interface

SET Masque=255.255.255.0



netsh interface IP set address "%NomConnexion%" static %IP% %Masque% %Passerelle% 1



SET DNS=10.10.131.1

netsh interface IP set dns "%NomConnexion%" static %DNS%

goto fin



:custom

set adresse=

set /p adresse=Entrez votre adresse IP au formatr XX.XX.XX.XX :

echo Mise a jour de la configuration TCP/IP du PC vers l'adresse %adresse%

SET Masque=255.255.255.0



netsh interface IP set address "%NomConnexion%" static %adresse% %Masque% %Passerelle% 1



SET DNS=10.10.131.1

netsh interface IP set dns "%NomConnexion%" static %DNS%

goto fin



:fin

sleep 3

ipconfig

pause



