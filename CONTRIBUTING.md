# 🤝 Guide de Contribution - IP_Change

Merci de votre intérêt pour contribuer au projet **IP_Change** ! Ce guide vous aidera à contribuer efficacement.

## 📋 Table des matières

- [Code de conduite](#code-de-conduite)
- [Comment contribuer](#comment-contribuer)
- [Signaler des bugs](#signaler-des-bugs)
- [Proposer des fonctionnalités](#proposer-des-fonctionnalités)
- [Contribuer au code](#contribuer-au-code)
- [Standards de développement](#standards-de-développement)
- [Tests](#tests)
- [Documentation](#documentation)
- [Processus de review](#processus-de-review)

## 🌟 Code de conduite

En participant, vous acceptez de respecter notre [Code of Conduct](CODE_OF_CONDUCT.md). Soyez respectueux et constructif dans toutes vos interactions.

## 🚀 Comment contribuer

Il y a plusieurs façons de contribuer :

### 🐛 Signaler des problèmes
- Utilisez les [templates d'issues](https://github.com/votre-username/IP_Change/issues/new/choose)
- Vérifiez qu'un problème similaire n'existe pas déjà
- Fournissez des informations détaillées

### ✨ Proposer des améliorations
- Ouvrez une [Feature Request](https://github.com/votre-username/IP_Change/issues/new?template=feature_request.yml)
- Décrivez clairement le besoin et la solution proposée
- Discutez de la faisabilité avec l'équipe

### 📝 Améliorer la documentation
- Corrigez les erreurs de frappe
- Améliorez les explications
- Ajoutez des exemples d'utilisation
- Traduisez dans d'autres langues

### 💻 Contribuer au code
- Corrigez des bugs
- Implémentez de nouvelles fonctionnalités
- Améliorez les performances
- Ajoutez des tests

## 🐛 Signaler des bugs

### Avant de signaler
1. **Vérifiez les issues existantes** - Le problème a peut-être déjà été signalé
2. **Testez avec la dernière version** - Le bug pourrait être déjà corrigé
3. **Reproduisez le problème** - Assurez-vous que c'est reproductible
4. **Vérifiez les privilèges** - Exécutez-vous le script en tant qu'administrateur/root ?

### Informations à inclure
- **Système d'exploitation** (Windows 10/11, macOS, Linux distribution)
- **Version du projet** (tag git ou commit hash)
- **Script concerné** (ip_config.bat, script_IPchange.py, etc.)
- **Étapes de reproduction** détaillées
- **Comportement attendu vs actuel**
- **Messages d'erreur** complets
- **Logs** (si disponibles dans le dossier logs/)
- **Configuration réseau** (type d'interface, IP actuelle, etc.)

## ✨ Proposer des fonctionnalités

### Processus de proposition
1. **Recherchez des demandes similaires** dans les issues
2. **Ouvrez une Feature Request** avec le template approprié
3. **Décrivez le problème** que la fonctionnalité résoudrait
4. **Proposez une solution** détaillée
5. **Discutez avec la communauté** et l'équipe de maintenance

### Critères d'évaluation
- **Utilité générale** - La fonctionnalité bénéficie-t-elle à la majorité des utilisateurs ?
- **Complexité d'implémentation** - Le rapport coût/bénéfice est-il acceptable ?
- **Compatibilité** - Cela casse-t-il les fonctionnalités existantes ?
- **Maintenance** - Cela ajoute-t-il une charge de maintenance significative ?

## 💻 Contribuer au code

### Processus de développement

1. **Fork** le repository
2. **Créez une branche** pour votre fonctionnalité/correction
   ```bash
   git checkout -b feature/nom-de-la-fonctionnalite
   # ou
   git checkout -b fix/description-du-bug
   ```
3. **Développez** votre changement
4. **Testez** sur les plateformes appropriées
5. **Commitez** avec des messages descriptifs
6. **Poussez** votre branche
7. **Ouvrez une Pull Request** avec le template approprié

### Conventions de nommage des branches
- `feature/description` - Nouvelles fonctionnalités
- `fix/description` - Corrections de bugs
- `docs/description` - Changements de documentation
- `refactor/description` - Refactoring sans changement fonctionnel
- `perf/description` - Améliorations de performance

### Messages de commit
Utilisez le format suivant :
```
type(scope): description courte

Description plus détaillée si nécessaire.

- Point 1
- Point 2

Fixes #123
```

**Types** :
- `feat` - Nouvelle fonctionnalité
- `fix` - Correction de bug
- `docs` - Documentation
- `style` - Formatage, style
- `refactor` - Refactoring
- `perf` - Performance
- `test` - Tests
- `chore` - Maintenance

**Exemples** :
```
feat(python): ajouter support IPv6 dans script_IPchange.py

- Détection automatique des adresses IPv6
- Configuration DHCP IPv6 
- Tests de connectivité IPv6

Fixes #456
```

```
fix(windows): corriger l'affichage des couleurs sur Windows 7

Le script utilisait des codes ANSI non supportés sur Windows 7.
Ajout d'une détection de version pour utiliser les couleurs appropriées.

Fixes #123
```

## 📏 Standards de développement

### Style de code

#### Scripts Batch (.bat)
- **Indentation** : 4 espaces
- **Variables** : CamelCase pour les variables (ex: `NomConnexion`)
- **Commentaires** : `::` pour les commentaires de section, `REM` pour les commentaires inline
- **Fonctions** : Utilisez des labels clairs (ex: `:config_dhcp`)

#### Scripts Python (.py)
- **PEP 8** : Suivez les conventions Python
- **Longueur de ligne** : Maximum 120 caractères
- **Docstrings** : Utilisez des docstrings pour toutes les fonctions
- **Type hints** : Ajoutez des annotations de type quand possible
- **Imports** : Groupés et triés (stdlib, third-party, local)

#### Scripts Shell (.sh)  
- **Indentation** : 4 espaces
- **Variables** : snake_case en minuscules
- **Quotes** : Toujours quoter les variables (`"$variable"`)
- **Fonctions** : Noms descriptifs en snake_case
- **Vérifications** : Toujours vérifier les codes de retour

### Structure des fichiers

#### En-tête des scripts
Tous les scripts doivent commencer par :
```bash
#!/usr/bin/env python3
"""
Description du script
Version: X.Y.Z
Fonctionnalités: liste des principales fonctions
Auteur: Nom
Date: Mois Année
"""
```

#### Sections obligatoires
1. **Configuration** - Variables et constantes
2. **Fonctions utilitaires** - Logging, validation, etc.
3. **Fonctions métier** - Configuration réseau
4. **Interface utilisateur** - Menus, interactions
5. **Script principal** - Point d'entrée

### Logging et debugging

#### Niveaux de log
- `INFO` - Informations générales
- `WARNING` - Avertissements non critiques  
- `ERROR` - Erreurs qui empêchent le fonctionnement
- `SUCCESS` - Opérations réussies
- `VERBOSE` - Informations détaillées pour le debugging

#### Format des logs
```
[YYYY-MM-DD HH:MM:SS] [NIVEAU] Message descriptif
```

### Gestion des erreurs

#### Principes
- **Fail-safe** - Ne jamais laisser le système dans un état incohérent
- **Messages clairs** - Expliquer ce qui s'est passé et comment corriger
- **Logs détaillés** - Enregistrer suffisamment d'informations pour le debugging
- **Codes de sortie** - Utiliser des codes d'erreur appropriés

#### Exemple Python
```python
try:
    result = run_command(cmd)
    if result.returncode != 0:
        self.print_error(f"Échec de la commande: {cmd}")
        self.logger.log('ERROR', f"Commande échouée: {cmd}, sortie: {result.stderr}")
        return False
    return True
except Exception as e:
    self.print_error(f"Erreur inattendue: {e}")
    self.logger.log('ERROR', f"Exception: {e}")
    return False
```

## 🧪 Tests

### Tests obligatoires
Avant de soumettre une PR, testez sur :

#### Systèmes d'exploitation
- **Windows 10/11** - Script .bat et Python
- **macOS** (dernière version) - Scripts Python et Shell  
- **Linux Ubuntu** (LTS) - Scripts Python et Shell

#### Scénarios de test
1. **Installation propre** - Test sur un système vierge
2. **Privilèges administrateur** - Vérifier les permissions requises
3. **Configuration DHCP** - Test de configuration automatique
4. **IP fixe prédéfinie** - Test avec l'IP par défaut
5. **IP personnalisée** - Test avec différentes adresses IP
6. **Gestion d'erreurs** - Test avec des paramètres invalides
7. **Mode verbose** - Vérifier les informations supplémentaires
8. **Logs** - Vérifier la génération et le contenu des logs
9. **Tests de connectivité** - Ping, DNS, etc.

### Tests automatisés
Les GitHub Actions testent automatiquement :
- Syntaxe des scripts
- Style du code
- Sécurité (pas de secrets hardcodés)
- Performance de base
- Compatibilité multi-plateforme

### Tests manuels
Créez un rapport de test incluant :
```markdown
## Environnement de test
- OS: Windows 11 Pro
- Version Python: 3.11.0
- Interface: Wi-Fi
- Configuration actuelle: DHCP

## Tests effectués
- [x] Configuration DHCP - ✅ Succès
- [x] IP fixe (192.168.71.10) - ✅ Succès  
- [x] IP personnalisée (192.168.1.100) - ✅ Succès
- [x] Mode verbose - ✅ Informations détaillées affichées
- [x] Logs générés - ✅ Fichier créé dans logs/
- [x] Test connectivité - ✅ Tous les pings réussis
```

## 📝 Documentation

### Types de documentation
- **README.md** - Guide d'utilisation principal
- **QUICK_START.md** - Guide de démarrage rapide
- **CHANGELOG.md** - Historique des versions
- **Commentaires code** - Documentation inline
- **Docstrings** - Documentation des fonctions (Python)
- **Exemples** - Cas d'usage concrets

### Standards de documentation

#### Markdown
- Utilisez des **titres clairs** avec hiérarchie logique
- Ajoutez des **émojis** pour améliorer la lisibilité
- Incluez des **exemples de code** avec coloration syntaxique
- Utilisez des **liens** vers les sections pertinentes
- Ajoutez des **captures d'écran** quand approprié

#### Exemples de code
```bash
# ✅ Bon exemple avec contexte
# Configuration IP fixe sur Windows
# Nécessite des privilèges administrateur
netsh interface ip set address name="Ethernet" static 192.168.1.100 255.255.255.0 192.168.1.1

# ❌ Mauvais exemple sans contexte
netsh interface ip set address name="Ethernet" static 192.168.1.100 255.255.255.0 192.168.1.1
```

### Mise à jour de la documentation
Quand vous modifiez le code, mettez à jour :
- Les commentaires dans le code
- Le README.md si les fonctionnalités changent
- Le CHANGELOG.md pour chaque version
- Les exemples d'utilisation si nécessaire

## 🔍 Processus de review

### Critères de review
Les reviewers vérifieront :

#### Code
- **Fonctionnalité** - Le code fait-il ce qu'il est censé faire ?
- **Qualité** - Le code est-il propre et maintenable ?
- **Performance** - Y a-t-il des problèmes de performance ?
- **Sécurité** - Le code introduit-il des vulnérabilités ?
- **Compatibilité** - Cela fonctionne-t-il sur toutes les plateformes ?

#### Tests
- **Couverture** - Les tests couvrent-ils les nouvelles fonctionnalités ?
- **Qualité** - Les tests sont-ils pertinents et robustes ?
- **Résultats** - Tous les tests passent-ils ?

#### Documentation
- **Complétude** - La documentation est-elle à jour ?
- **Clarté** - Les explications sont-elles claires ?
- **Exemples** - Y a-t-il des exemples d'utilisation ?

### Répondre aux reviews
- **Soyez ouvert** aux suggestions et critiques constructives
- **Expliquez vos choix** si nécessaire
- **Apportez les corrections** demandées rapidement
- **Discutez** des points de désaccord de manière respectueuse
- **Remerciez** les reviewers pour leur temps

### Processus de merge
1. **Approbation** d'au moins un mainteneur
2. **Tests CI/CD** qui passent
3. **Conflits résolus** avec la branche principale
4. **Squash and merge** pour maintenir un historique propre

## 🎯 Conseils pour les nouveaux contributeurs

### Premiers pas
1. **Commencez petit** - Corrigez une faute de frappe, améliorez un commentaire
2. **Lisez le code** existant pour comprendre le style
3. **Posez des questions** - L'équipe est là pour vous aider
4. **Suivez les templates** - Ils vous guident vers de bonnes pratiques

### Idées de contributions faciles
- **Documentation** - Améliorer les explications
- **Traductions** - Traduire les messages d'erreur
- **Tests** - Ajouter des cas de test manqués
- **Exemples** - Créer des guides d'utilisation
- **Corrections mineures** - Typos, formatage

### Ressources utiles
- [GitHub Flow](https://guides.github.com/introduction/flow/) - Processus Git
- [Conventional Commits](https://conventionalcommits.org/) - Format des messages
- [Keep a Changelog](https://keepachangelog.com/) - Format du CHANGELOG

## 🙏 Reconnaissance

Tous les contributeurs sont listés dans le README.md et leurs contributions sont reconnues lors des releases.

### Types de contributions reconnues
- 💻 Code
- 📖 Documentation  
- 🐛 Rapports de bugs
- 💡 Idées et suggestions
- 🧪 Tests
- 🌍 Traductions
- 📢 Promotion
- 💬 Support communautaire

---

## 📞 Besoin d'aide ?

- **Questions générales** - Ouvrez une [Discussion](https://github.com/votre-username/IP_Change/discussions)
- **Problèmes techniques** - Ouvrez une [Issue](https://github.com/votre-username/IP_Change/issues)
- **Chat en temps réel** - Rejoignez notre [Discord/Slack]

**Merci de contribuer à IP_Change ! 🚀**
