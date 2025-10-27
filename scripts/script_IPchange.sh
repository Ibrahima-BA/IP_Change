#!/bin/bash

# Script de configuration réseau pour macOS
# Nécessite les privilèges sudo

NomConnexion="Wi-Fi"  # ou "Ethernet", "AX88179A" pour adaptateur USB
IP="192.168.71.10"
Passerelle="192.168.71.254"
Masque="255.255.255.0"
DNS="10.10.131.1"

echo "================================================"
echo "    Configuration réseau pour macOS"
echo "================================================"
echo ""
echo "1: DHCP"
echo "2: IP fixe ($IP)"
echo "3: Autre IP"
echo "4: Quitter"
echo ""

# Fonction pour afficher les interfaces disponibles
afficher_interfaces() {
    echo ""
    echo "Interfaces réseau disponibles :"
    networksetup -listallnetworkservices | grep -v "An asterisk"
    echo ""
}

# Fonction pour configurer en DHCP
configurer_dhcp() {
    echo ""
    echo "Mise à jour de la configuration TCP/IP en DHCP..."
    
    if sudo networksetup -setdhcp "$NomConnexion" 2>/dev/null; then
        sudo networksetup -setdnsservers "$NomConnexion" "Empty"
        echo "✓ Configuration DHCP appliquée avec succès"
    else
        echo "✗ Erreur : Interface '$NomConnexion' introuvable"
        afficher_interfaces
        echo "Modifiez la variable NomConnexion dans le script"
        return 1
    fi
}

# Fonction pour configurer une IP fixe
configurer_ip_fixe() {
    local ip_address=$1
    echo ""
    echo "Mise à jour de la configuration TCP/IP vers l'adresse $ip_address"
    
    if sudo networksetup -setmanual "$NomConnexion" "$ip_address" "$Masque" "$Passerelle" 2>/dev/null; then
        sudo networksetup -setdnsservers "$NomConnexion" "$DNS"
        echo "✓ Configuration IP fixe appliquée avec succès"
        echo "  - IP: $ip_address"
        echo "  - Masque: $Masque"
        echo "  - Passerelle: $Passerelle"
        echo "  - DNS: $DNS"
    else
        echo "✗ Erreur : Interface '$NomConnexion' introuvable"
        afficher_interfaces
        echo "Modifiez la variable NomConnexion dans le script"
        return 1
    fi
}

# Fonction pour afficher la configuration actuelle
afficher_config() {
    echo ""
    echo "Configuration réseau actuelle :"
    echo "================================================"
    ifconfig | grep -A 1 "inet " | head -n 10
    echo "================================================"
}

# Boucle principale
while true; do
    read -p "Quelle configuration souhaitez-vous appliquer ? (1-4): " choix
    
    case $choix in
        1)
            configurer_dhcp
            break
            ;;
        2)
            configurer_ip_fixe "$IP"
            break
            ;;
        3)
            read -p "Entrez votre adresse IP au format XX.XX.XX.XX : " adresse_custom
            
            # Validation basique de l'IP
            if [[ $adresse_custom =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
                configurer_ip_fixe "$adresse_custom"
            else
                echo "✗ Format d'adresse IP invalide"
                continue
            fi
            break
            ;;
        4)
            echo "Au revoir !"
            exit 0
            ;;
        *)
            echo "✗ '$choix' n'est pas une option valide !"
            echo ""
            ;;
    esac
done

# Attendre 3 secondes et afficher la configuration
sleep 3
afficher_config

echo ""
read -p "Appuyez sur Entrée pour continuer..."

