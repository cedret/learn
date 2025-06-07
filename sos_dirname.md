sos_dirname.sh

Parfait ! Voici comment utiliser `mkdir -p "$(dirname "$fichier")"` dans un script pour **s’assurer que le chemin du fichier existe** avant d’écrire dedans.

---

### 🧱 Contexte : tu veux écrire dans un fichier à un chemin donné

Disons que tu veux écrire dans ce fichier :

```bash
fichier="/home/user/logs/archives/2025-S23/log.txt"
```

Avant d’écrire, tu dois t’assurer que **tout le chemin existe** (`/home/user/logs/archives/2025-S23`), sinon l’écriture échouera.

---

### ✅ Solution robuste avec `mkdir -p` et `dirname`

```bash
mkdir -p "$(dirname "$fichier")"
echo "Exemple de contenu" > "$fichier"
```

---

### 🔍 Explication :

* `dirname "$fichier"` retourne le **chemin du dossier parent** du fichier, par exemple :

  ```bash
  dirname "/home/user/logs/archives/2025-S23/log.txt"
  # → /home/user/logs/archives/2025-S23
  ```

* `mkdir -p` crée ce dossier (et tous ses parents si besoin) **sans erreur s’il existe déjà**.

---

### 🧪 Exemple complet dans un script :

```bash
#!/bin/bash

fichier="$HOME/logs/archives/$(date +%Y-S%V)/rapport.log"

# Créer les dossiers nécessaires
mkdir -p "$(dirname "$fichier")"

# Écrire dans le fichier
echo "📄 Rapport généré le $(date)" >> "$fichier"
```

---

### 📦 Résultat :

* Le script crée automatiquement un fichier comme :

  ```
  ~/logs/archives/2025-S23/rapport.log
  ```
* Il ajoute une ligne avec la date, et crée tout le chemin même s’il n’existait pas.

---

Souhaites-tu que je t’intègre cette logique dans ton **script de copie NFS avec logging** ?
