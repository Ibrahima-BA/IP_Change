@echo off
echo Mise a jour de la configuration TCP/IP du PC en DHCP. Patientez...

SET NomConnexion=Ethernet
netsh interface IP set address "%NomConnexion%" dhcp


@echo Mise a jour de la configuration reussie !
pause

Ou 

 
@echo off 
echo Mise a jour de la configuration TCP/IP du PC. Patientez... 
 
SET NomConnexion=Ethernet 
SET IP=10.1.30.1 
SET Masque=255.0.0.0 
SET Passerelle=10.255.6.190 
 
netsh interface IP set address "%NomConnexion%" static %IP% %Masque% %Passerelle% 1 
 
SET DNS=10.255.6.189 
netsh interface IP set DNS "%NomConnexion%" static %DNS% primary 
 
echo Mise a jour de la configuration reussie !
