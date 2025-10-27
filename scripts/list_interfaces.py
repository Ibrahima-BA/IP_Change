#!/usr/bin/env python3
"""
Script pour lister les interfaces réseau disponibles sur votre système
Fonctionne sur Windows, macOS et Linux
"""

import platform
import subprocess
import sys

def run_command(command, shell=False):
    """Exécute une commande et retourne le résultat"""
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

def list_interfaces_windows():
    """Liste les interfaces réseau sur Windows"""
    print("\n" + "=" * 60)
    print("Interfaces réseau Windows")
    print("=" * 60)
    
    success, output = run_command("netsh interface show interface", shell=True)
    if success:
        print(output)
        print("\n💡 Utilisez le nom dans la colonne 'Nom de l'interface' dans votre script")
    else:
        print("❌ Erreur lors de la récupération des interfaces")
        print(output)

def list_interfaces_mac():
    """Liste les interfaces réseau sur macOS"""
    print("\n" + "=" * 60)
    print("Interfaces réseau macOS")
    print("=" * 60)
    
    success, output = run_command(['networksetup', '-listallnetworkservices'])
    if success:
        interfaces = [line for line in output.split('\n') if line and not line.startswith('An asterisk')]
        print("\n📡 Services réseau disponibles :\n")
        for i, interface in enumerate(interfaces, 1):
            print(f"  {i}. {interface}")
        
        print("\n" + "-" * 60)
        print("\n🔍 Détails des interfaces :\n")
        
        for interface in interfaces:
            print(f"📍 {interface}")
            success_info, info = run_command(['networksetup', '-getinfo', interface])
            if success_info:
                print(info)
            print("-" * 60)
        
        print("\n💡 Utilisez le nom exact (ex: 'Ethernet', 'Wi-Fi') dans votre script")
    else:
        print("❌ Erreur lors de la récupération des interfaces")
        print(output)

def list_interfaces_linux():
    """Liste les interfaces réseau sur Linux"""
    print("\n" + "=" * 60)
    print("Interfaces réseau Linux")
    print("=" * 60)
    
    # Essayer avec ip
    success, output = run_command("ip link show", shell=True)
    if success:
        print("\n📡 Interfaces (ip link show) :\n")
        print(output)
    
    # Essayer avec ifconfig
    success, output = run_command("ifconfig -a", shell=True)
    if success:
        print("\n📡 Interfaces (ifconfig -a) :\n")
        print(output)
    
    print("\n💡 Utilisez le nom de l'interface (ex: 'eth0', 'wlan0', 'enp0s3') dans votre script")

def main():
    os_type = platform.system()
    
    print("=" * 60)
    print("    Détection des interfaces réseau")
    print("=" * 60)
    print(f"\n🖥️  Système d'exploitation : {os_type}")
    print(f"📍 Version : {platform.release()}")
    print(f"💻 Machine : {platform.machine()}")
    
    if os_type == "Windows":
        list_interfaces_windows()
    elif os_type == "Darwin":
        list_interfaces_mac()
    elif os_type == "Linux":
        list_interfaces_linux()
    else:
        print(f"\n❌ Système d'exploitation non supporté : {os_type}")
        sys.exit(1)
    
    print("\n" + "=" * 60)
    print("✅ Analyse terminée")
    print("=" * 60)

if __name__ == "__main__":
    main()

