# 🚀 Pull Request

## 📋 Description

<!-- Décrivez brièvement les changements apportés -->

## 🎯 Type de changement

<!-- Cochez les cases appropriées -->

- [ ] 🐛 Bug fix (changement qui corrige un problème)
- [ ] ✨ Nouvelle fonctionnalité (changement qui ajoute une fonctionnalité)
- [ ] 💥 Breaking change (correction ou fonctionnalité qui causerait un dysfonctionnement des fonctionnalités existantes)
- [ ] 📝 Documentation (changements de documentation uniquement)
- [ ] 🔧 Refactoring (changement de code qui ne corrige ni n'ajoute de fonctionnalité)
- [ ] ⚡ Performance (changement qui améliore les performances)
- [ ] 🧪 Tests (ajout ou correction de tests)
- [ ] 🏗️ Build/CI (changements du système de build ou des dépendances)

## 🔍 Changements détaillés

<!-- Décrivez en détail ce qui a été modifié -->

### Scripts modifiés
- [ ] `scripts/ip_config.bat` - Script Windows principal
- [ ] `scripts/script_IPchange.py` - Script Python multiplateforme  
- [ ] `scripts/script_IPchange.sh` - Script Shell Unix
- [ ] `scripts/list_interfaces.py` - Utilitaire de détection
- [ ] Autres: _précisez_

### Documentation mise à jour
- [ ] `README.md`
- [ ] `docs/QUICK_START.md`
- [ ] `docs/CHANGELOG.md` 
- [ ] Autres: _précisez_

## 🧪 Tests effectués

<!-- Décrivez les tests que vous avez effectués -->

### Environnements testés
- [ ] Windows 10/11
- [ ] macOS (dernière version)
- [ ] Linux Ubuntu
- [ ] Autres: _précisez_

### Types de tests
- [ ] Tests de fonctionnalité de base
- [ ] Tests avec privilèges administrateur/root
- [ ] Tests de configuration DHCP
- [ ] Tests de configuration IP fixe  
- [ ] Tests de configuration IP personnalisée
- [ ] Tests du mode verbose
- [ ] Tests des logs
- [ ] Tests de connectivité réseau
- [ ] Tests d'erreurs et de récupération

## 📊 Impact

### Compatibilité
- [ ] Compatible avec les versions précédentes
- [ ] Nécessite une migration ou des changements de configuration
- [ ] Breaking change (nécessite une version majeure)

### Performance
- [ ] Améliore les performances
- [ ] Maintient les performances actuelles
- [ ] Impact négligeable sur les performances
- [ ] Pourrait impacter les performances (justifier ci-dessous)

## 🔗 Issues liées

<!-- Liez les issues GitHub concernées -->
- Fixes #(numéro d'issue)
- Addresses #(numéro d'issue)
- Related to #(numéro d'issue)

## 📝 Notes pour les reviewers

<!-- Informations importantes pour ceux qui vont examiner la PR -->

### Points d'attention particuliers
<!-- Y a-t-il des parties du code qui nécessitent une attention spéciale ? -->

### Questions ouvertes
<!-- Y a-t-il des questions ou des incertitudes à discuter ? -->

## ✅ Checklist

### Développement
- [ ] Mon code suit les conventions de style du projet
- [ ] J'ai effectué une auto-review de mon code
- [ ] J'ai commenté mon code, particulièrement dans les zones difficiles à comprendre
- [ ] J'ai apporté les changements correspondants à la documentation
- [ ] Mes changements ne génèrent pas de nouveaux warnings
- [ ] J'ai ajouté des tests qui prouvent que ma correction est efficace ou que ma fonctionnalité fonctionne
- [ ] Les tests unitaires nouveaux et existants passent localement avec mes changements

### Tests et validation
- [ ] J'ai testé le script avec les privilèges administrateur/root appropriés
- [ ] J'ai testé sur au moins un système d'exploitation cible
- [ ] J'ai vérifié que les logs sont générés correctement
- [ ] J'ai testé les cas d'erreur et la gestion d'erreurs
- [ ] J'ai vérifié la compatibilité ascendante si applicable

### Documentation
- [ ] J'ai mis à jour le README.md si nécessaire
- [ ] J'ai mis à jour les commentaires dans le code
- [ ] J'ai ajouté ou mis à jour les exemples d'utilisation
- [ ] J'ai documenté les nouvelles options ou paramètres

### Versioning (si applicable)
- [ ] J'ai mis à jour les numéros de version dans les scripts
- [ ] J'ai mis à jour le CHANGELOG.md
- [ ] Cette PR justifie une nouvelle version (patch/minor/major)

## 🔄 Migration (si nécessaire)

<!-- Si cette PR nécessite des étapes de migration pour les utilisateurs -->

### Étapes de migration
1. 
2. 
3. 

### Changements de configuration requis
<!-- Décrivez les changements que les utilisateurs doivent apporter -->

## 📸 Captures d'écran

<!-- Si applicable, ajoutez des captures d'écran pour montrer les changements visuels -->

## 🎉 Remerciements

<!-- Remerciez les personnes qui ont contribué à cette PR -->

---

**Note pour les maintainers**: Cette PR est prête pour review quand toutes les cases de la checklist sont cochées et que les tests CI/CD passent.
