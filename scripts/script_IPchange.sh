#!/bin/bash

# Script de configuration réseau avancé pour macOS/Linux avec Logging et Couleurs
# Version: 3.1.0
# Nécessite les privilèges sudo
# Fonctionnalités: DHCP, IP fixe, IP personnalisée, logging, couleurs, mode verbose

# ===============================================================================
# CONFIGURATION DES COULEURS
# ===============================================================================

# Couleurs ANSI
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BRIGHT_RED='\033[1;31m'
BRIGHT_GREEN='\033[1;32m'
BRIGHT_YELLOW='\033[1;33m'
BRIGHT_BLUE='\033[1;34m'
BRIGHT_CYAN='\033[1;36m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m' # No Color

# ===============================================================================
# CONFIGURATION PAR DÉFAUT
# ===============================================================================

NomConnexion="Wi-Fi"  # ou "Ethernet", "AX88179A" pour adaptateur USB
IP="192.168.71.10"
Passerelle="192.168.71.254"
Masque="255.255.255.0"
DNS="10.10.131.1"
DNS_SECONDAIRE="8.8.8.8"
VERSION="3.1.0"
VERBOSE_MODE=false
LOG_ENABLED=true

# Détecter l'OS
OS_TYPE=$(uname)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="$SCRIPT_DIR/../logs"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOG_FILE="$LOG_DIR/ip_config_shell_${TIMESTAMP}.log"
HISTORY_FILE="$LOG_DIR/ip_config_history.log"

# ===============================================================================
# FONCTIONS DE LOGGING ET COULEURS
# ===============================================================================

# Créer le dossier logs s'il n'existe pas
mkdir -p "$LOG_DIR"

# Fonction de logging
log_write() {
    local level="$1"
    local message="$2"
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    
    if [ "$LOG_ENABLED" = true ]; then
        echo "[$timestamp] [$level] $message" >> "$LOG_FILE"
        echo "[$timestamp] [$level] $message" >> "$HISTORY_FILE"
    fi
}

# Fonction pour afficher du texte coloré
print_colored() {
    local color="$1"
    local message="$2"
    echo -e "${color}${message}${NC}"
}

# Fonction pour affichage verbose
print_verbose() {
    if [ "$VERBOSE_MODE" = true ]; then
        print_colored "$DIM" "[VERBOSE] $1"
        log_write "VERBOSE" "$1"
    fi
}

# Fonctions d'affichage spécialisées
print_header() {
    local title="$1"
    local line=$(printf '=%.0s' $(seq 1 ${#title}))
    print_colored "$BRIGHT_YELLOW$BOLD" "$line"
    print_colored "$BRIGHT_YELLOW$BOLD" "$title"
    print_colored "$BRIGHT_YELLOW$BOLD" "$line"
}

print_success() {
    print_colored "$BRIGHT_GREEN$BOLD" "✓ $1"
    log_write "SUCCESS" "$1"
}

print_error() {
    print_colored "$BRIGHT_RED$BOLD" "✗ $1"
    log_write "ERROR" "$1"
}

print_warning() {
    print_colored "$BRIGHT_YELLOW" "⚠ $1"
    log_write "WARNING" "$1"
}

print_info() {
    print_colored "$BRIGHT_BLUE" "ℹ $1"
    log_write "INFO" "$1"
}

# ===============================================================================
# FONCTIONS UTILITAIRES
# ===============================================================================

# Vérifier les privilèges root
check_root() {
    print_verbose "Vérification des privilèges root..."
    if [ "$EUID" -ne 0 ]; then
        print_error "Ce script nécessite les privilèges root"
        print_warning "Relancez avec: sudo $0"
        log_write "ERROR" "Script lancé sans privilèges root"
        exit 1
    fi
    log_write "INFO" "Privilèges root confirmés"
    print_verbose "Privilèges root OK"
}

# Valider une adresse IP
validate_ip() {
    local ip="$1"
    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        IFS='.' read -ra ADDR <<< "$ip"
        for i in "${ADDR[@]}"; do
            if [[ $i -gt 255 ]]; then
                return 1
            fi
        done
        return 0
    else
        return 1
    fi
}

# Exécuter une commande avec logging
run_command() {
    local cmd="$1"
    local description="$2"
    
    if [ -n "$description" ]; then
        print_verbose "$description"
    fi
    
    print_verbose "Commande: $cmd"
    log_write "INFO" "Exécution commande: $cmd"
    
    if eval "$cmd" 2>&1 | tee -a "$LOG_FILE"; then
        log_write "INFO" "Commande réussie: $cmd"
        return 0
    else
        log_write "ERROR" "Commande échouée: $cmd"
        return 1
    fi
}

# ===============================================================================
# FONCTIONS RÉSEAU
# ===============================================================================

# Afficher les interfaces disponibles
afficher_interfaces() {
    print_header "INTERFACES RÉSEAU DISPONIBLES"
    echo ""
    
    print_info "Recherche des interfaces réseau..."
    print_verbose "Détection des interfaces réseau disponibles"
    
    if [ "$OS_TYPE" = "Darwin" ]; then
        # macOS
        print_colored "$CYAN" "Interfaces réseau (networksetup):"
        networksetup -listallnetworkservices | grep -v "An asterisk" | while read -r interface; do
            print_colored "$WHITE" "  - $interface"
        done
        echo ""
        
        print_colored "$CYAN" "État des interfaces (ifconfig):"
        ifconfig | grep "^[a-z]" | awk '{print $1}' | sed 's/://' | while read -r interface; do
            status=$(ifconfig "$interface" | grep "status:" | awk '{print $2}')
            if [ -n "$status" ]; then
                if [ "$status" = "active" ]; then
                    print_colored "$GREEN" "  ✓ $interface (actif)"
                else
                    print_colored "$YELLOW" "  - $interface ($status)"
                fi
            else
                print_colored "$WHITE" "  - $interface"
            fi
        done
    else
        # Linux
        print_colored "$CYAN" "Interfaces réseau (ip link):"
        ip link show | grep "^[0-9]" | awk '{print $2}' | sed 's/://' | while read -r interface; do
            state=$(ip link show "$interface" | grep "state" | awk '{print $9}')
            if [ "$state" = "UP" ]; then
                print_colored "$GREEN" "  ✓ $interface (UP)"
            else
                print_colored "$YELLOW" "  - $interface ($state)"
            fi
        done
    fi
    echo ""
}

# Test de connectivité
test_connectivite() {
    print_header "TEST DE CONNECTIVITÉ RÉSEAU"
    echo ""
    
    log_write "INFO" "Début du test de connectivité réseau"
    
    local tests=("$Passerelle:Passerelle" "$DNS:DNS primaire" "8.8.8.8:Internet (Google DNS)" "1.1.1.1:Internet (Cloudflare DNS)")
    local success_count=0
    
    for test in "${tests[@]}"; do
        local ip="${test%%:*}"
        local name="${test##*:}"
        
        print_info "Test $name ($ip)..."
        
        if ping -c 2 -W 3 "$ip" >/dev/null 2>&1; then
            print_success "$name accessible"
            ((success_count++))
        else
            print_error "$name non accessible"
        fi
    done
    
    # Test DNS
    print_info "Test résolution DNS..."
    if nslookup google.com >/dev/null 2>&1; then
        print_success "Résolution DNS fonctionnelle"
        ((success_count++))
    else
        print_error "Résolution DNS défaillante"
    fi
    
    echo ""
    if [ $success_count -ge 3 ]; then
        print_success "Tests réussis: $success_count/5 - Connectivité OK"
    else
        print_warning "Tests réussis: $success_count/5 - Problèmes détectés"
    fi
    
    log_write "INFO" "Test de connectivité terminé: $success_count/5 réussis"
}

# Configuration DHCP
configurer_dhcp() {
    print_header "CONFIGURATION DHCP"
    echo ""
    
    log_write "INFO" "Début configuration DHCP sur interface: $NomConnexion"
    print_verbose "Application de la configuration DHCP..."
    
    print_info "Configuration DHCP sur l'interface: $NomConnexion"
    print_info "Patientez..."
    echo ""
    
    if [ "$OS_TYPE" = "Darwin" ]; then
        # macOS
        print_verbose "Commande: networksetup -setdhcp \"$NomConnexion\""
        if run_command "networksetup -setdhcp \"$NomConnexion\"" "Configuration DHCP macOS"; then
            print_success "Configuration DHCP appliquée avec succès !"
            log_write "SUCCESS" "Configuration DHCP appliquée avec succès sur $NomConnexion"
            return 0
        else
            print_error "Échec de la configuration DHCP"
            log_write "ERROR" "Échec configuration DHCP sur $NomConnexion"
            return 1
        fi
    else
        # Linux
        print_verbose "Libération IP actuelle..."
        run_command "dhclient -r $NomConnexion" "Libération IP actuelle"
        sleep 2
        
        print_verbose "Demande nouvelle IP DHCP..."
        if run_command "dhclient $NomConnexion" "Demande nouvelle IP DHCP"; then
            print_success "Configuration DHCP appliquée avec succès !"
            log_write "SUCCESS" "Configuration DHCP appliquée avec succès sur $NomConnexion"
            return 0
        else
            print_error "Échec de la configuration DHCP"
            log_write "ERROR" "Échec configuration DHCP sur $NomConnexion"
            return 1
        fi
    fi
}

# Configuration IP fixe
configurer_ip_fixe() {
    local ip_address="$1"
    
    print_header "CONFIGURATION IP STATIQUE"
    echo ""
    
    log_write "INFO" "Début configuration IP fixe: $ip_address"
    print_verbose "Configuration IP fixe en cours..."
    
    if ! validate_ip "$ip_address"; then
        print_error "Adresse IP invalide: $ip_address"
        return 1
    fi
    
    print_info "Configuration IP fixe:"
    print_colored "$CYAN" "  - Interface: $NomConnexion"
    print_colored "$CYAN" "  - IP: $ip_address"
    print_colored "$CYAN" "  - Masque: $Masque"
    print_colored "$CYAN" "  - Passerelle: $Passerelle"
    print_colored "$CYAN" "  - DNS: $DNS"
    echo ""
    print_info "Patientez..."
    echo ""
    
    if [ "$OS_TYPE" = "Darwin" ]; then
        # macOS
        print_verbose "Commande: networksetup -setmanual \"$NomConnexion\" $ip_address $Masque $Passerelle"
        if run_command "networksetup -setmanual \"$NomConnexion\" $ip_address $Masque $Passerelle" "Configuration IP statique macOS"; then
            # Configuration DNS
            print_verbose "Configuration DNS..."
            if run_command "networksetup -setdnsservers \"$NomConnexion\" $DNS $DNS_SECONDAIRE" "Configuration DNS macOS"; then
                print_success "Configuration IP fixe appliquée avec succès !"
                log_write "SUCCESS" "Configuration IP fixe appliquée: $ip_address sur $NomConnexion"
                return 0
            fi
        fi
        
        print_error "Échec de la configuration IP fixe"
        log_write "ERROR" "Échec configuration IP fixe: $ip_address sur $NomConnexion"
        return 1
        
    else
        # Linux
        print_verbose "Suppression IP actuelle..."
        run_command "ip addr flush dev $NomConnexion" "Suppression IP actuelle"
        
        # Calcul du CIDR
        local cidr
        case "$Masque" in
            "255.255.255.0") cidr="24" ;;
            "255.255.0.0") cidr="16" ;;
            "255.0.0.0") cidr="8" ;;
            "255.255.255.128") cidr="25" ;;
            "255.255.255.192") cidr="26" ;;
            "255.255.255.224") cidr="27" ;;
            "255.255.255.240") cidr="28" ;;
            "255.255.255.248") cidr="29" ;;
            "255.255.255.252") cidr="30" ;;
            *) cidr="24" ;;
        esac
        
        print_verbose "Configuration nouvelle IP: $ip_address/$cidr"
        if run_command "ip addr add $ip_address/$cidr dev $NomConnexion" "Configuration nouvelle IP"; then
            # Activer l'interface
            run_command "ip link set $NomConnexion up" "Activation interface"
            
            # Configurer la passerelle
            run_command "ip route add default via $Passerelle" "Configuration passerelle"
            
            # Configuration DNS (systemd-resolved ou fichier resolv.conf)
            if command -v systemd-resolve >/dev/null 2>&1; then
                run_command "systemd-resolve --interface=$NomConnexion --set-dns=$DNS --set-dns=$DNS_SECONDAIRE" "Configuration DNS systemd"
            else
                echo "nameserver $DNS" > /etc/resolv.conf
                echo "nameserver $DNS_SECONDAIRE" >> /etc/resolv.conf
                print_verbose "DNS configuré dans /etc/resolv.conf"
            fi
            
            print_success "Configuration IP fixe appliquée avec succès !"
            log_write "SUCCESS" "Configuration IP fixe appliquée: $ip_address sur $NomConnexion"
            return 0
        fi
        
        print_error "Échec de la configuration IP fixe"
        log_write "ERROR" "Échec configuration IP fixe: $ip_address sur $NomConnexion"
        return 1
    fi
}

# Afficher la configuration actuelle
afficher_config() {
    print_header "CONFIGURATION RÉSEAU ACTUELLE"
    echo ""
    
    log_write "INFO" "Affichage de la configuration réseau actuelle"
    print_verbose "Récupération des informations réseau..."
    
    print_info "Interface configurée: $NomConnexion"
    echo ""
    
    if [ "$OS_TYPE" = "Darwin" ]; then
        # macOS
        print_colored "$CYAN" "Configuration de l'interface (networksetup):"
        print_colored "$WHITE" "----------------------------------------"
        networksetup -getinfo "$NomConnexion"
        echo ""
        
        print_colored "$CYAN" "Détails réseau (ifconfig):"
        print_colored "$WHITE" "----------------------------------------"
        ifconfig | grep -A 5 "inet " | head -20
        
    else
        # Linux
        print_colored "$CYAN" "Configuration réseau (ip addr):"
        print_colored "$WHITE" "----------------------------------------"
        ip addr show
        echo ""
        
        print_colored "$CYAN" "Table de routage:"
        print_colored "$WHITE" "----------------------------------------"
        ip route show
    fi
    
    echo ""
}

# Afficher l'historique des logs
afficher_historique() {
    print_header "HISTORIQUE DES OPÉRATIONS"
    echo ""
    
    if [ -f "$HISTORY_FILE" ]; then
        print_info "Dernières opérations (50 dernières lignes):"
        echo ""
        print_colored "$WHITE" "----------------------------------------"
        
        # Afficher avec couleurs selon le niveau
        tail -50 "$HISTORY_FILE" | while IFS= read -r line; do
            if [[ $line == *"[ERROR]"* ]]; then
                print_colored "$RED" "$line"
            elif [[ $line == *"[SUCCESS]"* ]]; then
                print_colored "$GREEN" "$line"
            elif [[ $line == *"[WARNING]"* ]]; then
                print_colored "$YELLOW" "$line"
            else
                echo "$line"
            fi
        done
        
        print_colored "$WHITE" "----------------------------------------"
    else
        print_warning "Aucun historique disponible"
    fi
    
    echo ""
    print_info "Fichier log actuel: $LOG_FILE"
    print_info "Historique complet: $HISTORY_FILE"
}

# Modifier les paramètres
modifier_parametres() {
    while true; do
        clear
        print_header "MODIFICATION DES PARAMÈTRES"
        echo ""
        
        print_info "Paramètres actuels:"
        print_colored "$CYAN" "1. Interface: $NomConnexion"
        print_colored "$CYAN" "2. IP fixe: $IP"
        print_colored "$CYAN" "3. Passerelle: $Passerelle"
        print_colored "$CYAN" "4. Masque réseau: $Masque"
        print_colored "$CYAN" "5. DNS primaire: $DNS"
        print_colored "$CYAN" "6. DNS secondaire: $DNS_SECONDAIRE"
        print_colored "$CYAN" "7. Retour au menu principal"
        echo ""
        
        read -p "$(echo -e "${BRIGHT_WHITE}Quel paramètre modifier (1-7) ? ${NC}")" choix_param
        
        case $choix_param in
            1)
                echo ""
                afficher_interfaces
                read -p "$(echo -e "${BRIGHT_WHITE}Nouvelle interface: ${NC}")" nouvelle_interface
                if [ -n "$nouvelle_interface" ]; then
                    NomConnexion="$nouvelle_interface"
                    print_success "Interface modifiée"
                    log_write "INFO" "Interface modifiée vers: $nouvelle_interface"
                fi
                ;;
            2)
                read -p "$(echo -e "${BRIGHT_WHITE}Nouvelle IP fixe: ${NC}")" nouvelle_ip
                if validate_ip "$nouvelle_ip"; then
                    IP="$nouvelle_ip"
                    print_success "IP fixe modifiée"
                    log_write "INFO" "IP fixe modifiée vers: $nouvelle_ip"
                else
                    print_error "IP invalide"
                fi
                ;;
            3)
                read -p "$(echo -e "${BRIGHT_WHITE}Nouvelle passerelle: ${NC}")" nouvelle_passerelle
                if validate_ip "$nouvelle_passerelle"; then
                    Passerelle="$nouvelle_passerelle"
                    print_success "Passerelle modifiée"
                    log_write "INFO" "Passerelle modifiée vers: $nouvelle_passerelle"
                else
                    print_error "Passerelle invalide"
                fi
                ;;
            4)
                read -p "$(echo -e "${BRIGHT_WHITE}Nouveau masque réseau: ${NC}")" nouveau_masque
                if validate_ip "$nouveau_masque"; then
                    Masque="$nouveau_masque"
                    print_success "Masque réseau modifié"
                    log_write "INFO" "Masque réseau modifié vers: $nouveau_masque"
                else
                    print_error "Masque réseau invalide"
                fi
                ;;
            5)
                read -p "$(echo -e "${BRIGHT_WHITE}Nouveau DNS primaire: ${NC}")" nouveau_dns
                if validate_ip "$nouveau_dns"; then
                    DNS="$nouveau_dns"
                    print_success "DNS primaire modifié"
                    log_write "INFO" "DNS primaire modifié vers: $nouveau_dns"
                else
                    print_error "DNS invalide"
                fi
                ;;
            6)
                read -p "$(echo -e "${BRIGHT_WHITE}Nouveau DNS secondaire: ${NC}")" nouveau_dns_sec
                if validate_ip "$nouveau_dns_sec"; then
                    DNS_SECONDAIRE="$nouveau_dns_sec"
                    print_success "DNS secondaire modifié"
                    log_write "INFO" "DNS secondaire modifié vers: $nouveau_dns_sec"
                else
                    print_error "DNS invalide"
                fi
                ;;
            7)
                break
                ;;
            *)
                print_error "Option non valide"
                ;;
        esac
        
        if [ "$choix_param" != "7" ]; then
            sleep 2
        fi
    done
}

# ===============================================================================
# MENU PRINCIPAL
# ===============================================================================

afficher_menu() {
    while true; do
        clear
        
        print_header "CONFIGURATION TCP/IP v$VERSION - Interface Shell Avancée"
        echo ""
        
        print_info "Système: $OS_TYPE"
        print_info "Interface: $NomConnexion"
        print_info "IP prédéfinie: $IP"
        print_info "Passerelle: $Passerelle"
        print_info "DNS: $DNS"
        echo ""
        
        local verbose_status
        if [ "$VERBOSE_MODE" = true ]; then
            verbose_status="ACTIVÉ"
        else
            verbose_status="DÉSACTIVÉ"
        fi
        
        print_colored "$MAGENTA" "Mode Verbose: $verbose_status"
        print_colored "$MAGENTA" "Logs: $LOG_FILE"
        echo ""
        
        print_colored "$BRIGHT_YELLOW$BOLD" "MENU DE CONFIGURATION"
        echo ""
        
        print_colored "$WHITE" "1. Configuration DHCP (automatique)"
        print_colored "$WHITE" "2. Configuration IP fixe ($IP)"
        print_colored "$WHITE" "3. Configuration IP personnalisée"
        print_colored "$WHITE" "4. Afficher la configuration actuelle"
        print_colored "$WHITE" "5. Afficher les interfaces disponibles"
        print_colored "$WHITE" "6. Test de connectivité réseau"
        print_colored "$WHITE" "7. Basculer mode verbose ($verbose_status)"
        print_colored "$WHITE" "8. Afficher l'historique des logs"
        print_colored "$WHITE" "9. Modifier les paramètres"
        print_colored "$WHITE" "10. Quitter"
        echo ""
        
        read -p "$(echo -e "${BRIGHT_WHITE}Choisissez une option (1-10): ${NC}")" choix
        log_write "INFO" "Utilisateur a choisi l'option: $choix"
        
        case $choix in
            1)
                if configurer_dhcp; then
                    read -p "$(echo -e "${GREEN}Appuyez sur Entrée pour continuer...${NC}")"
                else
                    read -p "$(echo -e "${RED}Appuyez sur Entrée pour continuer...${NC}")"
                fi
                ;;
            2)
                if configurer_ip_fixe "$IP"; then
                    read -p "$(echo -e "${GREEN}Appuyez sur Entrée pour continuer...${NC}")"
                else
                    read -p "$(echo -e "${RED}Appuyez sur Entrée pour continuer...${NC}")"
                fi
                ;;
            3)
                read -p "$(echo -e "${BRIGHT_WHITE}Entrez l'adresse IP (XXX.XXX.XXX.XXX): ${NC}")" ip_personnalisee
                if [ -n "$ip_personnalisee" ]; then
                    if configurer_ip_fixe "$ip_personnalisee"; then
                        read -p "$(echo -e "${GREEN}Appuyez sur Entrée pour continuer...${NC}")"
                    else
                        read -p "$(echo -e "${RED}Appuyez sur Entrée pour continuer...${NC}")"
                    fi
                fi
                ;;
            4)
                afficher_config
                read -p "$(echo -e "${BRIGHT_WHITE}Appuyez sur Entrée pour continuer...${NC}")"
                ;;
            5)
                afficher_interfaces
                read -p "$(echo -e "${BRIGHT_WHITE}Appuyez sur Entrée pour continuer...${NC}")"
                ;;
            6)
                test_connectivite
                read -p "$(echo -e "${BRIGHT_WHITE}Appuyez sur Entrée pour continuer...${NC}")"
                ;;
            7)
                if [ "$VERBOSE_MODE" = true ]; then
                    VERBOSE_MODE=false
                    print_warning "Mode verbose DÉSACTIVÉ"
                else
                    VERBOSE_MODE=true
                    print_success "Mode verbose ACTIVÉ"
                fi
                log_write "INFO" "Mode verbose basculé vers: $VERBOSE_MODE"
                sleep 1
                ;;
            8)
                afficher_historique
                read -p "$(echo -e "${BRIGHT_WHITE}Appuyez sur Entrée pour continuer...${NC}")"
                ;;
            9)
                modifier_parametres
                ;;
            10)
                print_colored "$BRIGHT_YELLOW" "Fermeture du script..."
                log_write "INFO" "Fermeture normale du script par l'utilisateur"
                exit 0
                ;;
            *)
                print_error "Option '$choix' non valide"
                log_write "WARNING" "Option invalide: $choix"
                sleep 1
                ;;
        esac
    done
}

# ===============================================================================
# SCRIPT PRINCIPAL
# ===============================================================================

main() {
    # Initialisation du logging
    log_write "INFO" "Démarrage du script IP Configuration Shell v$VERSION"
    log_write "INFO" "Système d'exploitation détecté: $OS_TYPE"
    
    # Vérification des privilèges
    check_root
    
    print_success "Privilèges root confirmés"
    sleep 1
    
    # Lancement du menu principal
    afficher_menu
}

# Gestion des signaux (Ctrl+C)
trap 'echo -e "\n${BRIGHT_YELLOW}Script interrompu par l'\''utilisateur${NC}"; log_write "INFO" "Script interrompu par Ctrl+C"; exit 130' INT

# Exécution du script principal
main "$@"