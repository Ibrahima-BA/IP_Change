# IPchange - Script de Configuration Réseau Multiplateforme

## 🚀 Démarrage Rapide

**Nouveau sur macOS ?** → Consultez le [QUICK_START.md](QUICK_START.md) pour un guide adapté à votre système !

**Besoin de connaître vos interfaces ?** → Lancez `python3 list_interfaces.py`

## Description

Suite d'outils permettant de modifier facilement la configuration réseau (TCP/IP) de votre connexion Ethernet sur **Windows**, **macOS** et **Linux**. Les scripts offrent plusieurs options pour configurer rapidement votre adresse IP entre le mode DHCP, une IP fixe prédéfinie, ou une adresse IP personnalisée.

## 📦 Scripts Disponibles

### 1. `script_IPchange.py` - **RECOMMANDÉ** 🌟
Script Python multiplateforme qui détecte automatiquement votre système d'exploitation et utilise les commandes appropriées.
- ✅ Fonctionne sur Windows, macOS et Linux
- ✅ Détection automatique de l'OS
- ✅ Validation des adresses IP
- ✅ Interface utilisateur améliorée

### 2. `list_interfaces.py` - **UTILITAIRE** 🔍
Script Python pour identifier les interfaces réseau disponibles sur votre système.
- ✅ Affiche toutes les interfaces détectées
- ✅ Montre les configurations actuelles
- ✅ Aide à choisir le bon nom d'interface

### 3. `script_IPchange_ok.bat` - Windows uniquement
Script batch Windows original.
- ✅ Windows XP/Vista/7/8/10/11
- ❌ Ne fonctionne pas sur macOS/Linux

### 4. `script_IPchange.sh` - macOS/Linux
Script shell pour systèmes Unix.
- ✅ macOS (Darwin)
- ✅ Linux
- ❌ Ne fonctionne pas sur Windows

## Prérequis

### Pour tous les systèmes
- **Privilèges** : Droits administrateur/sudo requis
- **Connexion réseau** : Une interface réseau configurée

### Spécifique à chaque plateforme

**Windows** :
- Windows XP ou supérieur
- Commande `netsh` disponible

**macOS** :
- macOS 10.x ou supérieur
- Commande `networksetup` disponible

**Linux** :
- Distribution Linux moderne
- `dhclient` ou gestionnaire réseau (NetworkManager, systemd-networkd)

## Fonctionnalités

Le script propose 4 options principales :

1. **Configuration DHCP** : Configure l'interface pour obtenir automatiquement une adresse IP
2. **IP Fixe prédéfinie** : Configure l'interface avec l'IP `192.168.71.10`
3. **IP Personnalisée** : Permet de saisir manuellement une adresse IP
4. **Quitter** : Ferme le script

## Configuration par défaut

Les paramètres suivants sont préconfigurés dans le script :

```batch
NomConnexion=Ethernet
IP=192.168.71.10
Passerelle=192.168.71.254
Masque=255.255.255.0
DNS=10.10.131.1
```

## Utilisation

### 🐍 Script Python (Recommandé - Multiplateforme)

**Sur macOS/Linux** :
```bash
sudo python3 script_IPchange.py
```

**Sur Windows** :
```cmd
# Clic droit sur le terminal → Exécuter en tant qu'administrateur
python script_IPchange.py
```

### 🪟 Script Windows (.bat)

1. **Clic droit** sur `script_IPchange_ok.bat`
2. Sélectionnez **"Exécuter en tant qu'administrateur"**
3. Choisissez l'option souhaitée (1, 2, 3 ou 4)

### 🍎 Script macOS/Linux (.sh)

```bash
sudo ./script_IPchange.sh
```

**Note** : Sur macOS, vous devrez peut-être autoriser l'exécution dans les Préférences Système → Sécurité et Confidentialité.

### Sélection de l'option

Pour tous les scripts :
1. Tapez le numéro correspondant à l'option souhaitée (1, 2, 3 ou 4)
2. Appuyez sur **Entrée**

### Options détaillées

#### Option 1 : DHCP
- Configure la carte réseau en mode DHCP
- L'adresse IP et le DNS seront obtenus automatiquement depuis le serveur DHCP

#### Option 2 : IP Fixe
- Configure l'interface avec les paramètres suivants :
  - **IP** : 192.168.71.10
  - **Masque** : 255.255.255.0
  - **Passerelle** : 192.168.71.254
  - **DNS** : 10.10.131.1

#### Option 3 : IP Personnalisée
- Vous invite à saisir une adresse IP au format XX.XX.XX.XX
- Utilise les mêmes paramètres de masque, passerelle et DNS que l'option 2

#### Option 4 : Quitter
- Ferme le script sans effectuer de modifications

## Personnalisation

### Script Python (`script_IPchange.py`)

Éditez le dictionnaire `CONFIG` au début du fichier :

```python
CONFIG = {
    'interface': 'Ethernet',        # Pour Windows et Linux
    'interface_mac': 'Ethernet',    # Pour macOS (ou "Wi-Fi")
    'ip': '192.168.71.10',         # Adresse IP fixe par défaut
    'gateway': '192.168.71.254',    # Adresse de la passerelle
    'netmask': '255.255.255.0',    # Masque de sous-réseau
    'dns': '10.10.131.1'           # Serveur DNS primaire
}
```

### Script Windows (.bat)

Modifiez les variables au début du fichier :

```batch
SET NomConnexion=Ethernet        # Nom de votre interface réseau
SET IP=192.168.71.10            # Adresse IP fixe par défaut
SET Passerelle=192.168.71.254   # Adresse de la passerelle
SET DNS=10.10.131.1             # Serveur DNS primaire
```

### Script Shell (.sh)

Modifiez les variables au début du fichier :

```bash
NomConnexion="Ethernet"         # Ou "Wi-Fi" pour le WiFi
IP="192.168.71.10"             # Adresse IP fixe par défaut
Passerelle="192.168.71.254"    # Adresse de la passerelle
DNS="10.10.131.1"              # Serveur DNS primaire
```

### Trouver le nom de votre interface

**Windows** :
```cmd
netsh interface show interface
```

**macOS** :
```bash
networksetup -listallnetworkservices
```

**Linux** :
```bash
ip link show
# ou
ifconfig -a
```

## Dépannage

### 🚫 "Permission denied" ou "Accès refusé"
**Cause** : Le script n'a pas les privilèges administrateur

**Solution** :
- **macOS/Linux** : Ajoutez `sudo` devant la commande
- **Windows** : Exécutez en tant qu'administrateur (clic droit sur le fichier)

### 🔌 Erreur "Interface non trouvée"
**Cause** : Le nom de l'interface ne correspond pas

**Solution** :
1. Trouvez le vrai nom de votre interface (voir section "Trouver le nom de votre interface")
2. Modifiez le script avec le bon nom
3. Sur macOS, essayez "Wi-Fi" au lieu de "Ethernet" pour les connexions sans fil

### 📡 L'IP ne change pas
**Solution** :
1. Vérifiez que la configuration a bien été appliquée :
   - **Windows** : `ipconfig /all`
   - **macOS/Linux** : `ifconfig` ou `ip addr show`
2. Désactivez puis réactivez l'interface réseau
3. Redémarrez le gestionnaire réseau (Linux)

### 🐍 "Python not found" (Windows)
**Solution** :
1. Installez Python depuis [python.org](https://www.python.org/downloads/)
2. Lors de l'installation, cochez "Add Python to PATH"

### 🍎 macOS : "Operation not permitted"
**Cause** : Restrictions de sécurité macOS

**Solution** :
1. Allez dans Préférences Système → Sécurité et Confidentialité
2. Onglet "Confidentialité" → "Accès complet au disque"
3. Ajoutez Terminal à la liste des applications autorisées

## Commandes utilisées par plateforme

### Windows (`.bat` et `.py`)
- `netsh interface ip set address` : Configure l'adresse IP
- `netsh interface ip set dns` : Configure le serveur DNS
- `ipconfig` : Affiche la configuration réseau actuelle

### macOS (`.sh` et `.py`)
- `networksetup -setdhcp` : Active le DHCP
- `networksetup -setmanual` : Configure une IP fixe
- `networksetup -setdnsservers` : Configure le DNS
- `ifconfig` : Affiche la configuration réseau

### Linux (`.sh` et `.py`)
- `dhclient` : Client DHCP
- `ip addr add` : Ajoute une adresse IP
- `ip route add` : Configure la passerelle
- `ifconfig` ou `ip` : Affiche la configuration

## 💡 Exemples d'utilisation

### Exemple 1 : Passage rapide en DHCP (macOS)
```bash
# Lancer le script Python
sudo python3 script_IPchange.py

# Choisir l'option 1 pour DHCP
1
```

### Exemple 2 : Configuration IP fixe pour un réseau local (Windows)
```cmd
# Exécuter en tant qu'administrateur
python script_IPchange.py

# Choisir l'option 2 pour l'IP prédéfinie (192.168.71.10)
2
```

### Exemple 3 : Configuration d'une IP personnalisée (Linux)
```bash
# Lancer avec sudo
sudo ./script_IPchange.sh

# Choisir l'option 3
3
# Entrer votre IP
192.168.1.100
```

## 🧪 Test du script (macOS)

Vous pouvez tester immédiatement le script Python sur votre Mac :

```bash
cd /Users/ibrahimaba/Documents/GitHub/IPchange
sudo python3 script_IPchange.py
```

Le script détectera automatiquement que vous êtes sur macOS et utilisera les commandes appropriées (`networksetup`).

## Avertissements

⚠️ **Important** :
- Ces scripts modifient les paramètres réseau de votre système
- Une mauvaise configuration peut vous empêcher d'accéder au réseau
- **Notez votre configuration actuelle avant d'utiliser les scripts**
- Utilisez uniquement sur des réseaux dont vous avez l'autorisation de modifier les paramètres
- Sur macOS/Linux, l'utilisation de `sudo` donne un accès root complet

## 🔒 Sécurité

- Les scripts ne collectent aucune donnée
- Aucune connexion internet n'est effectuée
- Les modifications sont locales uniquement
- Le code source est ouvert et auditable

## 📝 Licence

Ces scripts sont fournis tels quels, sans garantie d'aucune sorte.

## 🤝 Contribution

N'hésitez pas à proposer des améliorations ou signaler des problèmes !

## 📚 Ressources supplémentaires

### Documentation officielle
- **Windows** : [Documentation netsh](https://docs.microsoft.com/en-us/windows-server/networking/technologies/netsh/netsh-contexts)
- **macOS** : [Documentation networksetup](https://ss64.com/osx/networksetup.html)
- **Linux** : [Documentation ip command](https://man7.org/linux/man-pages/man8/ip.8.html)

### Commandes utiles

**Afficher la configuration réseau actuelle** :
```bash
# Windows
ipconfig /all

# macOS
networksetup -getinfo Ethernet
ifconfig

# Linux
ip addr show
ifconfig -a
```

**Réinitialiser la configuration réseau** :
```bash
# Windows
netsh int ip reset
ipconfig /flushdns

# macOS
sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder

# Linux
sudo systemctl restart NetworkManager
```

---

**Version** : 2.0 (Multiplateforme)  
**Dernière mise à jour** : Octobre 2025  
**Systèmes supportés** : Windows, macOS, Linux

