sos_snmp.md

- https://www.tech2tech.fr/monitoring-5-supervision-dun-nas-synology-via-snmp/
- https://shape.host/resources/installation-de-librenms-optimisation-de-la-surveillance-reseau-sous-ubuntu-22-04-avec-nginx

vérification cpu par snmp
``snmpwalk -v2c -c public 192.168.1.100 .1.3.6.1.4.1.2021.11``


## A-Surveiller un NAS via **SNMP** de manière **légère et efficace** depuis un système Linux

Plusieurs outils en ligne de commande ou avec interface minimale peuvent convenir. Voici une sélection des **outils légers** les plus couramment utilisés pour ce type de tâche :

---

### ✅ **1. `snmpwalk` / `snmpget` (paquet `net-snmp`) — ultra léger en CLI**

**Utilisation :**

* Idéal pour **interroger ponctuellement** un NAS via SNMP (CPU, mémoire, espace disque, trafic réseau...).
* Très utile pour scripts ou diagnostics rapides.

**Installation :**

```bash
sudo apt install snmp
```

**Exemples :**

```bash
snmpwalk -v2c -c public 192.168.1.100
snmpget -v2c -c public 192.168.1.100 1.3.6.1.2.1.1.5.0  # Nom de l'hôte
```

> 🔍 Tu peux obtenir les OIDs spécifiques à ton NAS via `snmpwalk` puis les filtrer (ex. `grep hrStorage` pour le stockage).

---

### ✅ **2. `snmpstat` — affichage simplifié des stats réseau SNMP**

**Usage** : Affiche **en continu** des statistiques réseau (comme `netstat`, mais via SNMP).
**Installation** :

```bash
sudo apt install snmpstat
```

**Exemple :**

```bash
snmpstat -v2c -c public -h 192.168.1.100
```

---

### ✅ **3. `Cacti` — interface web légère de monitoring SNMP**

* Plus visuel qu’en ligne de commande, mais reste **relativement léger**.
* Excellente solution si tu veux **des graphes** (stockage, CPU, charge, température) sans la lourdeur de Zabbix ou Nagios.

**Installation (Debian/Ubuntu) :**

```bash
sudo apt install cacti
```

> 💡 Il faut un serveur web (Apache ou Nginx), PHP et une base de données MySQL/MariaDB.

---

### ✅ **4. `smnpd` + `snmptrapd` — pour collecter des traps (alertes)**

* Si tu veux recevoir des alertes SNMP (e.g., température, panne de disque), configure `snmptrapd`.
* Léger mais demande un peu de configuration.

---

### ✅ **5. `LibreNMS` (plus complet mais plus lourd)**

* Si tu veux quelque chose de plus robuste qu’un simple `snmpwalk`, sans aller jusqu’à Zabbix, tu peux envisager [LibreNMS](https://www.librenms.org/).
* Interface Web, découverte automatique, graphes.
* **Plus lourd** que les outils ci-dessus mais toujours plus simple que Nagios/Zabbix.

---

### Bonus : Pour des **scripts personnalisés**

Si tu veux créer un **script Bash léger** pour surveiller ton NAS via SNMP :

```bash
#!/bin/bash
NAS_IP="192.168.1.100"
COMMUNITY="public"

echo "Nom du NAS :"
snmpget -v2c -c $COMMUNITY $NAS_IP 1.3.6.1.2.1.1.5.0

echo "Utilisation CPU :"
snmpwalk -v2c -c $COMMUNITY $NAS_IP | grep cpu
```

---

### Résumé rapide :

| Outil       | Type   | Avantage                 | Légèreté        |
| ----------- | ------ | ------------------------ | --------------- |
| `snmpwalk`  | CLI    | Simple, scriptable       | 🟩 Très léger   |
| `snmpstat`  | CLI    | Monitoring en continu    | 🟩 Très léger   |
| `Cacti`     | Web    | Graphes + historique     | 🟨 Léger/modéré |
| `LibreNMS`  | Web    | Auto-discovery + alertes | 🟥 Moyen        |
| `snmptrapd` | Daemon | Réception de traps SNMP  | 🟩 Léger        |

---

Si tu veux **un outil minimal en CLI**, commence avec `snmpwalk` et `snmpget`.

Tu veux un peu de visuel avec graphes, mais rester sobre ? Essaie **Cacti**.

Tu veux un système plus avancé (multi-NAS, alertes, cartes réseau, etc.) ? **LibreNMS** est une excellente option.

Souhaites-tu que je t'aide à écrire un script de surveillance SNMP simple pour ton NAS ?


## B- Script Bash simple pour surveiller un **NAS via SNMP**, avec des informations de base utiles : nom d’hôte, uptime, CPU, mémoire et espace disque.

---

### ✅ **Script de surveillance SNMP minimal**

```bash
#!/bin/bash

# Configuration
NAS_IP="192.168.1.100"       # IP de ton NAS
COMMUNITY="maison"           # Communauté SNMP
SNMP_VERSION="2c"            # Version SNMP

# Fonction d'affichage
function display {
    echo "=== $1 ==="
    echo "$2"
    echo
}

# Nom d'hôte
HOSTNAME=$(snmpget -v$SNMP_VERSION -c $COMMUNITY $NAS_IP 1.3.6.1.2.1.1.5.0 -Ovq)
display "Nom de l'hôte" "$HOSTNAME"

# Uptime
UPTIME=$(snmpget -v$SNMP_VERSION -c $COMMUNITY $NAS_IP 1.3.6.1.2.1.1.3.0 -Ovq)
display "Uptime" "$UPTIME"

# Charge CPU (si disponible)
CPU_LOAD=$(snmpwalk -v$SNMP_VERSION -c $COMMUNITY $NAS_IP 1.3.6.1.4.1 | grep -i 'cpu' | head -n 5)
display "Utilisation CPU (approx.)" "$CPU_LOAD"

# Mémoire totale et libre (exemple avec UCD-SNMP-MIB)
MEM_TOTAL=$(snmpget -v$SNMP_VERSION -c $COMMUNITY $NAS_IP 1.3.6.1.4.1.2021.4.5.0 -Ovq)
MEM_FREE=$(snmpget -v$SNMP_VERSION -c $COMMUNITY $NAS_IP 1.3.6.1.4.1.2021.4.6.0 -Ovq)
display "Mémoire (kB)" "Total: $MEM_TOTAL kB - Libre: $MEM_FREE kB"

# Espace disque (UCD-SNMP-MIB hrStorage)
DISKS=$(snmpwalk -v$SNMP_VERSION -c $COMMUNITY $NAS_IP 1.3.6.1.2.1.25.2.3.1.3)
USAGES=$(snmpwalk -v$SNMP_VERSION -c $COMMUNITY $NAS_IP 1.3.6.1.2.1.25.2.3.1.6)
display "Espaces disques détectés" "$DISKS"
display "Utilisation de l’espace disque" "$USAGES"
```

---

### ✅ **Instructions pour l’utiliser**

1. **Copie le script dans un fichier** :

   ```bash
   nano monitor_nas_snmp.sh
   ```

2. **Colle le contenu du script**, modifie l’IP de ton NAS si besoin.

3. **Rends le script exécutable** :

   ```bash
   chmod +x monitor_nas_snmp.sh
   ```

4. **Exécute-le** :

   ```bash
   ./monitor_nas_snmp.sh
   ```

---

### ✅ **Prérequis**

Assure-toi que ton système a bien le client SNMP :

```bash
sudo apt install snmp
```

Et que le **NAS autorise les connexions SNMP** depuis ton PC (via son interface d’administration, souvent Synology, QNAP, etc.).

---

#### Tu veux aller plus loin ?

* Ajouter l’**alerte mail si un disque est presque plein**.
* Sortie **JSON ou CSV** pour exploitation par Prometheus, Telegraf, etc.
* Ajout d’un **crontab** pour surveiller régulièrement.

### Afficher en continu des mesures SNMP dans une fenêtre distincte
En utilisant des outils très simples et efficaces sous Linux/macOS.

Voici plusieurs méthodes possibles selon le degré de simplicité ou d’interface que tu souhaites.

---

### ✅ **Méthode 1 : `watch` dans un terminal séparé (minimaliste)**

#### 🧪 Commande :

```bash
watch -n 2 ./monitor_nas_snmp.sh
```

* Ouvre un **deuxième terminal**.
* Affiche la sortie du script toutes les **2 secondes**.
* Très simple, aucun ajout nécessaire au script.

> 💡 `watch` est installé par défaut sur la plupart des distributions Linux. Sur macOS :

```bash
brew install watch
```

---

### ✅ **Méthode 2 : lancer une fenêtre terminal séparée depuis un script**

Tu peux **automatiser l'ouverture d'une fenêtre de terminal** pour afficher la sortie en continu :

#### ▶️ Sous **macOS** :

```bash
osascript -e 'tell application "Terminal"
    do script "watch -n 2 ~/monitor_nas_snmp.sh"
end tell'
```

#### ▶️ Sous **Linux (Gnome Terminal)** :

```bash
gnome-terminal -- bash -c "watch -n 2 ~/monitor_nas_snmp.sh"
```

Ou avec `xterm` :

```bash
xterm -e "watch -n 2 ~/monitor_nas_snmp.sh" &
```

> 🔧 Adapte le chemin du script si besoin.

---

### ✅ **Méthode 3 : fenêtre graphique avec Zenity ou Yad (GUI légère)**

Si tu veux **une fenêtre graphique mise à jour dynamiquement** :

#### Avec `zenity` (simple fenêtre texte mise à jour) :

```bash
while true; do
  ./monitor_nas_snmp.sh > /tmp/snmp_monitor.txt
  zenity --text-info --filename=/tmp/snmp_monitor.txt --width=400 --height=300 --title="SNMP Monitor" &
  sleep 5
  pkill zenity
done
```

> 📦 Installe `zenity` avec :

```bash
sudo apt install zenity  # ou brew install zenity
```

---

### ✅ **Méthode 4 : Conky (si tu veux une vraie intégration bureau)**

Tu peux intégrer ton script dans une fenêtre **Conky** transparente en fond d’écran :

```lua
conky.config = {
  update_interval = 5,
  ...
};

conky.text = [[
${execpi 5 ~/.conky/monitor_nas_snmp.sh}
]];
```

---

### 🧠 Résumé

| Méthode                    | Interface       | Facilité      | Rafraîchissement  |
| -------------------------- | --------------- | ------------- | ----------------- |
| `watch`                    | Terminal        | ✅ Très simple | Oui (`-n X`)      |
| `gnome-terminal` / `xterm` | Terminal pop-up | ✅ Simple      | Oui (via script)  |
| `zenity` / `yad`           | Fenêtre GUI     | 🟨 Moyen      | Oui (manual loop) |
| Conky                      | Bureau          | 🟥 Avancé     | Automatique       |

---

Souhaites-tu que je t’écrive un **script complet avec ouverture automatique d’une fenêtre + affichage live** sur Linux ou macOS ?

## Voici un **script complet pour Linux** qui :

✅ Affiche les mesures SNMP de ton NAS
✅ Ouvre automatiquement une **nouvelle fenêtre de terminal**
✅ Met à jour l'affichage en continu (toutes les X secondes)

---

### 🖥️ **Script 1 : `monitor_nas_snmp.sh`** (à placer dans `~/monitor_nas_snmp.sh` par exemple)

```bash
#!/bin/bash

# Configuration SNMP
NAS_IP="192.168.1.100"      # Adresse IP du NAS
COMMUNITY="public"
SNMP_VERSION="2c"

# OIDs pour CPU
OID_IDLE=".1.3.6.1.4.1.2021.11.9.0"
OID_USER=".1.3.6.1.4.1.2021.11.11.0"
OID_SYSTEM=".1.3.6.1.4.1.2021.11.10.0"

# OIDs pour débit réseau (interface 1 à adapter si besoin)
IF_INDEX=1
OID_IN="1.3.6.1.2.1.2.2.1.10.${IF_INDEX}"
OID_OUT="1.3.6.1.2.1.2.2.1.16.${IF_INDEX}"

# Lecture CPU
CPU_IDLE=$(snmpget -v$SNMP_VERSION -c $COMMUNITY $NAS_IP $OID_IDLE -Ovq)
CPU_USER=$(snmpget -v$SNMP_VERSION -c $COMMUNITY $NAS_IP $OID_USER -Ovq)
CPU_SYSTEM=$(snmpget -v$SNMP_VERSION -c $COMMUNITY $NAS_IP $OID_SYSTEM -Ovq)
CPU_USED=$((100 - CPU_IDLE))

# Lecture débit réseau
IN1=$(snmpget -v$SNMP_VERSION -c $COMMUNITY $NAS_IP $OID_IN -Ovq)
OUT1=$(snmpget -v$SNMP_VERSION -c $COMMUNITY $NAS_IP $OID_OUT -Ovq)
sleep 1
IN2=$(snmpget -v$SNMP_VERSION -c $COMMUNITY $NAS_IP $OID_IN -Ovq)
OUT2=$(snmpget -v$SNMP_VERSION -c $COMMUNITY $NAS_IP $OID_OUT -Ovq)

DELTA_IN=$((IN2 - IN1))
DELTA_OUT=$((OUT2 - OUT1))
SPEED_IN_KBPS=$((DELTA_IN * 8 / 1024))
SPEED_OUT_KBPS=$((DELTA_OUT * 8 / 1024))

# Affichage formaté
clear
echo "🖧 SNMP Monitoring - $(date '+%Y-%m-%d %H:%M:%S')"
echo "-----------------------------"
echo "🧠 CPU Utilisation : ${CPU_USED}% (user: ${CPU_USER}%, system: ${CPU_SYSTEM}%)"
echo "📥 Réseau entrant : ${SPEED_IN_KBPS} Kb/s"
echo "📤 Réseau sortant : ${SPEED_OUT_KBPS} Kb/s"
```

> ✅ N'oublie pas :

```bash
chmod +x ~/monitor_nas_snmp.sh
```

---

### 🪟 **Script 2 : `launch_snmp_monitor.sh`** pour **ouvrir un terminal distinct avec rafraîchissement continu**

```bash
#!/bin/bash

# Rafraîchissement toutes les 5 secondes
gnome-terminal -- bash -c "watch -n 5 ~/monitor_nas_snmp.sh"
```

> Ou avec `xterm` :

```bash
xterm -e "watch -n 5 ~/monitor_nas_snmp.sh" &
```

---

#### ✅ Étapes d'utilisation :

1. Crée les deux scripts (`monitor_nas_snmp.sh` et `launch_snmp_monitor.sh`)
2. Donne les droits :

   ```bash
   chmod +x launch_snmp_monitor.sh
   ```
3. Exécute :

   ```bash
   ./launch_snmp_monitor.sh
   ```

---

### ✅ Résultat :

Une nouvelle fenêtre terminal s'ouvre et affiche :

```
🖧 SNMP Monitoring - 2025-06-07 18:17:00
-----------------------------
🧠 CPU Utilisation : 6% (user: 3%, system: 3%)
📥 Réseau entrant : 120 Kb/s
📤 Réseau sortant : 40 Kb/s
```

Mis à jour toutes les 5 secondes.

---

Souhaites-tu maintenant ajouter un **seuil d’alerte (ex. CPU > 90%)** avec couleur ou notification système (`notify-send`) ?


