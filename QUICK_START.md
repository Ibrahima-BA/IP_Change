# 🚀 Guide de Démarrage Rapide - IPchange

## Sur votre Mac actuel

Votre configuration réseau détectée :
- **Interface active** : Wi-Fi
- **IP actuelle** : 10.0.151.7
- **Système** : macOS (Darwin 25.1.0) sur ARM64

## 1️⃣ Première utilisation recommandée

### Lister vos interfaces réseau disponibles

```bash
cd /Users/ibrahimaba/Documents/GitHub/IPchange
python3 list_interfaces.py
```

Cette commande affiche toutes vos interfaces réseau (Wi-Fi, Ethernet USB, etc.).

## 2️⃣ Tester le script (sans sudo - mode démo)

Pour voir le fonctionnement sans modifier réellement votre configuration :

```bash
python3 script_IPchange.py
```

**Note** : Sans `sudo`, le script s'exécutera mais affichera des erreurs de permission. C'est normal et sans danger.

## 3️⃣ Utilisation réelle (avec privilèges)

⚠️ **ATTENTION** : Cela modifiera réellement votre configuration réseau !

### Passer en DHCP (recommandé pour tester)

```bash
sudo python3 script_IPchange.py
# Choisir l'option 1 (DHCP)
```

**Pourquoi DHCP ?** C'est l'option la plus sûre pour tester. Votre réseau vous redonnera automatiquement une IP valide.

### Configurer une IP fixe

```bash
sudo python3 script_IPchange.py
# Choisir l'option 2 (IP prédéfinie)
# ou option 3 (IP personnalisée)
```

## 4️⃣ Revenir à votre configuration actuelle

Si vous souhaitez revenir à votre configuration actuelle :

```bash
sudo python3 script_IPchange.py
# Choisir l'option 1 (DHCP)
```

Votre routeur (10.0.151.1) vous redonnera une IP automatiquement.

## 5️⃣ Vérifier votre configuration

Après toute modification :

```bash
# Voir votre IP actuelle
ifconfig en0

# Voir la configuration complète
networksetup -getinfo Wi-Fi

# Tester la connectivité
ping -c 3 8.8.8.8
```

## 🛡️ Conseils de sécurité

1. **Notez votre configuration actuelle** avant toute modification :
   ```bash
   networksetup -getinfo Wi-Fi > config_backup.txt
   ```

2. **Testez d'abord avec DHCP** : C'est réversible instantanément

3. **Gardez une session Terminal ouverte** : Si vous perdez la connexion, vous pourrez revenir en DHCP

4. **Sur un réseau d'entreprise** : Demandez l'autorisation avant de modifier quoi que ce soit

## 🔧 Personnalisation pour votre réseau

Si vous souhaitez utiliser une IP fixe sur votre réseau actuel (10.0.151.x), éditez le fichier :

```bash
nano script_IPchange.py
```

Modifiez ces valeurs dans `CONFIG` :

```python
CONFIG = {
    'interface_mac': 'Wi-Fi',       # Déjà correct pour votre Mac
    'ip': '10.0.151.100',          # Choisissez une IP libre
    'gateway': '10.0.151.1',        # Votre routeur actuel
    'netmask': '255.255.255.0',    # Masque standard
    'dns': '10.0.151.1'            # Ou 8.8.8.8 pour Google DNS
}
```

## 📱 Interfaces disponibles sur votre Mac

D'après la détection, vous avez :

| Interface | Description | État |
|-----------|-------------|------|
| Wi-Fi | Connexion sans fil | ✅ Active (10.0.151.7) |
| AX88179A | Adaptateur USB Ethernet | ⚪ Disponible |
| Eliobot | Interface personnalisée | ⚪ Disponible |
| Thunderbolt Bridge | Pont Thunderbolt | ⚪ Disponible |
| iPhone USB | Partage de connexion iPhone | ⚪ Disponible |

Pour changer d'interface, modifiez `interface_mac` dans le fichier de configuration.

## ❓ Questions fréquentes

### Le script fonctionne-t-il sur mon Mac M1/M2/M3 ?
✅ Oui ! Votre Mac utilise ARM64 et le script Python fonctionne parfaitement.

### Puis-je l'utiliser sur un MacBook ?
✅ Oui, tous les Mac sont supportés (MacBook, MacBook Pro, iMac, Mac Mini, etc.).

### Que se passe-t-il si je perds la connexion ?
🔧 Utilisez un câble Ethernet USB ou revenez en DHCP via le Terminal

### Puis-je annuler les changements ?
✅ Oui, option 1 (DHCP) restaure la configuration automatique

## 🎯 Exemple concret pour votre réseau

Pour configurer une IP fixe sur votre réseau Wi-Fi actuel :

```bash
# 1. Vérifier que 10.0.151.50 est libre
ping -c 1 10.0.151.50

# 2. Si pas de réponse (Request timeout), l'IP est libre
# 3. Modifier le script pour utiliser cette IP
nano script_IPchange.py

# 4. Exécuter avec sudo
sudo python3 script_IPchange.py

# 5. Choisir option 3 et entrer : 10.0.151.50
```

## 📞 Besoin d'aide ?

Si vous rencontrez un problème :

1. Consultez le [README.md](README.md) complet
2. Vérifiez la section **Dépannage** du README
3. Utilisez `list_interfaces.py` pour vérifier vos interfaces

---

**Prêt à commencer ?** Lancez `python3 list_interfaces.py` pour voir vos interfaces ! 🚀

