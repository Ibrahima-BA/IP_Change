@echo off
::===============================================================================
:: Script de Configuration IP Unifié
:: Version: 2.0
:: Description: Configuration réseau TCP/IP pour Windows avec interface interactive
:: Fonctionnalités: DHCP, IP fixe, IP personnalisée
:: Date: Octobre 2025
::===============================================================================

echo.
echo ========================================
echo   Configuration TCP/IP - Script Unifie
echo ========================================
echo.

::===============================================================================
:: CONFIGURATION PAR DEFAUT
::===============================================================================
SET NomConnexion=Ethernet
SET IP_FIXE=192.168.71.10
SET PASSERELLE=192.168.71.254
SET MASQUE=255.255.255.0
SET DNS_PRIMAIRE=10.10.131.1
SET DNS_SECONDAIRE=8.8.8.8

::===============================================================================
:: VERIFICATION DES PRIVILEGES ADMINISTRATEUR
::===============================================================================
net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo ERREUR: Ce script necessite des privileges administrateur.
    echo Veuillez faire un clic droit sur le fichier et choisir "Executer en tant qu'administrateur"
    echo.
    pause
    exit /b 1
)

::===============================================================================
:: AFFICHAGE DU MENU PRINCIPAL
::===============================================================================
:afficher_menu
cls
echo.
echo ========================================
echo   Configuration TCP/IP - Script Unifie
echo ========================================
echo.
echo Interface reseau configuree: %NomConnexion%
echo IP fixe predefinie: %IP_FIXE%
echo Passerelle: %PASSERELLE%
echo DNS: %DNS_PRIMAIRE%
echo.
echo ----------------------------------------
echo   MENU DE CONFIGURATION
echo ----------------------------------------
echo.
echo 1. Configuration DHCP (automatique)
echo 2. Configuration IP fixe (%IP_FIXE%)
echo 3. Configuration IP personnalisee
echo 4. Afficher la configuration actuelle
echo 5. Modifier les parametres par defaut
echo 6. Quitter
echo.

::===============================================================================
:: SAISIE DU CHOIX UTILISATEUR
::===============================================================================
:saisie_choix
set choix=
set /p choix=Choisissez une option (1-6): 

:: Validation de la saisie
if "%choix%"=="" (
    echo.
    echo ERREUR: Veuillez entrer un numero valide.
    echo.
    pause
    goto afficher_menu
)

:: Traitement du premier caractère uniquement
set choix=%choix:~0,1%

if "%choix%"=="1" goto config_dhcp
if "%choix%"=="2" goto config_ip_fixe
if "%choix%"=="3" goto config_ip_personnalisee
if "%choix%"=="4" goto afficher_config
if "%choix%"=="5" goto modifier_parametres
if "%choix%"=="6" goto quitter

echo.
echo ERREUR: Option '%choix%' non valide. Veuillez choisir entre 1 et 6.
echo.
pause
goto afficher_menu

::===============================================================================
:: CONFIGURATION DHCP
::===============================================================================
:config_dhcp
echo.
echo ----------------------------------------
echo   Configuration DHCP
echo ----------------------------------------
echo.
echo Application de la configuration DHCP sur l'interface: %NomConnexion%
echo Patientez...
echo.

netsh interface ip set address name="%NomConnexion%" source=dhcp
if %errorLevel% NEQ 0 (
    echo ERREUR: Impossible de configurer l'adresse IP en DHCP.
    echo Verifiez le nom de l'interface: %NomConnexion%
    goto fin_avec_erreur
)

netsh interface ip set dns name="%NomConnexion%" source=dhcp
if %errorLevel% NEQ 0 (
    echo ERREUR: Impossible de configurer le DNS en DHCP.
    goto fin_avec_erreur
)

echo ✓ Configuration DHCP appliquee avec succes !
goto fin_succès

::===============================================================================
:: CONFIGURATION IP FIXE PREDEFINIE
::===============================================================================
:config_ip_fixe
echo.
echo ----------------------------------------
echo   Configuration IP Fixe
echo ----------------------------------------
echo.
echo Application de la configuration IP fixe:
echo - Interface: %NomConnexion%
echo - IP: %IP_FIXE%
echo - Masque: %MASQUE%
echo - Passerelle: %PASSERELLE%
echo - DNS: %DNS_PRIMAIRE%
echo.
echo Patientez...
echo.

netsh interface ip set address name="%NomConnexion%" static %IP_FIXE% %MASQUE% %PASSERELLE% 1
if %errorLevel% NEQ 0 (
    echo ERREUR: Impossible de configurer l'adresse IP fixe.
    echo Verifiez les parametres et le nom de l'interface.
    goto fin_avec_erreur
)

netsh interface ip set dns name="%NomConnexion%" static %DNS_PRIMAIRE%
if %errorLevel% NEQ 0 (
    echo ERREUR: Impossible de configurer le DNS primaire.
    goto fin_avec_erreur
)

netsh interface ip add dns name="%NomConnexion%" %DNS_SECONDAIRE% index=2
echo ✓ Configuration IP fixe appliquee avec succes !
goto fin_succès

::===============================================================================
:: CONFIGURATION IP PERSONNALISEE
::===============================================================================
:config_ip_personnalisee
echo.
echo ----------------------------------------
echo   Configuration IP Personnalisee
echo ----------------------------------------
echo.

:saisie_ip_perso
set ip_personnalisee=
echo Entrez votre adresse IP au format XXX.XXX.XXX.XXX
set /p ip_personnalisee=Adresse IP: 

if "%ip_personnalisee%"=="" (
    echo ERREUR: Veuillez entrer une adresse IP valide.
    goto saisie_ip_perso
)

echo.
echo Configuration avec les parametres suivants:
echo - Interface: %NomConnexion%
echo - IP: %ip_personnalisee%
echo - Masque: %MASQUE%
echo - Passerelle: %PASSERELLE%
echo - DNS: %DNS_PRIMAIRE%
echo.

set /p confirmation=Confirmer la configuration ? (o/n): 
if /i not "%confirmation%"=="o" if /i not "%confirmation%"=="oui" (
    echo Configuration annulee.
    echo.
    pause
    goto afficher_menu
)

echo.
echo Application de la configuration personnalisee...
echo Patientez...
echo.

netsh interface ip set address name="%NomConnexion%" static %ip_personnalisee% %MASQUE% %PASSERELLE% 1
if %errorLevel% NEQ 0 (
    echo ERREUR: Impossible de configurer l'adresse IP personnalisee.
    echo Verifiez l'adresse IP saisie: %ip_personnalisee%
    goto fin_avec_erreur
)

netsh interface ip set dns name="%NomConnexion%" static %DNS_PRIMAIRE%
if %errorLevel% NEQ 0 (
    echo ERREUR: Impossible de configurer le DNS.
    goto fin_avec_erreur
)

netsh interface ip add dns name="%NomConnexion%" %DNS_SECONDAIRE% index=2
echo ✓ Configuration IP personnalisee appliquee avec succes !
goto fin_succès

::===============================================================================
:: AFFICHAGE DE LA CONFIGURATION ACTUELLE
::===============================================================================
:afficher_config
echo.
echo ----------------------------------------
echo   Configuration Reseau Actuelle
echo ----------------------------------------
echo.
echo Interfaces reseau disponibles:
netsh interface show interface
echo.
echo Configuration de l'interface %NomConnexion%:
netsh interface ip show config name="%NomConnexion%"
echo.
echo Configuration IP complete:
ipconfig /all | findstr /C:"Ethernet adapter" /C:"Carte Ethernet" /C:"IPv4" /C:"Masque" /C:"Passerelle" /C:"Serveurs DNS"
echo.
pause
goto afficher_menu

::===============================================================================
:: MODIFICATION DES PARAMETRES PAR DEFAUT
::===============================================================================
:modifier_parametres
echo.
echo ----------------------------------------
echo   Modification des Parametres
echo ----------------------------------------
echo.
echo Parametres actuels:
echo 1. Interface: %NomConnexion%
echo 2. IP fixe: %IP_FIXE%
echo 3. Passerelle: %PASSERELLE%
echo 4. DNS primaire: %DNS_PRIMAIRE%
echo 5. Retour au menu principal
echo.

set choix_param=
set /p choix_param=Quel parametre modifier (1-5) ? 

if "%choix_param%"=="1" (
    echo.
    echo Interfaces disponibles:
    netsh interface show interface
    echo.
    set /p NomConnexion=Nouveau nom d'interface: 
)
if "%choix_param%"=="2" (
    set /p IP_FIXE=Nouvelle adresse IP fixe: 
)
if "%choix_param%"=="3" (
    set /p PASSERELLE=Nouvelle adresse de passerelle: 
)
if "%choix_param%"=="4" (
    set /p DNS_PRIMAIRE=Nouvelle adresse DNS primaire: 
)
if "%choix_param%"=="5" goto afficher_menu

echo.
echo ✓ Parametre modifie avec succes !
echo.
pause
goto modifier_parametres

::===============================================================================
:: FIN AVEC SUCCES
::===============================================================================
:fin_succès
echo.
echo ========================================
echo   Configuration terminee avec succes !
echo ========================================
echo.
echo Nouvelle configuration reseau:
timeout /t 2 /nobreak >nul
ipconfig | findstr /C:"IPv4" /C:"Masque" /C:"Passerelle"
echo.
echo ✓ La configuration reseau a ete appliquee.
echo ✓ Vous pouvez fermer cette fenetre.
echo.
pause
exit /b 0

::===============================================================================
:: FIN AVEC ERREUR
::===============================================================================
:fin_avec_erreur
echo.
echo ========================================
echo   ERREUR DE CONFIGURATION
echo ========================================
echo.
echo ✗ La configuration n'a pas pu etre appliquee.
echo.
echo Solutions possibles:
echo - Verifier le nom de l'interface: %NomConnexion%
echo - Executer le script en tant qu'administrateur
echo - Utiliser la commande: netsh interface show interface
echo.
set /p retry=Voulez-vous retenter (o/n) ? 
if /i "%retry%"=="o" goto afficher_menu
if /i "%retry%"=="oui" goto afficher_menu
goto quitter

::===============================================================================
:: QUITTER LE PROGRAMME
::===============================================================================
:quitter
echo.
echo Fermeture du script de configuration IP.
echo Aucune modification n'a ete apportee.
echo.
pause
exit /b 0

::===============================================================================
:: FIN DU SCRIPT
::===============================================================================
