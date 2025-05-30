sos_ipadress_macos.md

Pour connaître ton **adresse IP** en ligne de commande sur **macOS**, voici les principales méthodes selon ce que tu cherches (IP locale ou publique) :

---

### 📍 **1. Adresse IP locale (réseau local / LAN)**

#### Méthode simple :

```bash
ipconfig getifaddr en0
```

> `en0` est l'interface Ethernet ou Wi-Fi (selon la machine). Sur la plupart des Mac récents, c'est le Wi-Fi.

* Si tu es connecté par Ethernet, essaie aussi :

```bash
ipconfig getifaddr en1
```

#### Pour voir toutes les interfaces réseau :

```bash
ifconfig
```

> Cherche une ligne comme `inet 192.168.x.x` sous l'interface en0 ou en1.

---

### 🌐 **2. Adresse IP publique (visible sur Internet)**

```bash
curl ifconfig.me
```

ou

```bash
curl https://api.ipify.org
```

---

### ✅ Résumé rapide

| Type d'IP         | Commande                                   |
| ----------------- | ------------------------------------------ |
| Locale (Wi-Fi)    | `ipconfig getifaddr en0`                   |
| Locale (Ethernet) | `ipconfig getifaddr en1`                   |
| Toutes interfaces | `ifconfig`                                 |
| Publique (WAN)    | `curl ifconfig.me` ou `curl api.ipify.org` |

---
---

## Tu veux connaître l’IP d’un autre appareil sur ton réseau aussi ?

Pour connaître l'**adresse IP** d'un autre appareil sur ton réseau local (LAN), il y a plusieurs manières de procéder depuis **macOS**.

### 📍 **1. Scanner le réseau local avec `nmap`**

Si tu n'as pas encore installé **nmap**, tu peux le faire via **Homebrew** (gestionnaire de paquets pour macOS).

1. **Installer nmap via Homebrew** (si ce n’est pas déjà fait) :

   ```bash
   brew install nmap
   ```

2. **Scanner ton réseau local** :

   Disons que ton réseau est dans la plage `192.168.1.x` (commune dans les réseaux domestiques).

   ```bash
   nmap -sn 192.168.1.0/24
   ```

   Cela scanne toutes les adresses de `192.168.1.1` à `192.168.1.254` pour voir quels appareils sont connectés à ton réseau.

3. **Exemple de sortie** :

   ```bash
   Nmap scan report for 192.168.1.10
   Host is up (0.0040s latency).
   Nmap scan report for 192.168.1.15
   Host is up (0.0035s latency).
   ```

   Cela te donnera les adresses IP des appareils en ligne.

---

### 📍 **2. Utiliser `arp` pour trouver les appareils sur ton réseau**

1. **Vérifie l'IP de la machine connectée récemment à ton réseau** :

   ```bash
   arp -a
   ```

   Cela affichera une liste des adresses IP et des adresses MAC des appareils récemment connectés.

---

### 📍 **3. Utiliser `ping` avec une plage d'adresses IP**

Tu peux aussi **pinguer** toutes les adresses IP sur ton réseau pour savoir lesquelles répondent :

1. **Exécute une série de pings sur les adresses possibles** :

   Par exemple, si ton réseau est `192.168.1.x`, tu peux pinguer toutes les adresses du `1` au `254` :

   ```bash
   for ip in {1..254}; do ping -c 1 192.168.1.$ip; done
   ```

   Cela envoie un **ping** à chaque adresse de `192.168.1.1` à `192.168.1.254` et te montre celles qui répondent.

---

### 📍 **4. Utiliser l'interface graphique "Partage"**

Si tu veux **trouver** des appareils via l'interface **Finder**, tu peux aussi :

1. **Ouvrir Finder**.
2. Dans la barre de menu, choisir **Aller > Réseau**.
3. Tu verras une liste de tous les appareils connectés à ton réseau.

---

### 📍 **5. Vérifier dans ton routeur (interface web)**

La plupart des routeurs offrent une interface web pour consulter les **dispositifs connectés** et leurs **adresses IP**. Pour cela :

1. Ouvre ton navigateur et tape l’adresse IP de ton routeur (souvent `192.168.1.1` ou `192.168.0.1`).
2. Connecte-toi avec tes identifiants.
3. Cherche dans les paramètres de réseau ou DHCP pour voir les appareils connectés et leurs IP.

---

Si tu as besoin d'aide pour une méthode particulière ou pour installer un outil comme **nmap**, fais-le moi savoir !
