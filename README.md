# 🌐 IPchange - Suite de Configuration Réseau Multiplateforme

[![Version](https://img.shields.io/badge/version-3.0-blue.svg)](CHANGELOG.md)
[![Platforms](https://img.shields.io/badge/platforms-Windows%20%7C%20macOS%20%7C%20Linux-green.svg)](#compatibilité)
[![License](https://img.shields.io/badge/license-Open%20Source-lightgrey.svg)](#licence)

> **Suite d'outils complète** pour modifier facilement la configuration réseau (TCP/IP) de vos connexions sur **Windows**, **macOS** et **Linux**. Interface intuitive avec options DHCP, IP fixe et personnalisée.

## 🚀 Démarrage Ultra-Rapide

**Nouveau sur le projet ?** → Consultez le [Guide de Démarrage](docs/QUICK_START.md) pour commencer immédiatement !

**Besoin d'identifier vos interfaces ?** → Lancez `python3 scripts/list_interfaces.py`

## 📁 Structure du Projet

```
IP_Change/
├── 📂 scripts/          # Scripts de configuration
│   ├── ip_config.bat              # 🌟 Script Windows (RECOMMANDÉ)
│   ├── script_IPchange.py         # Script Python multiplateforme
│   ├── script_IPchange.sh         # Script Shell (macOS/Linux)
│   └── list_interfaces.py         # Utilitaire de détection d'interfaces
├── 📂 docs/             # Documentation complète
│   ├── QUICK_START.md             # Guide de démarrage rapide
│   ├── CHANGELOG.md               # Historique des versions
│   └── SUMMARY.md                 # Résumé du projet
├── 📂 examples/         # Exemples de configuration
│   └── config.example.txt         # Modèles de configuration
└── README.md           # Cette documentation
```

## ⭐ Fonctionnalités Principales

### 🎯 Script Windows - **OPTIMISÉ !**
- **Interface interactive complète** avec menu intuitif
- **Configuration DHCP** automatique
- **IP fixe prédéfinie** pour déploiements rapides  
- **IP personnalisée** avec validation
- **Vérification des privilèges** administrateur
- **Gestion d'erreurs avancée** avec suggestions de correction
- **Affichage de la configuration** actuelle
- **Modification des paramètres** par défaut en temps réel

### 🌐 Support Multiplateforme
- ✅ **Windows** (XP/Vista/7/8/10/11) - Scripts .bat et Python
- ✅ **macOS** (10.x+) - Scripts Python et Shell avec `networksetup`
- ✅ **Linux** (distributions modernes) - Scripts Python et Shell
- ✅ **Détection automatique de l'OS** dans le script Python

### 🛠️ Outils Utilitaires
- **Détection d'interfaces réseau** automatique
- **Validation des adresses IP** (format et plages)
- **Sauvegarde/Restauration** de configuration (DHCP)
- **Diagnostic réseau** intégré

## 💻 Installation et Utilisation

### Option 1: Script Windows (Recommandé)

```cmd
# 1. Télécharger le projet
git clone https://github.com/votre-username/IP_Change.git
cd IP_Change

# 2. Exécuter en tant qu'administrateur
# Clic droit sur scripts/ip_config.bat → "Exécuter en tant qu'administrateur"
```

**Interface du script :**
```
========================================
  Configuration TCP/IP
========================================

Interface réseau configurée: Ethernet
IP fixe prédéfinie: 192.168.71.10
Passerelle: 192.168.71.254
DNS: 10.10.131.1

----------------------------------------
  MENU DE CONFIGURATION
----------------------------------------

1. Configuration DHCP (automatique)
2. Configuration IP fixe (192.168.71.10)
3. Configuration IP personnalisée
4. Afficher la configuration actuelle
5. Modifier les paramètres par défaut
6. Quitter

Choisissez une option (1-6):
```

### Option 2: Script Python Multiplateforme

**Windows :**
```cmd
# Exécuter en tant qu'administrateur
cd IP_Change
python scripts/script_IPchange.py
```

**macOS/Linux :**
```bash
cd IP_Change
sudo python3 scripts/script_IPchange.py
```

### Option 3: Scripts Shell (Unix)

```bash
# macOS/Linux
sudo ./scripts/script_IPchange.sh
```

## ⚙️ Configuration Par Défaut

Les scripts utilisent ces paramètres prédéfinis (modifiables) :

```ini
Interface=Ethernet          # Nom de l'interface réseau
IP=192.168.71.10           # Adresse IP fixe par défaut
Passerelle=192.168.71.254  # Adresse de la passerelle
Masque=255.255.255.0       # Masque de sous-réseau
DNS=10.10.131.1            # DNS primaire
DNS_Secondaire=8.8.8.8     # DNS secondaire (Google)
```

## 🔧 Personnalisation Avancée

### Modifier les Paramètres par Défaut

**Script Windows :** Utilisez l'option 5 du menu pour modifier interactivement

**Script Python :** Éditez le dictionnaire `CONFIG` dans `scripts/script_IPchange.py`
```python
CONFIG = {
    'interface': 'Ethernet',        # Pour Windows et Linux
    'interface_mac': 'Wi-Fi',       # Pour macOS
    'ip': '10.0.151.100',          # Votre réseau local
    'gateway': '10.0.151.1',        # Votre routeur
    'netmask': '255.255.255.0',    
    'dns': '8.8.8.8'               # DNS Google ou votre DNS local
}
```

### Identifier Vos Interfaces Réseau

```bash
# Utiliser l'utilitaire intégré (tous systèmes)
python3 scripts/list_interfaces.py

# Commandes système natives
# Windows
netsh interface show interface

# macOS
networksetup -listallnetworkservices

# Linux  
ip link show
```

## 🔍 Diagnostic et Dépannage

### Problèmes Courants

| Erreur | Cause | Solution |
|--------|-------|----------|
| "Permission denied" | Pas de privilèges admin | Exécuter avec `sudo` ou en tant qu'administrateur |
| "Interface non trouvée" | Nom d'interface incorrect | Utiliser `list_interfaces.py` pour identifier |
| "Commande non trouvée" | Python non installé | Installer Python 3.x |
| Configuration non appliquée | Gestionnaire réseau actif | Redémarrer le service réseau |

### Vérification de la Configuration

```bash
# Afficher la configuration actuelle
# Windows
ipconfig /all

# macOS
networksetup -getinfo "Wi-Fi"
ifconfig en0

# Linux
ip addr show
ifconfig -a
```

### Restauration d'Urgence

En cas de perte de connectivité :
1. **Option DHCP** → Restore la configuration automatique
2. **Redémarrage** → Les paramètres persistent, redémarrer peut aider
3. **Interface physique** → Débrancher/rebrancher le câble réseau

## 📊 Comparaison des Scripts

| Fonctionnalité | Script Windows (.bat) | Script Python | Script Shell |
|----------------|----------------------|---------------|--------------|
| **Interface graphique** | ✅ Menu complet | ✅ Interface texte | ✅ Interface basique |
| **Validation entrées** | ✅ Avancée | ✅ Complète | ⚠️ Basique |
| **Gestion erreurs** | ✅ Détaillée | ✅ Complète | ⚠️ Limitée |
| **Configuration live** | ✅ Modification à chaud | ❌ | ❌ |
| **Windows** | ✅ Natif | ✅ Python requis | ❌ |
| **macOS** | ❌ | ✅ | ✅ |
| **Linux** | ❌ | ✅ | ✅ |

## 🛡️ Sécurité et Bonnes Pratiques

### ✅ Mesures de Sécurité Implémentées
- Vérification des privilèges administrateur
- Validation des formats d'adresses IP
- Confirmation avant application des changements
- Messages d'erreur détaillés sans exposition de données sensibles
- Code source ouvert et auditable

### ⚠️ Recommandations d'Usage
- **Sauvegarder** votre configuration actuelle avant modifications
- **Tester en DHCP** avant configuration IP fixe
- **Demander autorisation** sur les réseaux d'entreprise
- **Éviter** les plages d'IP réservées (192.168.1.1, etc.)
- **Documenter** vos configurations personnalisées

## 🎓 Exemples d'Usage Avancés

### Déploiement en Entreprise

```batch
REM Configuration pour poste de travail
REM Modifier ip_config.bat avant déploiement
SET IP_FIXE=192.168.100.50
SET PASSERELLE=192.168.100.1
SET DNS_PRIMAIRE=192.168.100.10
```

### Configuration Multi-Réseaux

```python
# Profils réseau dans script_IPchange.py
PROFILS = {
    'bureau': {'ip': '10.0.1.50', 'gateway': '10.0.1.1'},
    'maison': {'ip': '192.168.1.50', 'gateway': '192.168.1.1'},
    'laboratoire': {'ip': '172.16.1.50', 'gateway': '172.16.1.1'}
}
```

## 📚 Documentation Complète

- **[Guide de Démarrage Rapide](docs/QUICK_START.md)** - Pour commencer immédiatement
- **[Historique des Changements](docs/CHANGELOG.md)** - Versions et améliorations  
- **[Résumé du Projet](docs/SUMMARY.md)** - Vue d'ensemble complète
- **[Exemples de Configuration](examples/)** - Modèles prêts à l'emploi

## 🤝 Contribution et Support

### Signaler un Problème
1. Vérifier la [section dépannage](#-diagnostic-et-dépannage)
2. Utiliser `list_interfaces.py` pour le diagnostic
3. Consulter le [changelog](docs/CHANGELOG.md) pour les problèmes connus

### Améliorer le Projet
1. Fork le repository
2. Créer une branche feature (`git checkout -b feature/amélioration`)
3. Tester sur votre plateforme
4. Proposer une pull request avec description détaillée

### Roadmap
- [ ] Interface graphique (GUI) multiplateforme
- [ ] Profiles de réseau prédéfinis
- [ ] Sauvegarde/restauration de configurations
- [ ] Tests automatisés CI/CD
- [ ] Support IPv6
- [ ] API REST pour intégration

## 📄 Licence et Crédits

**Licence :** Open Source - Utilisation libre pour usage personnel et professionnel

**Contributions :** Ce projet rassemble et améliore plusieurs scripts de configuration réseau avec une interface complète et une documentation détaillée.

**Compatibilité :** Testé sur Windows 10/11, macOS Big Sur+, Ubuntu 20.04+

---

## 🏷️ Tags et Versions

**Version Actuelle :** 3.0.0  
**Date de Release :** Octobre 2025  
**Statut :** Production Ready  

**Mots-clés :** réseau, IP, configuration, DHCP, TCP/IP, Windows, macOS, Linux, script, batch, python, shell

---

> **✨ Prêt à configurer vos réseaux comme un pro ?** Commencez par le [Guide de Démarrage](docs/QUICK_START.md) ! 🚀