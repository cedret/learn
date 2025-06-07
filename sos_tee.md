sos_tee.sh

Oui ! Tu peux utiliser `tee` dans ton script pour **afficher les messages à l’écran tout en les enregistrant dans un fichier** (comme un **journal/log**). C’est très utile pour le **débogage**, les **rapports**, ou le suivi des opérations.

---

### 🧰 Comment utiliser `tee` dans un script Bash

Il existe deux grandes manières :

---

## ✅ 1. **Logger tout le script avec `tee`**

Encapsule l’ensemble du script dans un bloc `{ ...; }` et redirige sa sortie vers `tee`.

### Exemple :

```bash
#!/bin/bash

LOGFILE="copie.log"

{
  echo "🕒 Début du script : $(date)"

  echo "Liste des fichiers dans \$HOME :"
  ls "$HOME"

  echo "✅ Fin de l'opération."
} | tee "$LOGFILE"
```

* Cela **affiche tout dans le terminal** ET **écrit tout dans `copie.log`**

---

## ✅ 2. **Logger uniquement certaines commandes**

Tu peux utiliser `tee` pour certaines commandes clés :

```bash
echo "📤 Copie de $src vers $dest" | tee -a "$LOGFILE"
rsync -a --progress "$src/" "$dest/" | tee -a "$LOGFILE"
```

* `-a` signifie **append** (ajouter à la fin du fichier sans l’écraser).

---

## 🔄 Bonus : capturer `stdout` et `stderr`

Si tu veux **capturer les erreurs aussi**, redirige `stderr` avec `2>&1` :

```bash
rsync -a --progress "$src/" "$dest/" 2>&1 | tee -a "$LOGFILE"
```

---

### 💡 Astuce : générer un log horodaté automatiquement

```bash
LOGFILE="log_$(date +%Y-%m-%d_%H-%M-%S).log"
```

---

### 🧪 Exemple d'intégration dans ton script :

Dans ton script de copie avec `rsync`, ajoute au début :

```bash
LOGFILE="$HOME/copie_nfs_$(date +%F_%H-%M).log"
exec > >(tee -a "$LOGFILE") 2>&1
```

Cela **redirige automatiquement tout le script vers `tee`** : plus besoin de le mettre à chaque ligne.

---

Souhaites-tu que je t’intègre `tee` dans **ton script complet de copie NFS avec sélection multiple et confirmation** ?

Excellente idée pour garder tes logs **bien organisés** ! Pour archiver les logs avec le **numéro de la semaine** et l’**année**, tu peux utiliser la commande `date` avec des options spécifiques.

---

### ✅ Format de nom de fichier avec semaine et année

Utilise :

```bash
date +"%Y-S%V"
```

* `%Y` : année (ex. `2025`)
* `%V` : numéro de la semaine (ex. `23` → 23e semaine)
* Résultat : `2025-S23`

---

### 🧱 Exemple de nom de fichier de log

```bash
LOGFILE="$HOME/logs/copie_$(date +%Y-S%V).log"
```

Cela créera des fichiers comme :

```
copie_2025-S23.log
copie_2025-S24.log
...
```

Tu peux créer un dossier `logs` s’il n’existe pas :

```bash
mkdir -p "$HOME/logs"
```

---

### 🔄 Bonus : rotation automatique (une log par semaine)

Avec ce format :

* **1 log par semaine** est créé.
* Si tu relances le script plusieurs fois dans la même semaine, tous les logs seront **ajoutés au même fichier**.

Pour éviter ça, tu peux aussi ajouter une date/heure pour avoir **1 fichier unique par exécution** :

```bash
LOGFILE="$HOME/logs/copie_$(date +%Y-S%V_%H-%M-%S).log"
```

---

### 💡 Intégration dans ton script Bash

Au début de ton script :

```bash
mkdir -p "$HOME/logs"
LOGFILE="$HOME/logs/copie_$(date +%Y-S%V).log"
exec > >(tee -a "$LOGFILE") 2>&1
```

Cela **enregistre tout ce qui s'affiche dans le terminal dans le fichier `copie_2025-SXX.log`**.

---

Souhaites-tu un système qui :

* **compresse automatiquement les logs des semaines précédentes** ?
* Ou une **suppression automatique des logs vieux de plusieurs semaines** ?



