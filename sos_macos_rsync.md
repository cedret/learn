sos_macos_rsync.md

Pour copier un répertoire vers un partage **SMB** tout en affichant la progression de la duplication en **ligne de commande** sous macOS, tu as plusieurs solutions.

### 🔧 **Solution 1 : Utiliser `rsync` avec un partage SMB monté**

La commande `rsync` est très populaire pour la duplication de fichiers, car elle offre une option pour afficher la progression de la copie.

#### Étapes :

1. **Monter le partage SMB** comme expliqué dans la méthode précédente (avec `mount_smbfs`).

   Exemple :

   ```bash
   mkdir -p /Volumes/partage
   mount_smbfs //john@192.168.1.100/partage /Volumes/partage
   ```

2. **Utiliser `rsync` pour copier le répertoire et afficher la progression**.

   La commande `rsync` a une option `--progress` qui permet de voir la progression de la copie. Par exemple, pour copier le répertoire `mon_dossier` vers le partage SMB monté :

   ```bash
   rsync -avh --progress /Users/john/Documents/mon_dossier/ /Volumes/partage/
   ```

   * `-a` : Archive (copie récursive et conserve les attributs des fichiers).
   * `-v` : Verbose (affiche des détails pendant l'exécution).
   * `-h` : Human-readable (affiche la taille des fichiers de manière lisible, par exemple `1K`, `2M`).
   * `--progress` : Affiche la progression de la copie de chaque fichier.

   **Exemple de sortie** :

   ```bash
   mon_dossier/file1.txt
       1,234,567 100%  234.56kB/s    0:00:05 (xfer#1, to-chk=0/10)
   mon_dossier/file2.txt
       1,234,567 100%  234.56kB/s    0:00:05 (xfer#2, to-chk=0/10)
   ```

   Cela te montrera la **progression** pour chaque fichier copié.

3. **Démonter le partage SMB après la copie** :

   ```bash
   umount /Volumes/partage
   ```

---

### 🔧 **Solution 2 : Utiliser `smbclient` avec un script pour afficher la progression**

Bien que `smbclient` ne propose pas directement d'option pour afficher la progression de la copie, tu peux créer un script qui affiche la progression en utilisant un compteur ou une estimation.

Voici un exemple simple de script avec `smbclient` qui montre une progression approximative en fonction du nombre de fichiers.

#### 1. **Script `smbclient` avec progression** :

```bash
#!/bin/bash

# Définir les variables
SOURCE_DIR="/Users/john/Documents/mon_dossier"
DEST_SHARE="//192.168.1.100/partage"
USER="john"
PASSWORD="ton_mot_de_passe"

# Nombre total de fichiers à copier
TOTAL_FILES=$(find "$SOURCE_DIR" -type f | wc -l)

# Compteur pour la progression
COUNTER=0

# Se connecter à smbclient et copier les fichiers
smbclient "$DEST_SHARE" -U "$USER"%"$PASSWORD" -c "prompt; recurse; mput $SOURCE_DIR/*"

# Boucle pour afficher la progression
for FILE in $(find "$SOURCE_DIR" -type f); do
  COUNTER=$((COUNTER+1))
  PROGRESS=$((COUNTER * 100 / TOTAL_FILES))
  echo -ne "Progression : $PROGRESS% ($COUNTER/$TOTAL_FILES fichiers)\r"
  sleep 0.1  # Attendre un peu pour ne pas surcharger le terminal
done

echo -e "\nCopie terminée."
```

* Ce script parcourt tous les fichiers du répertoire source (`mon_dossier`), en calculant la progression au fur et à mesure de la copie.
* Il utilise `find` pour obtenir le nombre de fichiers dans le répertoire local et affiche la progression en pourcentage.

### 📌 **Explication du script** :

* **find "\$SOURCE\_DIR" -type f** : Trouve tous les fichiers dans le répertoire source.
* **smbclient "\$DEST\_SHARE"** : Se connecte au partage SMB.
* **mput \$SOURCE\_DIR/**\* : Envoie tous les fichiers du répertoire local vers le partage.
* **Progression** : La variable `COUNTER` suit le nombre de fichiers copiés et affiche un pourcentage de progression.

---

### 🔧 **Solution 3 : Utiliser `rsync` sur SMB sans montage direct (via `smbclient` intégré)**

Tu peux aussi utiliser `rsync` avec `smbclient` sans monter le partage directement sur macOS. Voici comment procéder :

1. **Installer `rsync` avec le support SMB** (si nécessaire) en utilisant **Homebrew** :

   ```bash
   brew install rsync
   ```

2. **Utiliser `rsync` avec SMB via l'option `smb://`** :

   ```bash
   rsync -avh --progress /Users/john/Documents/mon_dossier/ smb://john@192.168.1.100/partage/
   ```

   Dans ce cas, `rsync` utilise le protocole SMB directement et te permet de voir la progression tout en copiant les fichiers. Cette méthode est un peu plus rare et dépend de la configuration d'**rsync**.

---

### 📌 **Résumé** :

1. **`rsync` avec SMB monté** :

   * `rsync -avh --progress /source /Volumes/partage/`
   * Affiche la progression fichier par fichier.

2. **Script `smbclient` avec progression** :

   * Utilise un script pour copier via `smbclient` et afficher une progression basée sur le nombre de fichiers.

3. **`rsync` avec SMB direct** (si `rsync` supporte SMB) :

   * `rsync -avh --progress /source smb://username@host/share/`
   * Une solution si tu n'as pas envie de monter le partage SMB.

---
---

Pour copier un répertoire local vers un répertoire partagé **SMB** via la ligne de commande sur **macOS**, tu peux utiliser la commande `cp` (pour les fichiers locaux) combinée avec l'accès SMB via `mount_smbfs`, ou utiliser un outil comme `smbclient` si tu préfères une approche plus directe sans monter le partage.

Voici deux méthodes possibles :

---

### 🔧 **Méthode 1 : Utiliser `mount_smbfs` pour monter le partage SMB puis copier**

#### 1. **Monter le partage SMB**

Tout d'abord, tu dois monter le partage SMB sur ton système local. Voici la syntaxe de base pour monter un partage SMB :

```bash
mount_smbfs //username:password@hostname_or_ip/share /chemin/local
```

Par exemple, si tu veux monter un partage `partage` sur le serveur `192.168.1.100` avec l'utilisateur `john` :

```bash
mkdir -p /Volumes/partage
mount_smbfs //john@192.168.1.100/partage /Volumes/partage
```

#### 2. **Copier le répertoire local**

Une fois que le partage SMB est monté, tu peux utiliser la commande `cp` pour copier le répertoire local vers le répertoire monté.

* Copier tout un répertoire avec son contenu :

  ```bash
  cp -R /chemin/du/répertoire/local /Volumes/partage/
  ```

Exemple :

```bash
cp -R /Users/john/Documents/mon_dossier /Volumes/partage/
```

Cela copiera le répertoire `mon_dossier` vers le partage SMB.

#### 3. **Démonter le partage SMB après la copie**

Une fois la copie terminée, tu peux démonter le partage SMB avec la commande suivante :

```bash
umount /Volumes/partage
```

---

### 🔧 **Méthode 2 : Utiliser `smbclient` pour copier sans monter le partage**

Si tu ne veux pas monter le partage SMB dans le système de fichiers mais simplement utiliser `smbclient` pour interagir avec le partage SMB, tu peux utiliser cette méthode.

#### 1. **Utiliser `smbclient` pour se connecter au partage SMB**

Tu peux utiliser `smbclient`, qui est un client SMB en ligne de commande, pour te connecter au partage SMB. La syntaxe est :

```bash
smbclient //hostname_or_ip/share -U username
```

Par exemple, si tu veux copier un fichier vers un partage SMB `partage` sur le serveur `192.168.1.100` avec l'utilisateur `john` :

```bash
smbclient //192.168.1.100/partage -U john
```

Tu seras invité à entrer le mot de passe de l'utilisateur.

#### 2. **Copier un fichier ou un répertoire local avec `smbclient`**

Une fois connecté, tu peux utiliser la commande `mput` pour copier plusieurs fichiers, ou `put` pour un fichier unique.

* Pour copier un répertoire, tu peux utiliser `mput` avec l'option `-R` pour la récursion :

```bash
smbclient //192.168.1.100/partage -U john -c "prompt; recurse; mput /chemin/du/répertoire/*"
```

Exemple complet :

```bash
smbclient //192.168.1.100/partage -U john -c "prompt; recurse; mput /Users/john/Documents/mon_dossier/*"
```

Cette commande va copier tout le contenu du répertoire `mon_dossier` vers le partage SMB.

#### 3. **Quitter `smbclient`**

Une fois la copie terminée, tu peux quitter `smbclient` en tapant :

```bash
exit
```

### 📌 **Résumé des commandes :**

| Commande                                             | Description                                                 |
| ---------------------------------------------------- | ----------------------------------------------------------- |
| `mount_smbfs //username@host/share /Volumes/partage` | Monter un partage SMB sur `/Volumes/partage`.               |
| `cp -R /chemin/du/répertoire /Volumes/partage/`      | Copier un répertoire local vers le partage SMB.             |
| `umount /Volumes/partage`                            | Démonter le partage SMB.                                    |
| `smbclient //hostname/share -U username`             | Se connecter à un partage SMB sans le monter.               |
| `mput /chemin/du/fichier/*`                          | Copier un répertoire ou plusieurs fichiers via `smbclient`. |

---
---