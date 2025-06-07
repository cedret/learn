sos_htop.md

### Pour vérifier la bande passante, l'occupation CPU et les processus d'un NAS en ligne de commande, voici quelques commandes que tu peux utiliser, en fonction de l'environnement du NAS (par exemple, Linux, FreeNAS, etc.) :

### 1. Vérifier la bande passante réseau

Pour mesurer la bande passante, tu peux utiliser plusieurs outils comme `iftop`, `nload`, ou `vnstat`. Voici comment procéder :

#### a. **`iftop` (interactif, temps réel)**

Cet outil affiche l'utilisation du réseau en temps réel.

```bash
sudo apt-get install iftop   # Sur Debian/Ubuntu
sudo yum install iftop       # Sur CentOS/RHEL
sudo dnf install iftop       # Sur Fedora

sudo iftop
```

Cela te donnera une vue en temps réel de l'utilisation de la bande passante par connexion réseau.

#### b. **`nload` (affichage graphique simple)**

Ce programme permet de visualiser la bande passante montante et descendante de manière graphique.

```bash
sudo apt-get install nload  # Sur Debian/Ubuntu
sudo yum install nload      # Sur CentOS/RHEL
sudo dnf install nload      # Sur Fedora

sudo nload
```

#### c. **`vnstat` (historique)**

`vnstat` est utile pour obtenir des informations sur l'historique de la bande passante.

```bash
sudo apt-get install vnstat
sudo vnstat
```

Tu peux également obtenir des rapports sur une période spécifique, par exemple sur les dernières heures :

```bash
vnstat -h
```

### 2. Vérifier l'occupation du CPU

#### a. **`top`**

La commande `top` donne une vue d'ensemble de l'utilisation des ressources, y compris le CPU, la mémoire et les processus.

```bash
top
```

Pour voir plus de détails sur l'utilisation du CPU et trier par l'utilisation du CPU :

```bash
top -o %CPU
```

#### b. **`htop`** (si installé)

`htop` est une version améliorée de `top` avec une interface plus conviviale et interactive.

```bash
sudo apt-get install htop  # Sur Debian/Ubuntu
sudo yum install htop      # Sur CentOS/RHEL
sudo dnf install htop      # Sur Fedora

htop
```

Tu peux aussi trier les processus en fonction de l'utilisation CPU ou de la mémoire directement dans `htop`.

### 3. Vérifier les processus en cours

#### a. **`ps` (affichage des processus)**

Si tu veux voir tous les processus en cours avec l'utilisation du CPU, tu peux utiliser `ps`.

```bash
ps aux --sort=-%cpu
```

Cela triera les processus par l'utilisation du CPU en ordre décroissant.

#### b. **`top` ou `htop` (interactif)**

Les deux commandes mentionnées ci-dessus sont aussi très pratiques pour voir les processus en cours en temps réel.

### 4. Utilisation de `sar` pour des statistiques historiques (si installé)

L'outil `sar` fournit des statistiques détaillées sur l'utilisation des ressources système, y compris le CPU, la mémoire, et la bande passante.

```bash
sudo apt-get install sysstat  # Sur Debian/Ubuntu
sudo yum install sysstat      # Sur CentOS/RHEL
sudo dnf install sysstat      # Sur Fedora

sar -u 1 3   # Affiche l'utilisation du CPU toutes les secondes (3 fois)
sar -n DEV 1 3  # Affiche la bande passante réseau
```

### Conclusion

Ces commandes te permettront d'obtenir des informations sur la bande passante, l'occupation CPU, et les processus de ton NAS. Il y a bien sûr d'autres outils, mais ceux-ci sont parmi les plus couramment utilisés. Si tu cherches quelque chose de plus spécifique ou détaillé, n’hésite pas à demander !




### `htop` **ne montre pas directement l’activité réseau**, car il est principalement orienté **CPU / mémoire / processus**.
Mais tu as plusieurs alternatives **pour surveiller l'activité réseau en temps réel** directement dans le terminal :

---

## 🧰 1. **`nethogs`** – L’équivalent de `htop` pour le réseau

### ✅ Avantages :

* Affiche l’usage réseau **par processus** (super pratique)
* Interface proche de `htop`

### 🔧 Installation :

```bash
sudo apt install nethogs      # Debian/Ubuntu
sudo dnf install nethogs      # Fedora
sudo pacman -S nethogs        # Arch
```

### ▶️ Lancement :

```bash
sudo nethogs
```

Tu verras une interface comme :

```
    PID  USER   DEV   SENT   RECEIVED  PROGRAM
   1234  alice  eth0  10.5 KB/s  5.3 KB/s  firefox
```

---

## 🧰 2. **`bmon`** – Visualisation réseau par interface

### ✅ Avantages :

* Donne un graphique temps réel (bande passante)
* Montre chaque interface réseau (eth0, wlan0, etc.)

### 🔧 Installation :

```bash
sudo apt install bmon
```

### ▶️ Lancement :

```bash
bmon
```

---

## 🧰 3. **`iftop`** – Activité réseau par connexion IP

### ✅ Avantages :

* Montre les connexions entrantes/sortantes
* Voir qui communique avec ta machine (et combien)

### 🔧 Installation :

```bash
sudo apt install iftop
```

### ▶️ Lancement :

```bash
sudo iftop
```

---

## 🧰 4. `htop` + `iostat` / `nload` en parallèle

Tu peux lancer :

```bash
htop
```

Dans une fenêtre, et à côté :

```bash
nload
```

ou

```bash
iostat -n
```

Mais ce sont des outils **combinés**, pas intégrés dans `htop`.

---

## 🧪 Résumé des meilleurs choix :

| Outil       | Vue par processus | Vue IP/port | Graphique | Remarques                |
| ----------- | ----------------- | ----------- | --------- | ------------------------ |
| **nethogs** | ✅ Oui             | ❌ Non       | ❌ Non     | Le plus proche de `htop` |
| **iftop**   | ❌ Non             | ✅ Oui       | ✅ Oui     | Voir trafic IP/port      |
| **bmon**    | ❌ Non             | ❌ Non       | ✅ Oui     | Vue globale interface    |
| **nload**   | ❌ Non             | ❌ Non       | ✅ Oui     | Très simple              |

---

Souhaites-tu que je t’écrive un script qui **lance automatiquement `htop` + `nethogs` dans des splits de terminal (tmux ou `gnome-terminal`)** ?

} | tee ~/audit_$(date +%Y-S%V).log

./audit_synology.sh | tee audit_synology_$(date +%Y-S%V).log

###  Exécuter **le script d’audit Synology à distance** via SSH depuis un autre poste (Linux ou macOS, ou même WSL sous Windows).

---

## ✅ 1. Exécution directe sans script local

Tu peux lancer **une commande ou un script en une seule ligne**, sans le transférer, comme ceci :

```bash
ssh admin@IP_DU_NAS 'bash -s' < audit_synology.sh | tee audit_$(date +%Y-S%V).log
```

* `ssh admin@IP_DU_NAS` : connexion distante
* `'bash -s'` : le NAS lit le script à exécuter depuis l'entrée standard
* `< audit_synology.sh` : ton script local est envoyé à distance
* `| tee ...` : tu gardes aussi une **copie du résultat localement**

---

## 🧱 2. Exemple complet

Supposons que ton script s'appelle `audit_synology.sh` sur ta machine locale.

Tu lances depuis ton terminal :

```bash
ssh admin@192.168.1.10 'bash -s' < audit_synology.sh | tee ~/logs/syno_audit_$(date +%Y-S%V).log
```

> 💡 Remplace `192.168.1.10` par l’IP réelle de ton NAS.

---

## 📦 3. Résultat

* Le **script s'exécute à distance** sur le NAS.
* Tu obtiens le **résultat affiché en direct**.
* Tu **conserves une copie** sur ta machine locale (`.log`).

---

## 🧪 Astuce : exécution régulière

Tu peux automatiser cette commande avec un **cron** ou un **script de supervision local**.

---

## 🔐 Si tu veux éviter de saisir le mot de passe SSH

Configure une **authentification par clé publique** :

1. Sur ta machine locale :

   ```bash
   ssh-keygen -t ed25519
   ssh-copy-id admin@192.168.1.10
   ```

2. Ensuite, la commande fonctionne **sans mot de passe** :

   ```bash
   ssh admin@192.168.1.10 'bash -s' < audit_synology.sh
   ```

---

Souhaites-tu :

* Une version **compressée** du log envoyé par mail ?
* Ou un script **local** qui audite plusieurs NAS en boucle ?

Pour éviter de taper les mots de passe à chaque NAS, utilise l’authentification par clé publique :

``ssh-copy-id admin@192.168.1.10``

### voici le **code complet** que tu peux copier-coller et exécuter toi-même dans un environnement Python (sur ta machine ou un serveur) :

Tu dois être connecté à ChatGPT pour exécuter du code Python ici.
Mais aucun souci — 

---

### ✅ Script Python – Audit multi-NAS + Rapport HTML

```python
from datetime import datetime
import os
import subprocess
from pathlib import Path
import html

# === Configuration ===
nas_list = [
    "admin@192.168.1.10",
    "admin@192.168.1.11",
    "admin@192.168.1.12"
]

script_local = "audit_synology.sh"
log_dir = Path.home() / "logs" / "nas_audits_html"
log_dir.mkdir(parents=True, exist_ok=True)

date_tag = datetime.now().strftime("%Y-S%V")
html_rows = []

# === Audit Each NAS ===
for nas in nas_list:
    ip = nas.split("@")[1]
    logfile = log_dir / f"audit_{ip}_{date_tag}.log"
    print(f"Auditing {nas}...")

    try:
        with open(logfile, "w") as logf:
            proc = subprocess.run(
                ["ssh", "-o", "ConnectTimeout=10", nas, "bash -s"],
                stdin=open(script_local),
                stdout=logf,
                stderr=subprocess.STDOUT,
                timeout=60
            )
        status = "✅"
    except Exception as e:
        with open(logfile, "w") as logf:
            logf.write(f"❌ Audit failed for {nas}\n{str(e)}\n")
        status = "❌"

    with open(logfile) as f:
        content = f.read()
        escaped_log = html.escape(content).replace("\n", "<br>")
        html_rows.append(f"<tr><td>{ip}</td><td>{status}</td><td><details><summary>Afficher</summary><pre>{escaped_log}</pre></details></td></tr>")

# === Generate HTML Report ===
html_report = f"""<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Rapport Audit Synology - {date_tag}</title>
    <style>
        body {{ font-family: sans-serif; }}
        table {{ border-collapse: collapse; width: 100%; }}
        th, td {{ border: 1px solid #ccc; padding: 8px; }}
        th {{ background-color: #f2f2f2; }}
        pre {{ white-space: pre-wrap; word-wrap: break-word; }}
        summary {{ cursor: pointer; font-weight: bold; }}
    </style>
</head>
<body>
    <h1>🧾 Rapport Audit Synology - {date_tag}</h1>
    <table>
        <thead>
            <tr>
                <th>Adresse IP</th>
                <th>Statut</th>
                <th>Log</th>
            </tr>
        </thead>
        <tbody>
            {''.join(html_rows)}
        </tbody>
    </table>
</body>
</html>
"""

report_path = log_dir / f"rapport_synology_{date_tag}.html"
with open(report_path, "w", encoding="utf-8") as f:
    f.write(html_report)

print(f"\n✅ Rapport HTML généré : {report_path}")
```

---

### 📦 Instructions :

1. Place ce script Python dans le même dossier que ton `audit_synology.sh`
2. Assure-toi que Python 3 est installé (`python3 --version`)
3. Exécute-le :

```bash
python3 audit_nas_multi.py
```

Cela générera un rapport HTML dans :

```
~/logs/nas_audits_html/rapport_synology_2025-S23.html
```

---

Souhaites-tu que je t’aide à :

* Envoyer le rapport par email ?
* Ajouter un export CSV ?
* Héberger automatiquement le rapport dans un serveur web local ?

### Voici comment **héberger le rapport HTML localement** à l’aide d’un petit **serveur web Python**. C’est idéal pour accéder à ton rapport depuis ton navigateur ou un autre poste sur le réseau.

---

## ✅ Étapes pour héberger localement ton rapport HTML

### 1. 📁 Va dans le dossier contenant les rapports :

```bash
cd ~/logs/nas_audits_html
```

### 2. 🚀 Lance un serveur HTTP avec Python :

```bash
python3 -m http.server 8080
```

* Cela sert **tout le contenu du dossier courant** à l'adresse :

  ```
  http://localhost:8080/
  ```

* Pour y accéder depuis un autre appareil sur ton réseau, utilise l’**adresse IP locale** de ta machine :

  ```
  http://192.168.x.x:8080/
  ```

> Remplace `192.168.x.x` par l’adresse IP de ton PC (`ip a` ou `ipconfig` pour la trouver).

---

## 🛡️ Astuces sécurité :

* Pour un **NAS ou serveur dédié**, tu peux restreindre l’accès avec un pare-feu (ufw, iptables).
* N’utilise pas ce serveur HTTP en production sans protection : c’est juste pour un usage local ou temporaire.

---

## 🛠️ Bonus : script de lancement automatique

Voici un petit script `serveur_rapport.sh` pour lancer ton serveur :

```bash
#!/bin/bash
cd ~/logs/nas_audits_html || exit 1
echo "🌐 Serveur de rapport lancé sur http://localhost:8080/"
python3 -m http.server 8080
```

Rends-le exécutable :

```bash
chmod +x serveur_rapport.sh
```

Et lance-le :

```bash
./serveur_rapport.sh
```

---

Souhaites-tu que je t’intègre ce lancement automatique **dans le script Python** à la fin (pour lancer le serveur après avoir généré le rapport) ?

### Voici le **code Python complet** que tu peux copier-coller et exécuter localement.

Tu dois être connecté à ChatGPT pour utiliser l’exécution de code Python ici.
Mais pas de souci ! 

---

### ✅ Script Python : audit multi-NAS + génération HTML + serveur local

```python
from datetime import datetime
import os
import subprocess
from pathlib import Path
import html
import http.server
import socketserver
import threading

# === Configuration ===
nas_list = [
    "admin@192.168.1.10",
    "admin@192.168.1.11",
    "admin@192.168.1.12"
]

script_local = "audit_synology.sh"
log_dir = Path.home() / "logs" / "nas_audits_html"
log_dir.mkdir(parents=True, exist_ok=True)

date_tag = datetime.now().strftime("%Y-S%V")
html_rows = []

# === Audit Each NAS ===
for nas in nas_list:
    ip = nas.split("@")[1]
    logfile = log_dir / f"audit_{ip}_{date_tag}.log"
    print(f"Auditing {nas}...")

    try:
        with open(logfile, "w") as logf:
            proc = subprocess.run(
                ["ssh", "-o", "ConnectTimeout=10", nas, "bash -s"],
                stdin=open(script_local),
                stdout=logf,
                stderr=subprocess.STDOUT,
                timeout=60
            )
        status = "✅"
    except Exception as e:
        with open(logfile, "w") as logf:
            logf.write(f"❌ Audit failed for {nas}\n{str(e)}\n")
        status = "❌"

    with open(logfile) as f:
        content = f.read()
        escaped_log = html.escape(content).replace("\n", "<br>")
        html_rows.append(f"<tr><td>{ip}</td><td>{status}</td><td><details><summary>Afficher</summary><pre>{escaped_log}</pre></details></td></tr>")

# === Generate HTML Report ===
html_report = f"""<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Rapport Audit Synology - {date_tag}</title>
    <style>
        body {{ font-family: sans-serif; }}
        table {{ border-collapse: collapse; width: 100%; }}
        th, td {{ border: 1px solid #ccc; padding: 8px; }}
        th {{ background-color: #f2f2f2; }}
        pre {{ white-space: pre-wrap; word-wrap: break-word; }}
        summary {{ cursor: pointer; font-weight: bold; }}
    </style>
</head>
<body>
    <h1>🧾 Rapport Audit Synology - {date_tag}</h1>
    <table>
        <thead>
            <tr>
                <th>Adresse IP</th>
                <th>Statut</th>
                <th>Log</th>
            </tr>
        </thead>
        <tbody>
            {''.join(html_rows)}
        </tbody>
    </table>
</body>
</html>
"""

report_path = log_dir / f"rapport_synology_{date_tag}.html"
with open(report_path, "w", encoding="utf-8") as f:
    f.write(html_report)

# === Start local web server ===
class ServerThread(threading.Thread):
    def run(self):
        os.chdir(log_dir)
        handler = http.server.SimpleHTTPRequestHandler
        with socketserver.TCPServer(("", 8080), handler) as httpd:
            print(f"\n🌐 Rapport disponible sur http://localhost:8080/{report_path.name}")
            print("🛑 Appuie sur Ctrl+C pour arrêter le serveur.")
            httpd.serve_forever()

# Lancer le serveur dans un thread séparé
thread = ServerThread()
thread.start()
```

---

### ▶️ Pour exécuter :

1. Sauvegarde ce code dans `audit_nas_web.py`
2. Assure-toi d’avoir ton `audit_synology.sh` prêt
3. Lance avec :

   ```bash
   python3 audit_nas_web.py
   ```
4. Va dans ton navigateur :

   ```
   http://localhost:8080/
   ```

Tu verras le rapport HTML avec les résultats de chaque NAS audité.

Souhaites-tu aussi que le serveur s’arrête automatiquement après un délai, ou qu’il soit protégé par mot de passe ?

### Pour avoir un **retour en temps réel de l’audit toutes les 10 secondes**, tu as plusieurs options selon ton environnement. Voici les plus efficaces :

---

## ✅ 1. **Boucle `watch` (simple, terminal)**

Utilise la commande `watch` pour relancer ton script à intervalle régulier :

```bash
watch -n 10 ./audit_synology.sh
```

* Exécute ton script toutes les **10 secondes**
* Affiche directement le résultat dans le terminal
* ⛔ Pas idéal pour un audit complet (gourmand), mais parfait pour surveiller une info

---

## ✅ 2. **Boucle Bash avec `clear` + `sleep` (plus flexible)**

Exemple :

```bash
#!/bin/bash

while true; do
    clear
    echo "🔄 Audit à $(date)"
    ./audit_synology.sh
    sleep 10
done
```

* Met à jour le terminal toutes les 10 s
* Tu peux filtrer/simplifier le script pour ne pas surcharger le NAS

---

## ✅ 3. **Streaming temps réel avec `ssh` + `tail -f` sur log**

Si le script écrit dans un fichier log sur le NAS, tu peux faire :

```bash
ssh admin@192.168.1.10 'tail -f /volume1/logs/audit.log'
```

---

## ✅ 4. **Script Python avec affichage temps réel (console)**

Tu peux exécuter le script Python comme un **stream de logs** :

```python
import subprocess
import time

while True:
    print("🔄 Audit à", time.strftime("%H:%M:%S"))
    subprocess.run(["ssh", "admin@192.168.1.10", "bash -s"], stdin=open("audit_synology.sh"))
    print("\n--- Prochain audit dans 10s ---\n")
    time.sleep(10)
```

---

## ✅ 5. **Retour temps réel dans une fenêtre Zenity (auto-refresh)**

Exemple :

```bash
while true; do
    ssh admin@192.168.1.10 'bash -s' < audit_synology.sh > /tmp/audit.log
    zenity --width=800 --height=500 --text-info \
        --title="Audit NAS (Actualisé : $(date +%H:%M:%S))" \
        --filename="/tmp/audit.log" \
        --timeout=10
done
```

* Affiche le log
* Se ferme au bout de 10 secondes
* Boucle pour réafficher une version à jour

---

Souhaites-tu une version avec :

* ✅ Fenêtre interactive + boutons ?
* ✅ Journalisation dans un fichier à chaque cycle ?
* ✅ Rafraîchissement auto du rapport HTML dans le navigateur ?

### Parfait ! Pour avoir un **rafraîchissement automatique du rapport HTML dans le navigateur**, il suffit d’ajouter une **balise meta de rafraîchissement** dans le HTML.

---

## ✅ 1. Ajout dans le rapport HTML

Modifie ton rapport pour qu’il se rafraîchisse toutes les 10 secondes :

### 🔁 Exemple à insérer dans `<head>` :

```html
<meta http-equiv="refresh" content="10">
```

### 🔧 Exemple complet de `<head>` :

```html
<head>
    <meta charset="UTF-8">
    <title>Rapport Audit Synology - 2025-S23</title>
    <meta http-equiv="refresh" content="10">
    <style>
        body { font-family: sans-serif; }
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #ccc; padding: 8px; }
        th { background-color: #f2f2f2; }
        pre { white-space: pre-wrap; word-wrap: break-word; }
        summary { cursor: pointer; font-weight: bold; }
    </style>
</head>
```

---

## ✅ 2. Afficher automatiquement dans le navigateur

Tu peux ouvrir automatiquement le rapport avec cette commande Bash (Linux) :

```bash
xdg-open ~/logs/nas_audits_html/rapport_synology_$(date +%Y-S%V).html
```

Sur macOS :

```bash
open ~/logs/nas_audits_html/rapport_synology_$(date +%Y-S%V).html
```

---

## ✅ 3. Bonus Python (ouvrir après génération)

Dans ton script Python, ajoute à la fin :

```python
import webbrowser
webbrowser.open(f"http://localhost:8080/{report_path.name}")
```

---

### Résultat :

* Le rapport HTML est **mis à jour toutes les 10 secondes**
* Le navigateur recharge automatiquement
* Tu n’as **rien à faire manuellement**

---

Souhaites-tu que le rapport soit :

* 🕐 Rafraîchi seulement **si son contenu a changé** ?
* 💾 Archivé à chaque cycle (historique par semaine/jour) ?
* 📊 Converti en tableau dynamique interactif (tri/filtre) avec JavaScript ?
