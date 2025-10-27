# Changelog - IPchange

Tous les changements notables de ce projet seront documentés dans ce fichier.

## [2.0.0] - 2025-10-27

### 🎉 Ajouté - Support Multiplateforme

#### Nouveaux Scripts
- **`script_IPchange.py`** : Script Python multiplateforme avec détection automatique de l'OS
  - Support complet de Windows, macOS et Linux
  - Détection automatique du système d'exploitation
  - Validation des adresses IP
  - Gestion d'erreurs améliorée
  - Interface utilisateur claire avec emojis et couleurs

- **`script_IPchange.sh`** : Script shell pour macOS et Linux
  - Support natif des commandes Unix
  - Utilise `networksetup` sur macOS
  - Affichage des interfaces disponibles
  - Validation des entrées utilisateur

- **`list_interfaces.py`** : Utilitaire de détection des interfaces réseau
  - Liste toutes les interfaces disponibles
  - Affiche la configuration actuelle de chaque interface
  - Compatible Windows, macOS et Linux
  - Guide l'utilisateur pour choisir le bon nom d'interface

#### Documentation
- **`README.md`** : Documentation complète mise à jour
  - Instructions spécifiques par plateforme
  - Section de dépannage étendue
  - Exemples d'utilisation concrets
  - Guide de personnalisation détaillé
  - Commandes réseau utiles pour chaque OS

- **`QUICK_START.md`** : Guide de démarrage rapide
  - Instructions simplifiées pour les nouveaux utilisateurs
  - Exemples adaptés au système macOS
  - Conseils de sécurité
  - Configuration réseau détectée

- **`config.example.txt`** : Fichier de configuration exemple
  - Exemples de configurations courantes
  - Documentation des paramètres
  - Guide d'application étape par étape

- **`.gitignore`** : Exclusions pour Git
  - Fichiers Python temporaires
  - Dossiers IDE
  - Logs et backups

### 🔧 Modifié

#### Scripts Existants
- **`script_IPchange_ok.bat`** : Script Windows original conservé
  - Aucune modification fonctionnelle
  - Toujours compatible Windows uniquement

### 🎯 Améliorations

#### Fonctionnalités
- Détection automatique de l'OS (Windows/Darwin/Linux)
- Validation des formats d'adresses IP
- Messages d'erreur plus clairs et informatifs
- Support des interfaces Wi-Fi et Ethernet
- Affichage de la configuration après application

#### Expérience Utilisateur
- Interface utilisateur améliorée avec emojis
- Messages d'aide contextuels
- Détection des permissions insuffisantes
- Suggestions en cas d'erreur
- Affichage des interfaces disponibles

### 📋 Support des Systèmes

| Système | Script Recommandé | Support |
|---------|-------------------|---------|
| Windows XP/Vista/7/8/10/11 | `script_IPchange.py` | ✅ Complet |
| macOS 10.x+ (Intel & ARM) | `script_IPchange.py` | ✅ Complet |
| Linux (toutes distributions) | `script_IPchange.py` | ✅ Complet |

### 🔒 Sécurité

- Vérification des privilèges administrateur
- Validation des entrées utilisateur
- Aucune collecte de données
- Code source ouvert et auditable

## [1.0.0] - Date Inconnue

### Ajouté
- **`script_IPchange_ok.bat`** : Script batch Windows original
  - Configuration DHCP
  - Configuration IP fixe prédéfinie
  - Configuration IP personnalisée
  - Support de Windows uniquement

---

## Types de Changements

- **Ajouté** : Nouvelles fonctionnalités
- **Modifié** : Changements dans les fonctionnalités existantes
- **Déprécié** : Fonctionnalités bientôt supprimées
- **Supprimé** : Fonctionnalités supprimées
- **Corrigé** : Corrections de bugs
- **Sécurité** : Corrections de vulnérabilités

## Migration depuis v1.0

Si vous utilisiez `script_IPchange_ok.bat` :

1. **Sur Windows** : Continuez à l'utiliser ou migrez vers `script_IPchange.py`
2. **Sur macOS/Linux** : Utilisez `script_IPchange.py` ou `script_IPchange.sh`

### Avantages de la migration vers Python

- ✅ Un seul script pour tous les systèmes
- ✅ Validation des entrées
- ✅ Messages d'erreur plus clairs
- ✅ Détection automatique de l'OS
- ✅ Support et mises à jour continues

### Compatibilité

Les scripts de la v2.0 n'interfèrent pas avec le script v1.0. Vous pouvez les utiliser en parallèle.

