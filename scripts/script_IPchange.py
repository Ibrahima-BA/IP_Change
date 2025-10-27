#!/usr/bin/env python3
"""
Script multiplateforme de configuration réseau avec Logging et Interface Colorée
Fonctionne sur Windows, macOS et Linux
Version: 3.1.0
"""

import platform
import subprocess
import sys
import re
import time
import os
import logging
from datetime import datetime
from pathlib import Path

# Couleurs ANSI pour terminaux Unix et Windows 10+
class Colors:
    # Reset
    RESET = '\033[0m'
    
    # Couleurs de base
    BLACK = '\033[30m'
    RED = '\033[31m'
    GREEN = '\033[32m'
    YELLOW = '\033[33m'
    BLUE = '\033[34m'
    MAGENTA = '\033[35m'
    CYAN = '\033[36m'
    WHITE = '\033[37m'
    
    # Couleurs brillantes
    BRIGHT_BLACK = '\033[90m'
    BRIGHT_RED = '\033[91m'
    BRIGHT_GREEN = '\033[92m'
    BRIGHT_YELLOW = '\033[93m'
    BRIGHT_BLUE = '\033[94m'
    BRIGHT_MAGENTA = '\033[95m'
    BRIGHT_CYAN = '\033[96m'
    BRIGHT_WHITE = '\033[97m'
    
    # Styles
    BOLD = '\033[1m'
    DIM = '\033[2m'
    UNDERLINE = '\033[4m'
    
    # Arrière-plans
    BG_RED = '\033[41m'
    BG_GREEN = '\033[42m'
    BG_YELLOW = '\033[43m'
    BG_BLUE = '\033[44m'

    @staticmethod
    def enable_windows_colors():
        """Active les couleurs ANSI sur Windows 10+"""
        if platform.system() == "Windows":
            try:
                import ctypes
                kernel32 = ctypes.windll.kernel32
                kernel32.SetConsoleMode(kernel32.GetStdHandle(-11), 7)
                return True
            except:
                return False
        return True

# Configuration par défaut
CONFIG = {
    'interface': 'Ethernet',  # Pour Windows et Linux
    'interface_mac': 'Wi-Fi',  # Pour macOS (peut être "Ethernet", "AX88179A", etc.)
    'ip': '192.168.71.10',
    'gateway': '192.168.71.254',
    'netmask': '255.255.255.0',
    'dns': '10.10.131.1',
    'dns_secondary': '8.8.8.8',
    'version': '3.1.0'
}

class NetworkLogger:
    """Gestionnaire de logs pour les opérations réseau"""
    
    def __init__(self, log_dir="logs"):
        self.log_dir = Path(__file__).parent.parent / log_dir
        self.log_dir.mkdir(exist_ok=True)
        
        # Fichiers de log
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        self.log_file = self.log_dir / f"ip_config_python_{timestamp}.log"
        self.history_file = self.log_dir / "ip_config_history.log"
        
        # Configuration du logger
        logging.basicConfig(
            level=logging.INFO,
            format='[%(asctime)s] [%(levelname)s] %(message)s',
            handlers=[
                logging.FileHandler(self.log_file, encoding='utf-8'),
                logging.FileHandler(self.history_file, encoding='utf-8', mode='a')
            ]
        )
        self.logger = logging.getLogger(__name__)
        
    def log(self, level, message):
        """Écrit un message dans les logs"""
        if level.upper() == 'INFO':
            self.logger.info(message)
        elif level.upper() == 'ERROR':
            self.logger.error(message)
        elif level.upper() == 'WARNING':
            self.logger.warning(message)
        elif level.upper() == 'SUCCESS':
            self.logger.info(f"SUCCESS: {message}")
        elif level.upper() == 'VERBOSE':
            self.logger.info(f"VERBOSE: {message}")

class NetworkConfigurator:
    def __init__(self):
        # Initialisation des couleurs
        Colors.enable_windows_colors()
        
        self.os_type = platform.system()
        self.verbose_mode = False
        self.logger = NetworkLogger()
        
        self.logger.log('INFO', f"Démarrage du script IP Configuration Python v{CONFIG['version']}")
        self.logger.log('INFO', f"Système d'exploitation détecté: {self.os_type}")
        
        self.print_colored(Colors.BRIGHT_CYAN + Colors.BOLD, f"Système d'exploitation détecté : {self.os_type}")
        self.print_colored(Colors.CYAN, "=" * 60)
        
    def print_colored(self, color, message):
        """Affiche un message coloré"""
        print(f"{color}{message}{Colors.RESET}")
        
    def print_verbose(self, message):
        """Affiche un message en mode verbose"""
        if self.verbose_mode:
            self.print_colored(Colors.DIM, f"[VERBOSE] {message}")
            self.logger.log('VERBOSE', message)
    
    def print_header(self, title):
        """Affiche un en-tête coloré"""
        line = "=" * len(title)
        self.print_colored(Colors.BRIGHT_YELLOW + Colors.BOLD, line)
        self.print_colored(Colors.BRIGHT_YELLOW + Colors.BOLD, title)
        self.print_colored(Colors.BRIGHT_YELLOW + Colors.BOLD, line)
    
    def print_success(self, message):
        """Affiche un message de succès"""
        self.print_colored(Colors.BRIGHT_GREEN + Colors.BOLD, f"✓ {message}")
        self.logger.log('SUCCESS', message)
    
    def print_error(self, message):
        """Affiche un message d'erreur"""
        self.print_colored(Colors.BRIGHT_RED + Colors.BOLD, f"✗ {message}")
        self.logger.log('ERROR', message)
    
    def print_warning(self, message):
        """Affiche un message d'avertissement"""
        self.print_colored(Colors.BRIGHT_YELLOW, f"⚠ {message}")
        self.logger.log('WARNING', message)
    
    def print_info(self, message):
        """Affiche un message d'information"""
        self.print_colored(Colors.BRIGHT_BLUE, f"ℹ {message}")
        self.logger.log('INFO', message)
        
    def check_admin(self):
        """Vérifie si le script a les privilèges administrateur"""
        self.print_verbose("Vérification des privilèges administrateur...")
        
        if self.os_type == "Windows":
            try:
                import ctypes
                is_admin = ctypes.windll.shell32.IsUserAnAdmin()
                self.logger.log('INFO', f"Privilèges administrateur Windows: {is_admin}")
                return is_admin
            except:
                self.logger.log('ERROR', "Impossible de vérifier les privilèges administrateur Windows")
                return False
        else:
            # Pour Unix-like (macOS, Linux)
            is_root = os.geteuid() == 0
            self.logger.log('INFO', f"Privilèges root Unix: {is_root}")
            return is_root
    
    def run_command(self, command, shell=False, description=""):
        """Exécute une commande système avec logging"""
        if description:
            self.print_verbose(f"{description}")
        
        self.print_verbose(f"Commande: {command}")
        self.logger.log('INFO', f"Exécution commande: {command}")
        
        try:
            if isinstance(command, str) and not shell:
                command = command.split()
            
            result = subprocess.run(
                command,
                shell=shell,
                capture_output=True,
                text=True,
                timeout=30
            )
            
            self.logger.log('INFO', f"Code de sortie: {result.returncode}")
            if result.stdout:
                self.logger.log('INFO', f"Sortie: {result.stdout.strip()}")
            if result.stderr:
                self.logger.log('WARNING', f"Erreur: {result.stderr.strip()}")
            
            return result
            
        except subprocess.TimeoutExpired:
            self.print_error("Commande expirée (timeout)")
            self.logger.log('ERROR', f"Timeout sur commande: {command}")
            return None
        except Exception as e:
            self.print_error(f"Erreur lors de l'exécution : {e}")
            self.logger.log('ERROR', f"Exception sur commande {command}: {e}")
            return None
    
    def validate_ip(self, ip):
        """Valide le format d'une adresse IP"""
        pattern = r'^(\d{1,3}\.){3}\d{1,3}$'
        if not re.match(pattern, ip):
            return False
        
        parts = ip.split('.')
        for part in parts:
            if not 0 <= int(part) <= 255:
                return False
        return True
    
    def test_connectivity(self):
        """Test complet de connectivité réseau"""
        self.print_header("TEST DE CONNECTIVITÉ RÉSEAU")
        print()
        
        self.logger.log('INFO', "Début du test de connectivité réseau")
        
        tests = [
            ("Passerelle", CONFIG['gateway']),
            ("DNS primaire", CONFIG['dns']),
            ("Internet (Google DNS)", "8.8.8.8"),
            ("Internet (Cloudflare DNS)", "1.1.1.1")
        ]
        
        success_count = 0
        
        for test_name, target in tests:
            self.print_info(f"Test {test_name} ({target})...")
            
            if self.os_type == "Windows":
                result = self.run_command(f"ping -n 2 {target}", shell=True, f"Ping {test_name}")
            else:
                result = self.run_command(f"ping -c 2 {target}", shell=True, f"Ping {test_name}")
            
            if result and result.returncode == 0:
                self.print_success(f"{test_name} accessible")
                success_count += 1
            else:
                self.print_error(f"{test_name} non accessible")
        
        # Test DNS
        self.print_info("Test résolution DNS...")
        if self.os_type == "Windows":
            result = self.run_command("nslookup google.com", shell=True, "Test résolution DNS")
        else:
            result = self.run_command("nslookup google.com", shell=True, "Test résolution DNS")
        
        if result and result.returncode == 0:
            self.print_success("Résolution DNS fonctionnelle")
            success_count += 1
        else:
            self.print_error("Résolution DNS défaillante")
        
        print()
        if success_count >= 3:
            self.print_success(f"Tests réussis: {success_count}/5 - Connectivité OK")
        else:
            self.print_warning(f"Tests réussis: {success_count}/5 - Problèmes détectés")
        
        self.logger.log('INFO', f"Test de connectivité terminé: {success_count}/5 réussis")
    
    def show_current_config(self):
        """Affiche la configuration réseau actuelle"""
        self.print_header("CONFIGURATION RÉSEAU ACTUELLE")
        print()
        
        self.logger.log('INFO', "Affichage de la configuration réseau actuelle")
        
        if self.os_type == "Windows":
            self.print_info("Interface configurée dans le script:")
            self.print_colored(Colors.CYAN, f"  {CONFIG['interface']}")
            print()
            
            self.print_info("Configuration IP (ipconfig /all):")
            result = self.run_command("ipconfig /all", shell=True, "Récupération configuration Windows")
            if result:
                print(result.stdout)
                
        elif self.os_type == "Darwin":  # macOS
            interface = CONFIG['interface_mac']
            self.print_info(f"Interface configurée: {interface}")
            print()
            
            self.print_info("Configuration de l'interface:")
            result = self.run_command(f"networksetup -getinfo '{interface}'", shell=True, f"Configuration {interface}")
            if result:
                print(result.stdout)
            
            self.print_info("Détails réseau (ifconfig):")
            result = self.run_command("ifconfig", shell=True, "Configuration ifconfig")
            if result:
                # Filtrer pour ne montrer que les interfaces actives
                lines = result.stdout.split('\n')
                for line in lines:
                    if 'inet ' in line or 'flags=' in line:
                        print(line)
                        
        else:  # Linux
            self.print_info("Configuration réseau (ip addr):")
            result = self.run_command("ip addr show", shell=True, "Configuration Linux")
            if result:
                print(result.stdout)
    
    def configure_dhcp(self):
        """Configure l'interface en DHCP"""
        self.print_header("CONFIGURATION DHCP")
        print()
        
        self.logger.log('INFO', "Début configuration DHCP")
        
        if self.os_type == "Windows":
            interface = CONFIG['interface']
            self.print_info(f"Configuration DHCP sur {interface}...")
            
            # Configuration IP
            result = self.run_command(
                f'netsh interface ip set address name="{interface}" source=dhcp',
                shell=True,
                "Configuration IP DHCP"
            )
            
            if result and result.returncode == 0:
                # Configuration DNS
                result = self.run_command(
                    f'netsh interface ip set dns name="{interface}" source=dhcp',
                    shell=True,
                    "Configuration DNS DHCP"
                )
                
                if result and result.returncode == 0:
                    self.print_success("Configuration DHCP appliquée avec succès")
                    return True
            
            self.print_error("Échec de la configuration DHCP")
            return False
            
        elif self.os_type == "Darwin":  # macOS
            interface = CONFIG['interface_mac']
            self.print_info(f"Configuration DHCP sur {interface}...")
            
            result = self.run_command(
                f'networksetup -setdhcp "{interface}"',
                shell=True,
                "Configuration DHCP macOS"
            )
            
            if result and result.returncode == 0:
                self.print_success("Configuration DHCP appliquée avec succès")
                return True
            else:
                self.print_error("Échec de la configuration DHCP")
                return False
                
        else:  # Linux
            interface = CONFIG['interface']
            self.print_info(f"Configuration DHCP sur {interface}...")
            
            # Libérer l'IP actuelle
            self.run_command(f"dhclient -r {interface}", shell=True, "Libération IP actuelle")
            time.sleep(2)
            
            # Demander nouvelle IP
            result = self.run_command(f"dhclient {interface}", shell=True, "Demande nouvelle IP DHCP")
            
            if result and result.returncode == 0:
                self.print_success("Configuration DHCP appliquée avec succès")
                return True
            else:
                self.print_error("Échec de la configuration DHCP")
                return False
    
    def configure_static_ip(self, ip_address=None):
        """Configure une IP statique"""
        if ip_address is None:
            ip_address = CONFIG['ip']
            
        self.print_header("CONFIGURATION IP STATIQUE")
        print()
        
        self.logger.log('INFO', f"Début configuration IP statique: {ip_address}")
        
        if not self.validate_ip(ip_address):
            self.print_error(f"Adresse IP invalide : {ip_address}")
            return False
        
        if self.os_type == "Windows":
            interface = CONFIG['interface']
            self.print_info(f"Configuration IP statique sur {interface}...")
            self.print_colored(Colors.CYAN, f"  IP: {ip_address}")
            self.print_colored(Colors.CYAN, f"  Masque: {CONFIG['netmask']}")
            self.print_colored(Colors.CYAN, f"  Passerelle: {CONFIG['gateway']}")
            self.print_colored(Colors.CYAN, f"  DNS: {CONFIG['dns']}")
            print()
            
            # Configuration IP
            result = self.run_command(
                f'netsh interface ip set address name="{interface}" static {ip_address} {CONFIG["netmask"]} {CONFIG["gateway"]} 1',
                shell=True,
                "Configuration IP statique"
            )
            
            if result and result.returncode == 0:
                # Configuration DNS
                result = self.run_command(
                    f'netsh interface ip set dns name="{interface}" static {CONFIG["dns"]}',
                    shell=True,
                    "Configuration DNS primaire"
                )
                
                if result and result.returncode == 0:
                    # DNS secondaire
                    self.run_command(
                        f'netsh interface ip add dns name="{interface}" {CONFIG["dns_secondary"]} index=2',
                        shell=True,
                        "Configuration DNS secondaire"
                    )
                    
                    self.print_success("Configuration IP statique appliquée avec succès")
                    return True
            
            self.print_error("Échec de la configuration IP statique")
            return False
            
        elif self.os_type == "Darwin":  # macOS
            interface = CONFIG['interface_mac']
            self.print_info(f"Configuration IP statique sur {interface}...")
            
            result = self.run_command(
                f'networksetup -setmanual "{interface}" {ip_address} {CONFIG["netmask"]} {CONFIG["gateway"]}',
                shell=True,
                "Configuration IP statique macOS"
            )
            
            if result and result.returncode == 0:
                # Configuration DNS
                result = self.run_command(
                    f'networksetup -setdnsservers "{interface}" {CONFIG["dns"]} {CONFIG["dns_secondary"]}',
                    shell=True,
                    "Configuration DNS macOS"
                )
                
                if result and result.returncode == 0:
                    self.print_success("Configuration IP statique appliquée avec succès")
                    return True
            
            self.print_error("Échec de la configuration IP statique")
            return False
            
        else:  # Linux
            interface = CONFIG['interface']
            self.print_info(f"Configuration IP statique sur {interface}...")
            
            # Supprimer l'IP actuelle
            self.run_command(f"ip addr flush dev {interface}", shell=True, "Suppression IP actuelle")
            
            # Configurer nouvelle IP
            result = self.run_command(
                f"ip addr add {ip_address}/{self._get_cidr_from_netmask(CONFIG['netmask'])} dev {interface}",
                shell=True,
                "Configuration nouvelle IP"
            )
            
            if result and result.returncode == 0:
                # Activer l'interface
                self.run_command(f"ip link set {interface} up", shell=True, "Activation interface")
                
                # Configurer la passerelle
                self.run_command(f"ip route add default via {CONFIG['gateway']}", shell=True, "Configuration passerelle")
                
                self.print_success("Configuration IP statique appliquée avec succès")
                return True
            
            self.print_error("Échec de la configuration IP statique")
            return False
    
    def _get_cidr_from_netmask(self, netmask):
        """Convertit un masque de sous-réseau en notation CIDR"""
        cidr_map = {
            '255.255.255.0': '24',
            '255.255.0.0': '16',
            '255.0.0.0': '8',
            '255.255.255.128': '25',
            '255.255.255.192': '26',
            '255.255.255.224': '27',
            '255.255.255.240': '28',
            '255.255.255.248': '29',
            '255.255.255.252': '30'
        }
        return cidr_map.get(netmask, '24')
    
    def show_log_history(self):
        """Affiche l'historique des logs"""
        self.print_header("HISTORIQUE DES OPÉRATIONS")
        print()
        
        try:
            if self.logger.history_file.exists():
                self.print_info("Dernières opérations (50 dernières lignes):")
                print()
                
                with open(self.logger.history_file, 'r', encoding='utf-8') as f:
                    lines = f.readlines()
                    for line in lines[-50:]:
                        # Colorier selon le niveau de log
                        if '[ERROR]' in line:
                            self.print_colored(Colors.RED, line.strip())
                        elif '[SUCCESS]' in line:
                            self.print_colored(Colors.GREEN, line.strip())
                        elif '[WARNING]' in line:
                            self.print_colored(Colors.YELLOW, line.strip())
                        else:
                            print(line.strip())
            else:
                self.print_warning("Aucun historique disponible")
                
            print()
            self.print_info(f"Fichier log actuel: {self.logger.log_file}")
            self.print_info(f"Historique complet: {self.logger.history_file}")
            
        except Exception as e:
            self.print_error(f"Impossible de lire l'historique: {e}")
    
    def show_menu(self):
        """Affiche et gère le menu principal"""
        while True:
            try:
                # Nettoyage écran (compatible multiplateforme)
                os.system('cls' if self.os_type == 'Windows' else 'clear')
                
                self.print_header(f"CONFIGURATION TCP/IP v{CONFIG['version']} - Interface Python Avancée")
                print()
                
                self.print_info(f"Système: {self.os_type}")
                if self.os_type == "Darwin":
                    self.print_info(f"Interface: {CONFIG['interface_mac']}")
                else:
                    self.print_info(f"Interface: {CONFIG['interface']}")
                self.print_info(f"IP prédéfinie: {CONFIG['ip']}")
                self.print_info(f"Passerelle: {CONFIG['gateway']}")
                self.print_info(f"DNS: {CONFIG['dns']}")
                print()
                
                verbose_status = "ACTIVÉ" if self.verbose_mode else "DÉSACTIVÉ"
                self.print_colored(Colors.MAGENTA, f"Mode Verbose: {verbose_status}")
                self.print_colored(Colors.MAGENTA, f"Logs: {self.logger.log_file}")
                print()
                
                self.print_colored(Colors.BRIGHT_YELLOW + Colors.BOLD, "MENU DE CONFIGURATION")
                print()
                
                menu_items = [
                    "1. Configuration DHCP (automatique)",
                    f"2. Configuration IP fixe ({CONFIG['ip']})",
                    "3. Configuration IP personnalisée",
                    "4. Afficher la configuration actuelle",
                    "5. Test de connectivité réseau",
                    f"6. Basculer mode verbose ({verbose_status})",
                    "7. Afficher l'historique des logs",
                    "8. Modifier les paramètres",
                    "9. Quitter"
                ]
                
                for item in menu_items:
                    self.print_colored(Colors.WHITE, item)
                print()
                
                choice = input(f"{Colors.BRIGHT_WHITE}Choisissez une option (1-9): {Colors.RESET}")
                self.logger.log('INFO', f"Utilisateur a choisi l'option: {choice}")
                
                if choice == '1':
                    if self.configure_dhcp():
                        input(f"\n{Colors.GREEN}Appuyez sur Entrée pour continuer...{Colors.RESET}")
                        
                elif choice == '2':
                    if self.configure_static_ip():
                        input(f"\n{Colors.GREEN}Appuyez sur Entrée pour continuer...{Colors.RESET}")
                        
                elif choice == '3':
                    custom_ip = input(f"{Colors.BRIGHT_WHITE}Entrez l'adresse IP (XXX.XXX.XXX.XXX): {Colors.RESET}")
                    if custom_ip:
                        if self.configure_static_ip(custom_ip):
                            input(f"\n{Colors.GREEN}Appuyez sur Entrée pour continuer...{Colors.RESET}")
                    
                elif choice == '4':
                    self.show_current_config()
                    input(f"\n{Colors.BRIGHT_WHITE}Appuyez sur Entrée pour continuer...{Colors.RESET}")
                    
                elif choice == '5':
                    self.test_connectivity()
                    input(f"\n{Colors.BRIGHT_WHITE}Appuyez sur Entrée pour continuer...{Colors.RESET}")
                    
                elif choice == '6':
                    self.verbose_mode = not self.verbose_mode
                    status = "activé" if self.verbose_mode else "désactivé"
                    self.print_success(f"Mode verbose {status}")
                    self.logger.log('INFO', f"Mode verbose {status}")
                    time.sleep(1)
                    
                elif choice == '7':
                    self.show_log_history()
                    input(f"\n{Colors.BRIGHT_WHITE}Appuyez sur Entrée pour continuer...{Colors.RESET}")
                    
                elif choice == '8':
                    self.modify_settings()
                    
                elif choice == '9':
                    self.print_colored(Colors.BRIGHT_YELLOW, "Fermeture du script...")
                    self.logger.log('INFO', "Fermeture normale du script par l'utilisateur")
                    break
                    
                else:
                    self.print_error(f"Option '{choice}' non valide")
                    self.logger.log('WARNING', f"Option invalide: {choice}")
                    time.sleep(1)
                    
            except KeyboardInterrupt:
                print(f"\n{Colors.BRIGHT_YELLOW}Script interrompu par l'utilisateur{Colors.RESET}")
                self.logger.log('INFO', "Script interrompu par Ctrl+C")
                break
            except Exception as e:
                self.print_error(f"Erreur inattendue: {e}")
                self.logger.log('ERROR', f"Erreur inattendue: {e}")
                input(f"\n{Colors.BRIGHT_WHITE}Appuyez sur Entrée pour continuer...{Colors.RESET}")
    
    def modify_settings(self):
        """Interface de modification des paramètres"""
        while True:
            os.system('cls' if self.os_type == 'Windows' else 'clear')
            self.print_header("MODIFICATION DES PARAMÈTRES")
            print()
            
            settings = [
                f"1. Interface réseau: {CONFIG['interface'] if self.os_type != 'Darwin' else CONFIG['interface_mac']}",
                f"2. IP fixe: {CONFIG['ip']}",
                f"3. Passerelle: {CONFIG['gateway']}",
                f"4. Masque réseau: {CONFIG['netmask']}",
                f"5. DNS primaire: {CONFIG['dns']}",
                f"6. DNS secondaire: {CONFIG['dns_secondary']}",
                "7. Retour au menu principal"
            ]
            
            for setting in settings:
                self.print_colored(Colors.CYAN, setting)
            print()
            
            choice = input(f"{Colors.BRIGHT_WHITE}Quel paramètre modifier (1-7) ? {Colors.RESET}")
            
            if choice == '1':
                new_interface = input(f"{Colors.BRIGHT_WHITE}Nouvelle interface: {Colors.RESET}")
                if new_interface:
                    if self.os_type == 'Darwin':
                        CONFIG['interface_mac'] = new_interface
                    else:
                        CONFIG['interface'] = new_interface
                    self.print_success("Interface modifiée")
                    self.logger.log('INFO', f"Interface modifiée: {new_interface}")
                    
            elif choice == '2':
                new_ip = input(f"{Colors.BRIGHT_WHITE}Nouvelle IP fixe: {Colors.RESET}")
                if new_ip and self.validate_ip(new_ip):
                    CONFIG['ip'] = new_ip
                    self.print_success("IP fixe modifiée")
                    self.logger.log('INFO', f"IP fixe modifiée: {new_ip}")
                else:
                    self.print_error("IP invalide")
                    
            elif choice == '3':
                new_gateway = input(f"{Colors.BRIGHT_WHITE}Nouvelle passerelle: {Colors.RESET}")
                if new_gateway and self.validate_ip(new_gateway):
                    CONFIG['gateway'] = new_gateway
                    self.print_success("Passerelle modifiée")
                    self.logger.log('INFO', f"Passerelle modifiée: {new_gateway}")
                else:
                    self.print_error("Passerelle invalide")
                    
            elif choice == '4':
                new_netmask = input(f"{Colors.BRIGHT_WHITE}Nouveau masque réseau: {Colors.RESET}")
                if new_netmask and self.validate_ip(new_netmask):
                    CONFIG['netmask'] = new_netmask
                    self.print_success("Masque réseau modifié")
                    self.logger.log('INFO', f"Masque réseau modifié: {new_netmask}")
                else:
                    self.print_error("Masque réseau invalide")
                    
            elif choice == '5':
                new_dns = input(f"{Colors.BRIGHT_WHITE}Nouveau DNS primaire: {Colors.RESET}")
                if new_dns and self.validate_ip(new_dns):
                    CONFIG['dns'] = new_dns
                    self.print_success("DNS primaire modifié")
                    self.logger.log('INFO', f"DNS primaire modifié: {new_dns}")
                else:
                    self.print_error("DNS invalide")
                    
            elif choice == '6':
                new_dns_sec = input(f"{Colors.BRIGHT_WHITE}Nouveau DNS secondaire: {Colors.RESET}")
                if new_dns_sec and self.validate_ip(new_dns_sec):
                    CONFIG['dns_secondary'] = new_dns_sec
                    self.print_success("DNS secondaire modifié")
                    self.logger.log('INFO', f"DNS secondaire modifié: {new_dns_sec}")
                else:
                    self.print_error("DNS invalide")
                    
            elif choice == '7':
                break
            else:
                self.print_error("Option non valide")
            
            if choice != '7':
                time.sleep(2)

def main():
    """Fonction principale"""
    try:
        config = NetworkConfigurator()
        
        # Vérification des privilèges
        if not config.check_admin():
            config.print_error("Ce script nécessite des privilèges administrateur/root")
            config.print_warning("Relancez avec 'sudo' (macOS/Linux) ou en tant qu'administrateur (Windows)")
            sys.exit(1)
        
        config.print_success("Privilèges administrateur confirmés")
        time.sleep(1)
        
        # Lancement du menu principal
        config.show_menu()
        
    except KeyboardInterrupt:
        print(f"\n{Colors.BRIGHT_YELLOW}Script interrompu par l'utilisateur{Colors.RESET}")
    except Exception as e:
        print(f"{Colors.BRIGHT_RED}Erreur fatale: {e}{Colors.RESET}")
        sys.exit(1)

if __name__ == "__main__":
    main()