sos_erreur.md
```
nfs server 192.168.1.207:/volume2/vsy21tri2int: not responding
nfs server 192.168.1.207:/volume2/vsy21tri2int: is alive again
```
``sudo mount -t nfs -o rw,bg,hard,intr,timeo=600,retrans=10 192.168.1.22:/volume2/vsy21tri /mnt/nfs_test``

---
```
--- Minute 30 --- 2025-06-11 10:03:17 --- 6908/6908=100% restent 0 minutes
--- Cycle terminé, démonter/remonter réseau entre chaque itération?
./sc11savedata.sh: line 384: $LOGIFIX: ambiguous redirect
-- 6908 fichiers en 47 min. à 57 Mo/s
```

Voici des réponses précises à tes deux questions sur NFS :

---

## ✅ **1) Comment logger les résultats du script NFS (`nfs_test.sh`)**

Ajoute simplement une redirection de sortie **vers un fichier log** dans ton script :

### 🔹 Option simple : redirection dans le script

Ajoute en haut de ton script :

```bash
LOGFILE="/var/log/nfs_test.log"
exec > >(tee -a "$LOGFILE") 2>&1
echo "==== Test lancé le $(date '+%Y-%m-%d %H:%M:%S') ===="
```

Cela :

* affiche **et loggue** tout ce que produit le script
* garde les erreurs dans le log également

---

### 🔹 Option CSV : résultats horodatés

À la fin de ton script, ajoute :

```bash
echo "$(date '+%Y-%m-%d %H:%M:%S'),$write_time,$read_time,$fsync_time,$delete_time" >> nfs_test.csv
```

> À condition que tu stockes les durées dans des variables (`write_time=...`, etc.).

---

## 🚨 **2) Éviter les messages NFS : `not responding / is alive again`**

Ces messages apparaissent **quand le client NFS perd la connexion temporairement au serveur**. Ils sont logués par le noyau.

### 📍 Exemple de message :

```
nfs server 192.168.1.22:/volume2/vsy21tri: not responding, still trying
nfs server 192.168.1.22:/volume2/vsy21tri: is alive again
```

---

### 🧨 Causes possibles

| Cause                         | Explication                                                    |
| ----------------------------- | -------------------------------------------------------------- |
| Serveur NFS lent ou en veille | Serveur Synology, NAS ou disque en veille prolongée            |
| Réseau instable               | Latence, déconnexion, Wi-Fi                                    |
| Monté en mode `soft`          | Le client abandonne vite en cas d'erreur                       |
| Pas d'options de résilience   | Le client n’a pas de délai configuré pour attendre / reprendre |

---

### ✅ Solutions : Monter NFS de manière **plus robuste**

Monte le point de montage avec les **bonnes options** :

#### Exemple :

```bash
sudo mount -t nfs -o rw,bg,hard,intr,timeo=600,retrans=10 192.168.1.22:/volume2/vsy21tri /mnt/nfs_test
```

| Option       | Signification                                         |
| ------------ | ----------------------------------------------------- |
| `bg`         | monte en arrière-plan si en attente                   |
| `hard`       | réessaie indéfiniment (évite les abandons)            |
| `intr`       | permet interruption propre (utile pour l’utilisateur) |
| `timeo=600`  | temps avant timeout (60.0 sec × 10 = 600 déciseconds) |
| `retrans=10` | nombre de tentatives avant erreur                     |

---

### ⛔️ Éviter `soft`

Ne monte **jamais en `soft`** si tu veux de la fiabilité. Cela entraîne des erreurs silencieuses si NFS est lent ou instable.

---

## 📚 Bonus : filtrer ces messages du noyau

Tu peux **empêcher l'affichage de ces messages dans `dmesg` ou la console**, mais **pas les empêcher côté noyau**.

```bash
dmesg --console-off    # temporairement
```

Ou limite leur journalisation dans `rsyslog` ou `journald`, mais ce n’est **pas recommandé**, car tu risquerais de masquer des vraies erreurs réseau.

---

## ✅ En résumé

| Action                               | Commande / conseil                            |
| ------------------------------------ | --------------------------------------------- |
| Logger le script                     | `exec > >(tee -a logfile) 2>&1`               |
| Monter NFS résilient                 | `mount -o hard,intr,bg,timeo=600`             |
| Éviter les messages `not responding` | Évite `soft`, optimise réseau et serveur      |
| Diagnostiquer cause                  | `ping`, `nfsstat`, `dmesg`, `/var/log/syslog` |

Souhaites-tu que je t’aide à créer une entrée `fstab` stable pour ce montage ?
