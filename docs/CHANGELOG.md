# 📋 Changelog - IP_Change

Toutes les modifications notables de ce projet seront documentées dans ce fichier.

Le format est basé sur [Keep a Changelog](https://keepachangelog.com/fr/1.0.0/),
et ce projet adhère au [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Non publié]

### Ajouté
- Tests automatisés avec GitHub Actions

### Modifié
- Interface utilisateur améliorée avec couleurs

### Dépréciés
- Ancien format de configuration (sera supprimé en v4.0.0)

### Supprimé
- Support pour Windows XP (fin de vie)

### Corrigé
- Problème de détection d'interface sur macOS Big Sur

### Sécurité
- Validation renforcée des adresses IP

---

## [3.1.0] - 2025-10-27

### 🚀 Version majeure avec interface avancée et logging complet

Cette version marque une évolution significative du projet avec l'ajout d'une interface colorée, d'un système de logging avancé et de fonctionnalités de diagnostic.

### ✨ Nouvelles fonctionnalités

#### Interface utilisateur
- **Interface colorée complète** pour tous les scripts
- **Mode verbose** activable/désactivable dynamiquement
- **Menus interactifs** avec navigation améliorée
- **Messages d'état** avec codes couleur (succès, erreur, warning, info)
- **Validation en temps réel** des saisies utilisateur

#### Système de logging
- **Logs automatiques** avec horodatage précis
- **Fichiers de logs** organisés par session et historique permanent
- **Niveaux de log** multiples (INFO, ERROR, SUCCESS, WARNING, VERBOSE)
- **Rotation des logs** avec fichiers horodatés
- **Affichage de l'historique** des opérations dans l'interface

#### Diagnostic et connectivité
- **Tests de connectivité** réseau complets (passerelle, DNS, Internet)
- **Validation d'adresses IP** avec vérification de format et plages
- **Détection automatique** des interfaces réseau disponibles
- **Diagnostic d'erreurs** avec suggestions de correction
- **Vérification des privilèges** administrateur automatique

#### Configuration avancée
- **Modification des paramètres** en temps réel via l'interface
- **DNS secondaire** automatique (Google 8.8.8.8)
- **Sauvegarde de configuration** via logs
- **Confirmation utilisateur** pour les modifications critiques

### 🔧 Améliorations techniques

#### Script Windows (.bat)
- **Gestion d'erreurs** robuste avec codes de sortie appropriés
- **Fonctions de logging** intégrées avec coloration Windows
- **Interface menu** avec 9 options (vs 4 auparavant)
- **Validation des entrées** utilisateur complète
- **Gestion des timeouts** pour éviter les blocages

#### Script Python (.py)
- **Support couleurs ANSI** multiplateforme avec fallback Windows
- **Classes orientées objet** pour une meilleure organisation
- **Gestion d'exceptions** complète avec logging détaillé
- **Tests de performance** intégrés
- **Support IPv4** avec préparation IPv6

#### Script Shell (.sh)
- **Compatibilité** macOS et Linux améliorée
- **Détection automatique** du système d'exploitation
- **Gestion des signaux** (Ctrl+C) propre
- **Validation des commandes** avant exécution
- **Support des formats CIDR** pour Linux

### 📁 Organisation du projet

#### Structure de fichiers
- **Dossier logs/** automatiquement créé
- **Séparation claire** des utilitaires et scripts principaux
- **Documentation** organisée dans docs/
- **Exemples** dans examples/

#### Workflows GitHub
- **CI/CD complet** avec tests multi-plateforme
- **Gestion automatique des versions** avec détection de changements
- **Analyse de sécurité** et qualité du code
- **Création automatique de releases** avec packages

### 🛡️ Sécurité et qualité

#### Sécurité
- **Validation des privilèges** avant exécution
- **Pas de secrets** hardcodés dans le code
- **Validation des entrées** pour éviter les injections
- **Logs sécurisés** sans exposition d'informations sensibles

#### Qualité
- **Standards de code** cohérents entre tous les scripts
- **Gestion d'erreurs** uniforme
- **Tests automatisés** sur Windows, macOS et Linux
- **Documentation** complète avec exemples

### 🐛 Corrections importantes

- **Gestion des interfaces** avec espaces dans le nom (macOS)
- **Codes de sortie** appropriés pour l'intégration avec d'autres outils
- **Détection des erreurs** réseau améliorée
- **Compatibilité** avec les anciennes versions de Python (3.9+)
- **Gestion des caractères** spéciaux dans les logs

### 🔄 Changements de compatibilité

#### Nouveaux prérequis
- **Python 3.9+** (au lieu de 3.6+)
- **Privilèges administrateur** obligatoires (plus de mode dégradé)
- **Dossier logs/** créé automatiquement

#### Changements d'interface
- **Nouveau menu** avec options supplémentaires (peut nécessiter des ajustements de scripts automatisés)
- **Format des logs** modifié (plus détaillé)
- **Messages d'erreur** plus explicites

### 📊 Statistiques de cette version

- **~800 lignes** de code ajoutées
- **3 workflows** GitHub Actions créés
- **9 nouvelles options** de menu
- **5 types de logs** différents
- **20+ fonctions** utilitaires ajoutées
- **Tests sur 3 OS** et 4 versions Python

---

## [3.0.0] - 2025-10-27

### 🎯 Refonte complète avec structure professionnelle

Version majeure qui transforme le projet d'un script simple en une suite d'outils professionnelle.

### ✨ Ajouté

#### Structure du projet
- **Dossier scripts/** avec tous les scripts de configuration
- **Dossier docs/** avec documentation complète
- **Dossier examples/** avec modèles de configuration
- **Script unifié Windows** `ip_config.bat` (maintenant `ip_config.bat`)
- **.gitignore** configuré pour exclure fichiers sensibles et temporaires

#### Scripts améliorés
- **Interface interactive** complète avec menu à 6 options
- **Vérification privilèges** administrateur automatique
- **Gestion d'erreurs** avancée avec suggestions
- **Configuration des paramètres** par défaut modifiable
- **Support multiplateforme** confirmé (Windows/macOS/Linux)

#### Documentation
- **README.md** complètement refondu avec badges et structure moderne
- **Guide de démarrage rapide** adapté à macOS
- **Documentation des fonctionnalités** détaillée
- **Section dépannage** complète
- **Exemples d'utilisation** concrets

### 🔧 Modifié

#### Scripts existants
- **Tous les scripts** déplacés dans scripts/
- **Organisation logique** des fichiers par type
- **Documentation inline** améliorée
- **Validation des entrées** utilisateur

#### Interface utilisateur
- **Menus plus intuitifs** avec descriptions claires
- **Messages d'erreur** explicites avec solutions
- **Confirmation** avant modifications critiques
- **Affichage** de la configuration actuelle

### 🗑️ Supprimé
- **Scripts batch** redondants (consolidés)
- **Fichiers temporaires** de développement
- **Documentation** obsolète

### 🐛 Corrigé
- **Problèmes de permissions** sur macOS
- **Détection d'interfaces** réseau améliorée
- **Gestion des erreurs** réseau robuste
- **Compatibilité** avec différentes versions Windows

### 🔒 Sécurité
- **Vérification** des privilèges requis
- **Validation** des adresses IP saisies
- **Pas de stockage** de mots de passe ou secrets
- **Logs sécurisés** sans informations sensibles

---

## [2.0.0] - 2025-10-26

### 🌐 Support multiplateforme

### ✨ Ajouté
- **Script Python** multiplateforme `script_IPchange.py`
- **Script Shell** pour macOS/Linux `script_IPchange.sh`
- **Utilitaire** de détection d'interfaces `list_interfaces.py`
- **Support macOS** avec commandes `networksetup`
- **Support Linux** avec commandes `ip` et `dhclient`
- **Détection automatique** du système d'exploitation
- **Validation** des adresses IP saisies

### 🔧 Modifié
- **Script Windows** amélioré avec plus d'options
- **Interface utilisateur** plus conviviale
- **Messages d'aide** contextuels
- **Gestion d'erreurs** robuste

### 🐛 Corrigé
- **Problèmes de compatibilité** Windows
- **Gestion des interfaces** avec noms spéciaux
- **Validation** des paramètres réseau

---

## [1.0.0] - 2025-10-25

### 🎉 Version initiale

### ✨ Ajouté
- **Script Windows** de base `script_IPchange_ok.bat`
- **Configuration DHCP** automatique
- **Configuration IP fixe** prédéfinie
- **Configuration IP** personnalisée
- **Interface menu** simple
- **Documentation** de base

### Fonctionnalités de base
- Configuration réseau Windows via `netsh`
- Options DHCP et IP statique
- Validation basique des entrées
- Messages d'erreur simples

---

## Types de changements

- **Ajouté** pour les nouvelles fonctionnalités
- **Modifié** pour les changements de fonctionnalités existantes
- **Dépréciés** pour les fonctionnalités qui seront supprimées
- **Supprimé** pour les fonctionnalités supprimées
- **Corrigé** pour les corrections de bugs
- **Sécurité** en cas de vulnérabilités

## Versioning

Ce projet utilise [Semantic Versioning](https://semver.org/) :

- **MAJOR** version (X.0.0) : changements incompatibles
- **MINOR** version (0.X.0) : nouvelles fonctionnalités compatibles
- **PATCH** version (0.0.X) : corrections de bugs compatibles

## Liens

- [Repository GitHub](https://github.com/votre-username/IP_Change)
- [Releases](https://github.com/votre-username/IP_Change/releases)
- [Issues](https://github.com/votre-username/IP_Change/issues)
- [Discussions](https://github.com/votre-username/IP_Change/discussions)

---

**Note** : Les dates sont au format AAAA-MM-JJ. Les liens vers les versions pointent vers les releases GitHub correspondantes.