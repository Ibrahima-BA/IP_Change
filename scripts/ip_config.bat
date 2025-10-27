@echo off
::===============================================================================
:: Script de Configuration IP avec Logging et Interface Colorée
:: Version: 3.1.0
:: Description: Configuration réseau TCP/IP pour Windows avec interface interactive
:: Fonctionnalités: DHCP, IP fixe, IP personnalisée, logging, couleurs, mode verbose
:: Date: Octobre 2025
:: Auteur: IP_Change Project
::===============================================================================

setlocal EnableDelayedExpansion

::===============================================================================
:: CONFIGURATION DES COULEURS (Windows 10+)
::===============================================================================
:: Couleurs disponibles (combinaison fond + texte)
:: 0=Noir, 1=Bleu, 2=Vert, 3=Cyan, 4=Rouge, 5=Magenta, 6=Jaune, 7=Blanc
:: 8=Gris, 9=Bleu clair, A=Vert clair, B=Cyan clair, C=Rouge clair, D=Magenta clair, E=Jaune clair, F=Blanc brillant

SET COLOR_HEADER=0E
SET COLOR_SUCCESS=0A
SET COLOR_ERROR=0C
SET COLOR_WARNING=0E
SET COLOR_INFO=0B
SET COLOR_MENU=07
SET COLOR_INPUT=0F

::===============================================================================
:: CONFIGURATION PAR DEFAUT
::===============================================================================
SET NomConnexion=Ethernet
SET IP_FIXE=192.168.71.10
SET PASSERELLE=192.168.71.254
SET MASQUE=255.255.255.0
SET DNS_PRIMAIRE=10.10.131.1
SET DNS_SECONDAIRE=8.8.8.8
SET VERSION=3.1.0
SET VERBOSE_MODE=false
SET LOG_ENABLED=true

::===============================================================================
:: CONFIGURATION DES LOGS
::===============================================================================
SET LOG_DIR=%~dp0..\logs
SET LOG_FILE=%LOG_DIR%\ip_config_%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%%time:~6,2%.log
SET HISTORY_FILE=%LOG_DIR%\ip_config_history.log

:: Créer le dossier logs s'il n'existe pas
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%"

::===============================================================================
:: FONCTIONS DE LOGGING ET COULEURS
::===============================================================================

:log_write
:: Fonction pour écrire dans le log
:: Usage: call :log_write "niveau" "message"
set log_level=%~1
set log_message=%~2
set log_timestamp=%date% %time:~0,8%
if "%LOG_ENABLED%"=="true" (
    echo [%log_timestamp%] [%log_level%] %log_message% >> "%LOG_FILE%"
    echo [%log_timestamp%] [%log_level%] %log_message% >> "%HISTORY_FILE%"
)
goto :eof

:print_colored
:: Fonction pour afficher du texte coloré
:: Usage: call :print_colored "couleur" "message"
set color_code=%~1
set message=%~2
color %color_code%
echo %message%
color %COLOR_MENU%
goto :eof

:print_verbose
:: Fonction pour affichage verbose
:: Usage: call :print_verbose "message"
if "%VERBOSE_MODE%"=="true" (
    call :print_colored "%COLOR_INFO%" "[VERBOSE] %~1"
    call :log_write "VERBOSE" "%~1"
)
goto :eof

::===============================================================================
:: VERIFICATION DES PRIVILEGES ADMINISTRATEUR
::===============================================================================
call :log_write "INFO" "Démarrage du script IP Configuration v%VERSION%"
call :print_verbose "Vérification des privilèges administrateur..."

net session >nul 2>&1
if %errorLevel% NEQ 0 (
    call :print_colored "%COLOR_ERROR%" "ERREUR: Ce script nécessite des privilèges administrateur."
    call :print_colored "%COLOR_WARNING%" "Veuillez faire un clic droit sur le fichier et choisir 'Exécuter en tant qu'administrateur'"
    call :log_write "ERROR" "Script lancé sans privilèges administrateur"
    echo.
    pause
    exit /b 1
)

call :log_write "INFO" "Privilèges administrateur confirmés"
call :print_verbose "Privilèges administrateur OK"

::===============================================================================
:: AFFICHAGE DU MENU PRINCIPAL
::===============================================================================
:afficher_menu
cls
call :print_colored "%COLOR_HEADER%" "========================================================"
call :print_colored "%COLOR_HEADER%" "  Configuration TCP/IP v%VERSION% - Interface Avancée"
call :print_colored "%COLOR_HEADER%" "========================================================"
echo.

call :print_colored "%COLOR_INFO%" "Interface réseau configurée: %NomConnexion%"
call :print_colored "%COLOR_INFO%" "IP fixe prédéfinie: %IP_FIXE%"
call :print_colored "%COLOR_INFO%" "Passerelle: %PASSERELLE%"
call :print_colored "%COLOR_INFO%" "DNS: %DNS_PRIMAIRE%"
echo.

call :print_colored "%COLOR_MENU%" "Mode Verbose: %VERBOSE_MODE% | Logging: %LOG_ENABLED%"
call :print_colored "%COLOR_MENU%" "Fichier log: %LOG_FILE%"
echo.

call :print_colored "%COLOR_HEADER%" "--------------------------------------------------------"
call :print_colored "%COLOR_HEADER%" "   MENU DE CONFIGURATION"
call :print_colored "%COLOR_HEADER%" "--------------------------------------------------------" 
echo.

call :print_colored "%COLOR_MENU%" "1. Configuration DHCP (automatique)"
call :print_colored "%COLOR_MENU%" "2. Configuration IP fixe (%IP_FIXE%)"
call :print_colored "%COLOR_MENU%" "3. Configuration IP personnalisée"
call :print_colored "%COLOR_MENU%" "4. Afficher la configuration actuelle"
call :print_colored "%COLOR_MENU%" "5. Modifier les paramètres par défaut"
call :print_colored "%COLOR_MENU%" "6. Basculer mode verbose (%VERBOSE_MODE%)"
call :print_colored "%COLOR_MENU%" "7. Afficher l'historique des logs"
call :print_colored "%COLOR_MENU%" "8. Test de connectivité réseau"
call :print_colored "%COLOR_MENU%" "9. Quitter"
echo.

::===============================================================================
:: SAISIE DU CHOIX UTILISATEUR
::===============================================================================
:saisie_choix
set choix=
call :print_colored "%COLOR_INPUT%" "Choisissez une option (1-9): "
set /p choix=

call :log_write "INFO" "Utilisateur a choisi l'option: %choix%"

:: Validation de la saisie
if "%choix%"=="" (
    call :print_colored "%COLOR_ERROR%" "ERREUR: Veuillez entrer un numéro valide."
    call :log_write "WARNING" "Saisie vide de l'utilisateur"
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
if "%choix%"=="6" goto toggle_verbose
if "%choix%"=="7" goto afficher_historique
if "%choix%"=="8" goto test_connectivite
if "%choix%"=="9" goto quitter

call :print_colored "%COLOR_ERROR%" "ERREUR: Option '%choix%' non valide. Veuillez choisir entre 1 et 9."
call :log_write "WARNING" "Option invalide sélectionnée: %choix%"
echo.
pause
goto afficher_menu

::===============================================================================
:: BASCULER MODE VERBOSE
::===============================================================================
:toggle_verbose
if "%VERBOSE_MODE%"=="true" (
    SET VERBOSE_MODE=false
    call :print_colored "%COLOR_WARNING%" "Mode verbose DÉSACTIVÉ"
) else (
    SET VERBOSE_MODE=true
    call :print_colored "%COLOR_SUCCESS%" "Mode verbose ACTIVÉ"
)
call :log_write "INFO" "Mode verbose basculé vers: %VERBOSE_MODE%"
timeout /t 2 /nobreak >nul
goto afficher_menu

::===============================================================================
:: AFFICHAGE DE L'HISTORIQUE DES LOGS
::===============================================================================
:afficher_historique
cls
call :print_colored "%COLOR_HEADER%" "=========================================="
call :print_colored "%COLOR_HEADER%" "   HISTORIQUE DES OPERATIONS"
call :print_colored "%COLOR_HEADER%" "=========================================="
echo.

if exist "%HISTORY_FILE%" (
    call :print_colored "%COLOR_INFO%" "Dernières opérations (20 dernières lignes):"
    echo.
    call :print_colored "%COLOR_MENU%" "----------------------------------------"
    type "%HISTORY_FILE%" | more +0
    call :print_colored "%COLOR_MENU%" "----------------------------------------"
) else (
    call :print_colored "%COLOR_WARNING%" "Aucun historique disponible."
)

echo.
call :print_colored "%COLOR_INFO%" "Fichier log actuel: %LOG_FILE%"
call :print_colored "%COLOR_INFO%" "Historique complet: %HISTORY_FILE%"
echo.
pause
goto afficher_menu

::===============================================================================
:: TEST DE CONNECTIVITE RESEAU
::===============================================================================
:test_connectivite
cls
call :print_colored "%COLOR_HEADER%" "=========================================="
call :print_colored "%COLOR_HEADER%" "   TEST DE CONNECTIVITE RESEAU"
call :print_colored "%COLOR_HEADER%" "=========================================="
echo.

call :log_write "INFO" "Début du test de connectivité réseau"
call :print_verbose "Test de connectivité en cours..."

call :print_colored "%COLOR_INFO%" "Test 1: Ping de la passerelle..."
ping -n 2 %PASSERELLE% >nul 2>&1
if %errorLevel% EQU 0 (
    call :print_colored "%COLOR_SUCCESS%" "✓ Passerelle %PASSERELLE% accessible"
    call :log_write "INFO" "Ping passerelle réussi: %PASSERELLE%"
) else (
    call :print_colored "%COLOR_ERROR%" "✗ Passerelle %PASSERELLE% non accessible"
    call :log_write "ERROR" "Ping passerelle échoué: %PASSERELLE%"
)

call :print_colored "%COLOR_INFO%" "Test 2: Ping DNS primaire..."
ping -n 2 %DNS_PRIMAIRE% >nul 2>&1
if %errorLevel% EQU 0 (
    call :print_colored "%COLOR_SUCCESS%" "✓ DNS primaire %DNS_PRIMAIRE% accessible"
    call :log_write "INFO" "Ping DNS primaire réussi: %DNS_PRIMAIRE%"
) else (
    call :print_colored "%COLOR_ERROR%" "✗ DNS primaire %DNS_PRIMAIRE% non accessible"
    call :log_write "ERROR" "Ping DNS primaire échoué: %DNS_PRIMAIRE%"
)

call :print_colored "%COLOR_INFO%" "Test 3: Ping Internet (Google DNS)..."
ping -n 2 8.8.8.8 >nul 2>&1
if %errorLevel% EQU 0 (
    call :print_colored "%COLOR_SUCCESS%" "✓ Internet accessible (8.8.8.8)"
    call :log_write "INFO" "Ping Internet réussi: 8.8.8.8"
) else (
    call :print_colored "%COLOR_ERROR%" "✗ Internet non accessible (8.8.8.8)"
    call :log_write "ERROR" "Ping Internet échoué: 8.8.8.8"
)

call :print_colored "%COLOR_INFO%" "Test 4: Résolution DNS..."
nslookup google.com >nul 2>&1
if %errorLevel% EQU 0 (
    call :print_colored "%COLOR_SUCCESS%" "✓ Résolution DNS fonctionnelle"
    call :log_write "INFO" "Test DNS réussi: google.com"
) else (
    call :print_colored "%COLOR_ERROR%" "✗ Résolution DNS défaillante"
    call :log_write "ERROR" "Test DNS échoué: google.com"
)

call :log_write "INFO" "Fin du test de connectivité réseau"
echo.
pause
goto afficher_menu

::===============================================================================
:: CONFIGURATION DHCP
::===============================================================================
:config_dhcp
cls
call :print_colored "%COLOR_HEADER%" "----------------------------------------"
call :print_colored "%COLOR_HEADER%" "   Configuration DHCP"
call :print_colored "%COLOR_HEADER%" "----------------------------------------"
echo.

call :log_write "INFO" "Début configuration DHCP sur interface: %NomConnexion%"
call :print_verbose "Application de la configuration DHCP..."

call :print_colored "%COLOR_INFO%" "Application de la configuration DHCP sur l'interface: %NomConnexion%"
call :print_colored "%COLOR_INFO%" "Patientez..."
echo.

call :print_verbose "Commande: netsh interface ip set address name=%NomConnexion% source=dhcp"
netsh interface ip set address name="%NomConnexion%" source=dhcp
if %errorLevel% NEQ 0 (
    call :print_colored "%COLOR_ERROR%" "ERREUR: Impossible de configurer l'adresse IP en DHCP."
    call :print_colored "%COLOR_WARNING%" "Vérifiez le nom de l'interface: %NomConnexion%"
    call :log_write "ERROR" "Échec configuration IP DHCP sur %NomConnexion%"
    goto fin_avec_erreur
)

call :print_verbose "Commande: netsh interface ip set dns name=%NomConnexion% source=dhcp"
netsh interface ip set dns name="%NomConnexion%" source=dhcp
if %errorLevel% NEQ 0 (
    call :print_colored "%COLOR_ERROR%" "ERREUR: Impossible de configurer le DNS en DHCP."
    call :log_write "ERROR" "Échec configuration DNS DHCP sur %NomConnexion%"
    goto fin_avec_erreur
)

call :print_colored "%COLOR_SUCCESS%" "✓ Configuration DHCP appliquée avec succès !"
call :log_write "SUCCESS" "Configuration DHCP appliquée avec succès sur %NomConnexion%"
goto fin_succès

::===============================================================================
:: CONFIGURATION IP FIXE PREDEFINIE
::===============================================================================
:config_ip_fixe
cls
call :print_colored "%COLOR_HEADER%" "----------------------------------------"
call :print_colored "%COLOR_HEADER%" "   Configuration IP Fixe"
call :print_colored "%COLOR_HEADER%" "----------------------------------------"
echo.

call :log_write "INFO" "Début configuration IP fixe: %IP_FIXE%"
call :print_verbose "Configuration IP fixe en cours..."

call :print_colored "%COLOR_INFO%" "Application de la configuration IP fixe:"
call :print_colored "%COLOR_MENU%" "- Interface: %NomConnexion%"
call :print_colored "%COLOR_MENU%" "- IP: %IP_FIXE%"
call :print_colored "%COLOR_MENU%" "- Masque: %MASQUE%"
call :print_colored "%COLOR_MENU%" "- Passerelle: %PASSERELLE%"
call :print_colored "%COLOR_MENU%" "- DNS: %DNS_PRIMAIRE%"
echo.
call :print_colored "%COLOR_INFO%" "Patientez..."
echo.

call :print_verbose "Commande: netsh interface ip set address name=%NomConnexion% static %IP_FIXE% %MASQUE% %PASSERELLE% 1"
netsh interface ip set address name="%NomConnexion%" static %IP_FIXE% %MASQUE% %PASSERELLE% 1
if %errorLevel% NEQ 0 (
    call :print_colored "%COLOR_ERROR%" "ERREUR: Impossible de configurer l'adresse IP fixe."
    call :print_colored "%COLOR_WARNING%" "Vérifiez les paramètres et le nom de l'interface."
    call :log_write "ERROR" "Échec configuration IP fixe: %IP_FIXE% sur %NomConnexion%"
    goto fin_avec_erreur
)

call :print_verbose "Commande: netsh interface ip set dns name=%NomConnexion% static %DNS_PRIMAIRE%"
netsh interface ip set dns name="%NomConnexion%" static %DNS_PRIMAIRE%
if %errorLevel% NEQ 0 (
    call :print_colored "%COLOR_ERROR%" "ERREUR: Impossible de configurer le DNS primaire."
    call :log_write "ERROR" "Échec configuration DNS primaire: %DNS_PRIMAIRE%"
    goto fin_avec_erreur
)

call :print_verbose "Commande: netsh interface ip add dns name=%NomConnexion% %DNS_SECONDAIRE% index=2"
netsh interface ip add dns name="%NomConnexion%" %DNS_SECONDAIRE% index=2

call :print_colored "%COLOR_SUCCESS%" "✓ Configuration IP fixe appliquée avec succès !"
call :log_write "SUCCESS" "Configuration IP fixe appliquée: %IP_FIXE% sur %NomConnexion%"
goto fin_succès

::===============================================================================
:: CONFIGURATION IP PERSONNALISEE
::===============================================================================
:config_ip_personnalisee
cls
call :print_colored "%COLOR_HEADER%" "----------------------------------------"
call :print_colored "%COLOR_HEADER%" "   Configuration IP Personnalisée"
call :print_colored "%COLOR_HEADER%" "----------------------------------------"
echo.

:saisie_ip_perso
set ip_personnalisee=
call :print_colored "%COLOR_INFO%" "Entrez votre adresse IP au format XXX.XXX.XXX.XXX"
call :print_colored "%COLOR_INPUT%" "Adresse IP: "
set /p ip_personnalisee=

call :log_write "INFO" "Utilisateur a saisi IP personnalisée: %ip_personnalisee%"

if "%ip_personnalisee%"=="" (
    call :print_colored "%COLOR_ERROR%" "ERREUR: Veuillez entrer une adresse IP valide."
    call :log_write "WARNING" "IP personnalisée vide"
    goto saisie_ip_perso
)

echo.
call :print_colored "%COLOR_INFO%" "Configuration avec les paramètres suivants:"
call :print_colored "%COLOR_MENU%" "- Interface: %NomConnexion%"
call :print_colored "%COLOR_MENU%" "- IP: %ip_personnalisee%"
call :print_colored "%COLOR_MENU%" "- Masque: %MASQUE%"
call :print_colored "%COLOR_MENU%" "- Passerelle: %PASSERELLE%"
call :print_colored "%COLOR_MENU%" "- DNS: %DNS_PRIMAIRE%"
echo.

call :print_colored "%COLOR_INPUT%" "Confirmer la configuration ? (o/n): "
set /p confirmation=
if /i not "%confirmation%"=="o" if /i not "%confirmation%"=="oui" (
    call :print_colored "%COLOR_WARNING%" "Configuration annulée."
    call :log_write "INFO" "Configuration IP personnalisée annulée par l'utilisateur"
    echo.
    pause
    goto afficher_menu
)

echo.
call :print_colored "%COLOR_INFO%" "Application de la configuration personnalisée..."
call :print_verbose "Configuration IP personnalisée: %ip_personnalisee%"
call :print_colored "%COLOR_INFO%" "Patientez..."
echo.

call :print_verbose "Commande: netsh interface ip set address name=%NomConnexion% static %ip_personnalisee% %MASQUE% %PASSERELLE% 1"
netsh interface ip set address name="%NomConnexion%" static %ip_personnalisee% %MASQUE% %PASSERELLE% 1
if %errorLevel% NEQ 0 (
    call :print_colored "%COLOR_ERROR%" "ERREUR: Impossible de configurer l'adresse IP personnalisée."
    call :print_colored "%COLOR_WARNING%" "Vérifiez l'adresse IP saisie: %ip_personnalisee%"
    call :log_write "ERROR" "Échec configuration IP personnalisée: %ip_personnalisee%"
    goto fin_avec_erreur
)

call :print_verbose "Configuration DNS..."
netsh interface ip set dns name="%NomConnexion%" static %DNS_PRIMAIRE%
if %errorLevel% NEQ 0 (
    call :print_colored "%COLOR_ERROR%" "ERREUR: Impossible de configurer le DNS."
    call :log_write "ERROR" "Échec configuration DNS pour IP personnalisée"
    goto fin_avec_erreur
)

netsh interface ip add dns name="%NomConnexion%" %DNS_SECONDAIRE% index=2
call :print_colored "%COLOR_SUCCESS%" "✓ Configuration IP personnalisée appliquée avec succès !"
call :log_write "SUCCESS" "Configuration IP personnalisée appliquée: %ip_personnalisee%"
goto fin_succès

::===============================================================================
:: AFFICHAGE DE LA CONFIGURATION ACTUELLE
::===============================================================================
:afficher_config
cls
call :print_colored "%COLOR_HEADER%" "=================================================="
call :print_colored "%COLOR_HEADER%" "   CONFIGURATION RESEAU ACTUELLE"
call :print_colored "%COLOR_HEADER%" "=================================================="
echo.

call :log_write "INFO" "Affichage de la configuration réseau actuelle"
call :print_verbose "Récupération des informations réseau..."

call :print_colored "%COLOR_INFO%" "Interface configurée: %NomConnexion%"
echo.

call :print_colored "%COLOR_MENU%" "Interfaces réseau disponibles:"
call :print_colored "%COLOR_MENU%" "----------------------------------------"
netsh interface show interface
echo.

call :print_colored "%COLOR_MENU%" "Configuration de l'interface %NomConnexion%:"
call :print_colored "%COLOR_MENU%" "----------------------------------------"
netsh interface ip show config name="%NomConnexion%"
echo.

call :print_colored "%COLOR_MENU%" "Configuration IP complète:"
call :print_colored "%COLOR_MENU%" "----------------------------------------"
ipconfig /all | findstr /C:"Ethernet adapter" /C:"Carte Ethernet" /C:"IPv4" /C:"Masque" /C:"Passerelle" /C:"Serveurs DNS"
echo.

call :print_colored "%COLOR_INFO%" "Appuyez sur une touche pour continuer..."
pause >nul
goto afficher_menu

::===============================================================================
:: MODIFICATION DES PARAMETRES PAR DEFAUT
::===============================================================================
:modifier_parametres
cls
call :print_colored "%COLOR_HEADER%" "----------------------------------------"
call :print_colored "%COLOR_HEADER%" "   Modification des Paramètres"
call :print_colored "%COLOR_HEADER%" "----------------------------------------"
echo.

call :log_write "INFO" "Accès au menu de modification des paramètres"

call :print_colored "%COLOR_INFO%" "Paramètres actuels:"
call :print_colored "%COLOR_MENU%" "1. Interface: %NomConnexion%"
call :print_colored "%COLOR_MENU%" "2. IP fixe: %IP_FIXE%"
call :print_colored "%COLOR_MENU%" "3. Passerelle: %PASSERELLE%"
call :print_colored "%COLOR_MENU%" "4. DNS primaire: %DNS_PRIMAIRE%"
call :print_colored "%COLOR_MENU%" "5. Retour au menu principal"
echo.

set choix_param=
call :print_colored "%COLOR_INPUT%" "Quel paramètre modifier (1-5) ? "
set /p choix_param=

call :log_write "INFO" "Modification paramètre choisi: %choix_param%"

if "%choix_param%"=="1" (
    echo.
    call :print_colored "%COLOR_INFO%" "Interfaces disponibles:"
    netsh interface show interface
    echo.
    call :print_colored "%COLOR_INPUT%" "Nouveau nom d'interface: "
    set /p NomConnexion=
    call :log_write "INFO" "Interface modifiée vers: %NomConnexion%"
)
if "%choix_param%"=="2" (
    call :print_colored "%COLOR_INPUT%" "Nouvelle adresse IP fixe: "
    set /p IP_FIXE=
    call :log_write "INFO" "IP fixe modifiée vers: %IP_FIXE%"
)
if "%choix_param%"=="3" (
    call :print_colored "%COLOR_INPUT%" "Nouvelle adresse de passerelle: "
    set /p PASSERELLE=
    call :log_write "INFO" "Passerelle modifiée vers: %PASSERELLE%"
)
if "%choix_param%"=="4" (
    call :print_colored "%COLOR_INPUT%" "Nouvelle adresse DNS primaire: "
    set /p DNS_PRIMAIRE=
    call :log_write "INFO" "DNS primaire modifié vers: %DNS_PRIMAIRE%"
)
if "%choix_param%"=="5" goto afficher_menu

echo.
call :print_colored "%COLOR_SUCCESS%" "✓ Paramètre modifié avec succès !"
echo.
timeout /t 2 /nobreak >nul
goto modifier_parametres

::===============================================================================
:: FIN AVEC SUCCES
::===============================================================================
:fin_succès
echo.
call :print_colored "%COLOR_HEADER%" "=================================================="
call :print_colored "%COLOR_HEADER%" "   CONFIGURATION TERMINEE AVEC SUCCES !"
call :print_colored "%COLOR_HEADER%" "=================================================="
echo.

call :print_colored "%COLOR_INFO%" "Nouvelle configuration réseau:"
call :print_verbose "Récupération de la nouvelle configuration..."
timeout /t 2 /nobreak >nul
ipconfig | findstr /C:"IPv4" /C:"Masque" /C:"Passerelle"
echo.

call :print_colored "%COLOR_SUCCESS%" "✓ La configuration réseau a été appliquée."
call :print_colored "%COLOR_SUCCESS%" "✓ Les logs ont été sauvegardés dans: %LOG_FILE%"
call :print_colored "%COLOR_INFO%" "✓ Vous pouvez fermer cette fenêtre."
echo.

call :log_write "INFO" "Configuration terminée avec succès"
pause
exit /b 0

::===============================================================================
:: FIN AVEC ERREUR
::===============================================================================
:fin_avec_erreur
echo.
call :print_colored "%COLOR_HEADER%" "=================================================="
call :print_colored "%COLOR_ERROR%" "   ERREUR DE CONFIGURATION"
call :print_colored "%COLOR_HEADER%" "=================================================="
echo.

call :print_colored "%COLOR_ERROR%" "✗ La configuration n'a pas pu être appliquée."
echo.

call :print_colored "%COLOR_WARNING%" "Solutions possibles:"
call :print_colored "%COLOR_MENU%" "- Vérifier le nom de l'interface: %NomConnexion%"
call :print_colored "%COLOR_MENU%" "- Exécuter le script en tant qu'administrateur"
call :print_colored "%COLOR_MENU%" "- Utiliser la commande: netsh interface show interface"
call :print_colored "%COLOR_MENU%" "- Consulter les logs: %LOG_FILE%"
echo.

call :print_colored "%COLOR_INPUT%" "Voulez-vous retenter (o/n) ? "
set /p retry=
if /i "%retry%"=="o" goto afficher_menu
if /i "%retry%"=="oui" goto afficher_menu

call :log_write "ERROR" "Fin du script avec erreur - utilisateur a choisi de ne pas retenter"
goto quitter

::===============================================================================
:: QUITTER LE PROGRAMME
::===============================================================================
:quitter
echo.
call :print_colored "%COLOR_WARNING%" "Fermeture du script de configuration IP."
call :print_colored "%COLOR_INFO%" "Aucune modification n'a été apportée."
call :print_colored "%COLOR_MENU%" "Logs sauvegardés dans: %LOG_FILE%"
echo.

call :log_write "INFO" "Fermeture normale du script par l'utilisateur"
pause
exit /b 0

::===============================================================================
:: FIN DU SCRIPT
::===============================================================================