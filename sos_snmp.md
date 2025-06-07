sos_snmp.md

## Surveiller un NAS via **SNMP** de manière **légère et efficace** depuis un système Linux

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


## 
Parfait ! Voici un **script Bash simple** pour surveiller un **NAS via SNMP**, avec des informations de base utiles : nom d’hôte, uptime, CPU, mémoire et espace disque.

---

## ✅ **Script de surveillance SNMP minimal**

```bash
#!/bin/bash

# Configuration
NAS_IP="192.168.1.100"       # IP de ton NAS
COMMUNITY="public"           # Communauté SNMP
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

## ✅ **Instructions pour l’utiliser**

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

## ✅ **Prérequis**

Assure-toi que ton système a bien le client SNMP :

```bash
sudo apt install snmp
```

Et que le **NAS autorise les connexions SNMP** depuis ton PC (via son interface d’administration, souvent Synology, QNAP, etc.).

---

### Tu veux aller plus loin ?

* Ajouter l’**alerte mail si un disque est presque plein**.
* Sortie **JSON ou CSV** pour exploitation par Prometheus, Telegraf, etc.
* Ajout d’un **crontab** pour surveiller régulièrement.

Souhaite-tu que je t’aide à ajouter l’un de ces éléments ?
