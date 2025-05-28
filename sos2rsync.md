sos_rsync.md

## 1 - Monter répertoires avec linux pour Rsync

Pour se **déplacer sur un autre disque** en ligne de commande Linux (CLI), il faut d'abord **s'assurer que le disque est monté**, puis vous pouvez simplement utiliser `cd` pour vous y rendre.

### Étapes détaillées :

---

### 1. **Lister les disques disponibles**

Utilisez `lsblk` pour voir les disques et partitions :

```bash
lsblk
```

Exemple de sortie :

```
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda      8:0    0  500G  0 disk 
├─sda1   8:1    0  500G  0 part /
sdb      8:16   0  1T    0 disk 
└─sdb1   8:17   0  1T    0 part 
```

Ici, `sdb1` est une partition sur un second disque.

---

### 2. **Créer un point de montage (si besoin)**

Choisissez un répertoire où monter le disque, par exemple `/mnt/disque2` :

```bash
sudo mkdir -p /mnt/disque2
```

---

### 3. **Monter le disque**

Montez la partition (ex. `sdb1`) sur le point de montage :

```bash
sudo mount /dev/sdb1 /mnt/disque2
```

> Remplacez `/dev/sdb1` par l’identifiant correct de votre disque.

---

### 4. **Se déplacer vers le disque**

Une fois monté, vous pouvez y accéder comme à n’importe quel répertoire :

```bash
cd /mnt/disque2
```

---

### (Facultatif) 5. **Démonter le disque après utilisation**

Quand vous avez fini :

```bash
sudo umount /mnt/disque2
```

---

### ℹAstuce : Disques automontés

Parfois, si vous branchez un disque externe, il peut être monté automatiquement sous `/media/username/`. Utilisez :

```bash
cd /media/$USER/
```

et listez avec :

```bash
ls
```
pour voir s’il y a un dossier avec le nom du disque.

Si tu veux que le disque soit monté automatiquement au démarrage, je peux aussi t’expliquer comment éditer `/etc/fstab`.

---
---

## 2 - Atteindre un dossier partagé via Samba (SMB) en ligne de commande sous Linux

Deux façons principales :

## A. **Monter un dossier Samba avec `mount` (temporaire)**

### Étapes :

### ➊ Créer un point de montage

```bash
sudo mkdir -p /mnt/partage
```

### ➋ Monter le partage Samba

```bash
sudo mount -t cifs //IP_du_serveur/nom_partage /mnt/partage -o username=TON_UTILISATEUR,password=TON_MOTDEPASSE
```

 Exemple :

```bash
sudo mount -t cifs //192.168.1.10/backup /mnt/partage -o username=admin,password=secret
```

> Tu peux aussi ajouter `domain=DOMAINE` ou `vers=3.0` si nécessaire :

```bash
-o username=admin,password=secret,domain=WORKGROUP,vers=3.0
```

## B. **Naviguer sans monter : utiliser `smbclient` (mode FTP)**

Si tu veux **parcourir** ou **copier** des fichiers sans monter le partage, utilise :

```bash
smbclient //IP/partage -U utilisateur
```

Exemple :

```bash
smbclient //192.168.1.10/backup -U admin
```

Tu entres ton mot de passe, puis tu obtiens une invite `smb:` comme dans un client FTP.

### Commandes utiles :

```bash
ls                # liste les fichiers
cd dossier        # change de dossier
get fichier       # télécharge un fichier
put fichier       # envoie un fichier
```

---

### Option : Montage permanent (dans `/etc/fstab`)

Si tu veux que le partage Samba soit monté **automatiquement au démarrage**, tu peux l’ajouter à ton fichier `/etc/fstab`. Je peux t’expliquer comment si tu veux.

---

### Paquets requis

Si tu as une erreur du genre "cifs: command not found" :

```bash
sudo apt install cifs-utils smbclient
```

---

Souhaites-tu :

* un **montage automatique au démarrage** ?
* accéder à un partage **avec un nom d’utilisateur invité ou sans mot de passe** ?

  ---
  ---

##  Pour **copier un répertoire depuis un partage Samba (SMB)** vers un répertoire local en ligne de commande, tu peux utiliser deux méthodes efficaces selon ton besoin :



### **Méthode 1 : Monter le partage Samba + `cp` ou `rsync`**

### 🔧 Étapes :

### ➊ Monter le partage Samba temporairement

```bash
sudo mkdir -p /mnt/partage
sudo mount -t cifs //IP_SAMBA/NOM_PARTAGE /mnt/partage -o username=UTILISATEUR,password=MOTDEPASSE
```

Exemple :

```bash
sudo mount -t cifs //192.168.1.100/backup /mnt/partage -o username=admin,password=secret
```

---

### ➋ Copier le dossier avec `cp` ou `rsync`

#### Avec `cp` :

```bash
cp -r /mnt/partage/nom_dossier /chemin/local/
```

#### Avec `rsync` (plus sûr, et affiche la progression) :

```bash
rsync -av /mnt/partage/nom_dossier/ /chemin/local/nom_dossier/
```

---

### ➌ Démonter ensuite (facultatif) :

```bash
sudo umount /mnt/partage
```

---

### **Méthode 2 : Utiliser `smbclient` comme un client FTP**

Si tu **ne veux pas monter** le partage, tu peux copier avec `smbclient` :

### ➊ Se connecter :

```bash
smbclient //192.168.1.100/backup -U admin
```

### ➋ Une fois connecté :

```bash
smb: \> recurse ON
smb: \> prompt OFF
smb: \> lcd /chemin/local
smb: \> cd nom_dossier
smb: \> mget *
```

Cela va **télécharger tous les fichiers du dossier distant** vers le dossier local courant (`lcd`).

---

### Paquets requis :

Assure-toi d’avoir ces outils installés :

```bash
sudo apt install cifs-utils smbclient rsync
```

---

Souhaites-tu faire cela **automatiquement via un script**, ou avec **mot de passe enregistré de façon sécurisée** (sans le taper à chaque fois) ? Je peux t’aider à automatiser ça proprement si besoin.

---
---

## **copier tous les répertoires d’un partage Samba vers un répertoire local**, la méthode la plus robuste et simple consiste à **monter le partage Samba localement**, puis utiliser `rsync` ou `cp` pour tout copier.

---

### **Méthode recommandée : montage CIFS + rsync**

### 1. **Créer un point de montage**

```bash
sudo mkdir -p /mnt/samba_partage
```

---

### 2. **Monter le partage Samba**

Remplace `IP_SAMBA`, `PARTAGE`, `utilisateur`, `motdepasse` selon ton cas :

```bash
sudo mount -t cifs //IP_SAMBA/PARTAGE /mnt/samba_partage -o username=utilisateur,password=motdepasse
```

Exemple :

```bash
sudo mount -t cifs //192.168.1.100/backup /mnt/samba_partage -o username=admin,password=secret
```

---

### 3. **Copier tous les répertoires dans un dossier local**

Par exemple, pour copier dans `/home/user/sauvegarde` :

```bash
mkdir -p ~/sauvegarde
rsync -av /mnt/samba_partage/ ~/sauvegarde/
```

Explication :

* `-a` : copie récursive avec préservation des attributs
* `-v` : mode verbeux (affiche ce qui est copié)
* `/mnt/samba_partage/` avec le `/` final : copie **le contenu** du dossier, pas le dossier lui-même

---

### 4. **(Optionnel) Démonter le partage après copie**

```bash
sudo umount /mnt/samba_partage
```

---

### Alternative : copier sans montage via `smbclient`

```bash
smbclient //192.168.1.100/backup -U admin
```

Puis dans l’invite `smb: \>` :

```bash
recurse ON
prompt OFF
lcd /chemin/local
mget *
```

Mais cette méthode :

* est **moins fiable** pour des dossiers volumineux ou complexes
* ne préserve **pas les dates, les droits, ni les liens symboliques**

---

## 🛡️ Sécurité (éviter d’exposer le mot de passe)

Tu peux stocker les identifiants dans un fichier :

### `/etc/samba/credentials.txt` :

```
username=admin
password=secret
```

Puis monter avec :

```bash
sudo mount -t cifs //192.168.1.100/backup /mnt/samba_partage -o credentials=/etc/samba/credentials.txt
```

---

Souhaites-tu automatiser cette copie (ex. via script ou cron) ? Je peux t’aider à le faire proprement.

---
---

Parfait ! Voici **comment automatiser la copie de tous les répertoires Samba vers un dossier local**, avec **montage, sauvegarde et démontage**, le tout dans un **script bash** exécutable (et utilisable via `cron` si tu veux que ça se fasse régulièrement).

---

## ✅ 1. Créer un fichier d'identifiants sécurisé

### 🔒 `/etc/samba/creds_backup` :

```ini
username=TON_UTILISATEUR
password=TON_MOT_DE_PASSE
```

### ⚠️ Sécuriser les permissions :

```bash
sudo chmod 600 /etc/samba/creds_backup
```

---

## ✅ 2. Script automatique de sauvegarde Samba

### 📄 Crée un fichier `sauvegarde_samba.sh` :

```bash
nano ~/sauvegarde_samba.sh
```

### ✏️ Colle ceci :

```bash
#!/bin/bash

# Configuration
PARTAGE="//192.168.1.100/backup"  # Adresse du partage Samba
POINT_MONTAGE="/mnt/samba_partage"
DOSSIER_LOCAL="/home/ton_utilisateur/sauvegarde"
FICHIER_CREDS="/etc/samba/creds_backup"

# Créer le point de montage si nécessaire
sudo mkdir -p "$POINT_MONTAGE"

# Monter le partage Samba
sudo mount -t cifs "$PARTAGE" "$POINT_MONTAGE" -o credentials="$FICHIER_CREDS",vers=3.0

# Vérifier si le montage a réussi
if mountpoint -q "$POINT_MONTAGE"; then
    echo "Montage réussi. Lancement de la sauvegarde..."
    mkdir -p "$DOSSIER_LOCAL"
    rsync -av --delete "$POINT_MONTAGE/" "$DOSSIER_LOCAL/"
    echo "Sauvegarde terminée."
    # Démonter le partage
    sudo umount "$POINT_MONTAGE"
else
    echo "Erreur : le montage a échoué."
    exit 1
fi
```

> ⚠️ Remplace `192.168.1.100`, `backup`, `ton_utilisateur` selon ton cas.

---

### ✅ 3. Rendre le script exécutable :

```bash
chmod +x ~/sauvegarde_samba.sh
```

---

## ✅ 4. (Optionnel) Exécuter automatiquement avec `cron`

### Éditer le crontab :

```bash
crontab -e
```

### Ajouter cette ligne (ex. tous les jours à 2h du matin) :

```bash
0 2 * * * /home/ton_utilisateur/sauvegarde_samba.sh >> /home/ton_utilisateur/samba_backup.log 2>&1
```

---

## ✅ Résultat :

* Sauvegarde automatique quotidienne
* Dossier synchronisé localement
* Journal dans `samba_backup.log`
* Pas de mot de passe tapé en clair

---

Souhaites-tu que le script fasse aussi des **sauvegardes versionnées** (garder une copie par date) ou une **notification email en cas d’erreur** ?

---
---

Parfait ! Voici une version **améliorée du script** avec :

---

### ✅ **Sauvegardes versionnées (par date)**

### ✅ **Journalisation complète**

### ✅ **Envoi d’un e-mail en cas d’échec** (facultatif, mais prêt à l’emploi)

---

## 🧠 Principe :

Chaque sauvegarde est stockée dans un sous-dossier horodaté comme `/home/ton_user/sauvegarde/2025-05-22_02-00`.

---

## 📝 SCRIPT COMPLET : `sauvegarde_samba_versionnee.sh`

```bash
#!/bin/bash

# CONFIGURATION
PARTAGE="//192.168.1.100/backup"
POINT_MONTAGE="/mnt/samba_partage"
DESTINATION_BASE="/home/ton_user/sauvegarde"
FICHIER_CREDS="/etc/samba/creds_backup"
VERS_SAMBA="3.0"  # Modifier si besoin
EMAIL="votre@email.com"  # Facultatif : adresse pour les alertes

# DATE pour nommage du dossier
DATE=$(date +"%Y-%m-%d_%H-%M")
DESTINATION="$DESTINATION_BASE/$DATE"
LOGFILE="$DESTINATION_BASE/rsync_log_$DATE.txt"

# Créer les dossiers nécessaires
sudo mkdir -p "$POINT_MONTAGE"
mkdir -p "$DESTINATION_BASE"

# Monter le partage
sudo mount -t cifs "$PARTAGE" "$POINT_MONTAGE" -o credentials="$FICHIER_CREDS",vers=$VERS_SAMBA

# Vérifier si montage réussi
if mountpoint -q "$POINT_MONTAGE"; then
    echo "[$DATE] Montage réussi. Début de la sauvegarde..." | tee -a "$LOGFILE"
    mkdir -p "$DESTINATION"
    rsync -av --delete "$POINT_MONTAGE/" "$DESTINATION/" >> "$LOGFILE" 2>&1

    if [ $? -eq 0 ]; then
        echo "[$DATE] Sauvegarde terminée avec succès." | tee -a "$LOGFILE"
    else
        echo "[$DATE] ⚠️ Erreur pendant la sauvegarde. Voir log." | tee -a "$LOGFILE"
        echo "Erreur dans la sauvegarde Samba - voir $LOGFILE" | mail -s "❌ Sauvegarde Samba échouée" "$EMAIL" < "$LOGFILE"
    fi

    # Démonter le partage
    sudo umount "$POINT_MONTAGE"
else
    echo "[$DATE] ❌ Erreur : montage échoué." | tee -a "$LOGFILE"
    echo "Montage Samba échoué - voir $LOGFILE" | mail -s "❌ Montage Samba échoué" "$EMAIL" < "$LOGFILE"
    exit 1
fi
```

---

## ✅ 1. Rendre le script exécutable

```bash
chmod +x ~/sauvegarde_samba_versionnee.sh
```

---

## ✅ 2. Automatiser avec `cron`

```bash
crontab -e
```

Ajoute cette ligne (sauvegarde tous les jours à 2h du matin) :

```bash
0 2 * * * /home/ton_user/sauvegarde_samba_versionnee.sh
```

---

## ✅ 3. Facultatif : Configurer l’envoi de mails

Installe un utilitaire de mail simple comme `mailutils` :

```bash
sudo apt install mailutils
```

Et configure `/etc/ssmtp/ssmtp.conf` ou `msmtp` selon ce que tu préfères.

Sinon, retire simplement les lignes `mail -s ...` si tu ne veux pas de mail.

---

## 🧹 BONUS : Nettoyage automatique (ex: garder 7 derniers jours)

Ajoute à ton script :

```bash
# Supprimer les sauvegardes de plus de 7 jours
find "$DESTINATION_BASE" -maxdepth 1 -type d -name "20*" -mtime +7 -exec rm -rf {} \;
```

Souhaites-tu que je t’aide à **tester ce script**, ou à **l’adapter pour sauvegarder plusieurs partages Samba** ?

## Avec MacOS

Pour monter un répertoire **Samba (SMB)** en ligne de commande (**CLI**) sous **macOS**, tu peux utiliser la commande `mount_smbfs`.

Voici les étapes détaillées :

---

### 🔧 **1. Syntaxe de base**

```bash
mount_smbfs //[user[:password]@]server/share /chemin/local
```

---

### 📌 **2. Exemple concret**

Supposons que :

* Serveur : `192.168.1.100`
* Partage : `partage`
* Utilisateur : `john`
* Mot de passe : `secret123`
* Point de montage local : `/Volumes/partage`

#### Étape 1 : Créer le dossier local pour le montage

```bash
mkdir -p /Volumes/partage
```

#### Étape 2 : Monter le partage Samba

```bash
mount_smbfs //john@192.168.1.100/partage /Volumes/partage
```

> macOS te demandera le mot de passe si tu ne le fournis pas directement dans l'URL.

---

### ⚠️ **Remarques de sécurité**

* Évite de mettre le mot de passe en clair dans la commande pour des raisons de sécurité.
* Pour une utilisation automatisée, tu peux utiliser un fichier d’identifiants sécurisé avec `keychain`, ou un système de montages auto (`/etc/auto_master` + `autofs`).

---

### ✅ **Vérification**

Après le montage, tu peux vérifier avec :

```bash
df -h
```

ou

```bash
mount
```

---

### 🛑 **Démonter le partage**

```bash
umount /Volumes/partage
```

---

Si tu veux que je t’aide à créer un montage automatique au démarrage avec `autofs`, je peux te guider là-dessus aussi.


