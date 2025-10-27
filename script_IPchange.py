#!/usr/bin/env python3
"""
Script multiplateforme de configuration réseau
Fonctionne sur Windows, macOS et Linux
"""

import platform
import subprocess
import sys
import re
import time

# Configuration par défaut
CONFIG = {
    'interface': 'Ethernet',  # Pour Windows et Linux
    'interface_mac': 'Wi-Fi',  # Pour macOS (peut être "Ethernet", "AX88179A", etc.)
    'ip': '192.168.71.10',
    'gateway': '192.168.71.254',
    'netmask': '255.255.255.0',
    'dns': '10.10.131.1'
}

class NetworkConfigurator:
    def __init__(self):
        self.os_type = platform.system()
        print(f"Système d'exploitation détecté : {self.os_type}")
        print("=" * 50)
        
    def check_admin(self):
        """Vérifie si le script a les privilèges administrateur"""
        if self.os_type == "Windows":
            try:
                import ctypes
                return ctypes.windll.shell32.IsUserAnAdmin()
            except:
                return False
        else:
            # Pour Unix-like (macOS, Linux)
            import os
            return os.geteuid() == 0
    
    def run_command(self, command, shell=False):
        """Exécute une commande système"""
        try:
            if isinstance(command, str) and not shell:
                command = command.split()
            
            result = subprocess.run(
                command,
                shell=shell,
                capture_output=True,
                text=True,
                check=True
            )
            return True, result.stdout
        except subprocess.CalledProcessError as e:
            return False, e.stderr
        except Exception as e:
            return False, str(e)
    
    def configure_dhcp_windows(self):
        """Configure DHCP sur Windows"""
        print("\n🔄 Mise à jour de la configuration TCP/IP en DHCP...")
        
        cmd_ip = f'netsh interface ip set address "{CONFIG["interface"]}" dhcp'
        cmd_dns = f'netsh interface ip set dns "{CONFIG["interface"]}" dhcp'
        
        success1, output1 = self.run_command(cmd_ip, shell=True)
        success2, output2 = self.run_command(cmd_dns, shell=True)
        
        if success1 and success2:
            print("✓ Configuration DHCP appliquée avec succès")
            return True
        else:
            print("✗ Erreur lors de la configuration DHCP")
            print(output1, output2)
            return False
    
    def configure_dhcp_mac(self):
        """Configure DHCP sur macOS"""
        print("\n🔄 Mise à jour de la configuration TCP/IP en DHCP...")
        
        cmd_ip = ['networksetup', '-setdhcp', CONFIG['interface_mac']]
        cmd_dns = ['networksetup', '-setdnsservers', CONFIG['interface_mac'], 'Empty']
        
        success1, _ = self.run_command(cmd_ip)
        success2, _ = self.run_command(cmd_dns)
        
        if success1 and success2:
            print("✓ Configuration DHCP appliquée avec succès")
            return True
        else:
            print("✗ Erreur lors de la configuration DHCP")
            self.list_interfaces_mac()
            return False
    
    def configure_dhcp_linux(self):
        """Configure DHCP sur Linux"""
        print("\n🔄 Mise à jour de la configuration TCP/IP en DHCP...")
        print("⚠️  Sur Linux, utilisez votre gestionnaire réseau (NetworkManager, systemd-networkd, etc.)")
        
        # Tentative avec dhclient
        cmd = f'dhclient {CONFIG["interface"]}'
        success, output = self.run_command(cmd, shell=True)
        
        if success:
            print("✓ Configuration DHCP appliquée avec succès")
            return True
        else:
            print("✗ Erreur : Utilisez votre gestionnaire réseau pour configurer DHCP")
            return False
    
    def configure_static_windows(self, ip_address):
        """Configure IP fixe sur Windows"""
        print(f"\n🔄 Configuration de l'adresse IP : {ip_address}")
        
        cmd_ip = (f'netsh interface ip set address "{CONFIG["interface"]}" '
                 f'static {ip_address} {CONFIG["netmask"]} {CONFIG["gateway"]} 1')
        cmd_dns = f'netsh interface ip set dns "{CONFIG["interface"]}" static {CONFIG["dns"]}'
        
        success1, output1 = self.run_command(cmd_ip, shell=True)
        success2, output2 = self.run_command(cmd_dns, shell=True)
        
        if success1 and success2:
            print("✓ Configuration IP fixe appliquée avec succès")
            self.print_config(ip_address)
            return True
        else:
            print("✗ Erreur lors de la configuration")
            print(output1, output2)
            return False
    
    def configure_static_mac(self, ip_address):
        """Configure IP fixe sur macOS"""
        print(f"\n🔄 Configuration de l'adresse IP : {ip_address}")
        
        cmd_ip = ['networksetup', '-setmanual', CONFIG['interface_mac'],
                 ip_address, CONFIG['netmask'], CONFIG['gateway']]
        cmd_dns = ['networksetup', '-setdnsservers', CONFIG['interface_mac'], CONFIG['dns']]
        
        success1, _ = self.run_command(cmd_ip)
        success2, _ = self.run_command(cmd_dns)
        
        if success1 and success2:
            print("✓ Configuration IP fixe appliquée avec succès")
            self.print_config(ip_address)
            return True
        else:
            print("✗ Erreur lors de la configuration")
            self.list_interfaces_mac()
            return False
    
    def configure_static_linux(self, ip_address):
        """Configure IP fixe sur Linux"""
        print(f"\n🔄 Configuration de l'adresse IP : {ip_address}")
        print("⚠️  Sur Linux, utilisez votre gestionnaire réseau ou modifiez /etc/network/interfaces")
        
        # Tentative avec ip command
        interface = CONFIG["interface"]
        cmd_ip = f'ip addr add {ip_address}/{self.cidr_from_netmask(CONFIG["netmask"])} dev {interface}'
        cmd_gateway = f'ip route add default via {CONFIG["gateway"]}'
        
        success1, _ = self.run_command(cmd_ip, shell=True)
        success2, _ = self.run_command(cmd_gateway, shell=True)
        
        if success1 or success2:
            print("✓ Configuration appliquée (peut nécessiter redémarrage)")
            self.print_config(ip_address)
            return True
        else:
            print("✗ Erreur : Utilisez votre gestionnaire réseau")
            return False
    
    def list_interfaces_mac(self):
        """Liste les interfaces réseau sur macOS"""
        print("\n📡 Interfaces réseau disponibles :")
        success, output = self.run_command(['networksetup', '-listallnetworkservices'])
        if success:
            print(output)
    
    def cidr_from_netmask(self, netmask):
        """Convertit un masque de sous-réseau en notation CIDR"""
        return sum([bin(int(x)).count('1') for x in netmask.split('.')])
    
    def print_config(self, ip_address):
        """Affiche la configuration appliquée"""
        print(f"  - IP: {ip_address}")
        print(f"  - Masque: {CONFIG['netmask']}")
        print(f"  - Passerelle: {CONFIG['gateway']}")
        print(f"  - DNS: {CONFIG['dns']}")
    
    def show_current_config(self):
        """Affiche la configuration réseau actuelle"""
        print("\n" + "=" * 50)
        print("Configuration réseau actuelle :")
        print("=" * 50)
        
        if self.os_type == "Windows":
            self.run_command("ipconfig", shell=True)
        else:
            success, output = self.run_command("ifconfig", shell=True)
            if success:
                print(output)
    
    def validate_ip(self, ip_address):
        """Valide le format d'une adresse IP"""
        pattern = r'^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$'
        match = re.match(pattern, ip_address)
        
        if not match:
            return False
        
        # Vérifie que chaque octet est entre 0 et 255
        return all(0 <= int(octet) <= 255 for octet in match.groups())
    
    def configure_dhcp(self):
        """Configure DHCP selon l'OS"""
        if self.os_type == "Windows":
            return self.configure_dhcp_windows()
        elif self.os_type == "Darwin":
            return self.configure_dhcp_mac()
        elif self.os_type == "Linux":
            return self.configure_dhcp_linux()
        else:
            print(f"✗ Système d'exploitation non supporté : {self.os_type}")
            return False
    
    def configure_static(self, ip_address):
        """Configure IP fixe selon l'OS"""
        if self.os_type == "Windows":
            return self.configure_static_windows(ip_address)
        elif self.os_type == "Darwin":
            return self.configure_static_mac(ip_address)
        elif self.os_type == "Linux":
            return self.configure_static_linux(ip_address)
        else:
            print(f"✗ Système d'exploitation non supporté : {self.os_type}")
            return False
    
    def run(self):
        """Boucle principale du script"""
        # Vérification des privilèges
        if not self.check_admin():
            print("\n⚠️  ATTENTION : Ce script nécessite les privilèges administrateur")
            if self.os_type == "Windows":
                print("   → Exécutez en tant qu'administrateur")
            else:
                print("   → Utilisez : sudo python3 script_IPchange.py")
            print()
        
        # Menu
        print("\n1: DHCP")
        print(f"2: IP fixe ({CONFIG['ip']})")
        print("3: Autre IP")
        print("4: Quitter")
        print()
        
        while True:
            try:
                choix = input("Quelle configuration souhaitez-vous appliquer ? (1-4): ").strip()
                
                if choix == '1':
                    self.configure_dhcp()
                    break
                    
                elif choix == '2':
                    self.configure_static(CONFIG['ip'])
                    break
                    
                elif choix == '3':
                    ip_custom = input("Entrez votre adresse IP au format XX.XX.XX.XX : ").strip()
                    
                    if self.validate_ip(ip_custom):
                        self.configure_static(ip_custom)
                        break
                    else:
                        print("✗ Format d'adresse IP invalide\n")
                        continue
                        
                elif choix == '4':
                    print("\nAu revoir !")
                    sys.exit(0)
                    
                else:
                    print(f"✗ '{choix}' n'est pas une option valide !\n")
                    
            except KeyboardInterrupt:
                print("\n\nInterruption par l'utilisateur. Au revoir !")
                sys.exit(0)
            except Exception as e:
                print(f"✗ Erreur : {e}")
                sys.exit(1)
        
        # Attendre et afficher la configuration
        time.sleep(3)
        self.show_current_config()
        
        input("\nAppuyez sur Entrée pour continuer...")


if __name__ == "__main__":
    print("=" * 50)
    print("   Configuration réseau multiplateforme")
    print("=" * 50)
    
    configurator = NetworkConfigurator()
    configurator.run()

