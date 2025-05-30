https://blog.stephane-robert.info/docs/admin-serveurs/linux/netplan/

``systemctl status systemd-networkd`

https://www.scrample.xyz/configuration-ip-statique-avec-netplan/

https://code.mendhak.com/ubuntu-2404-set-static-ip-address-using-netplan/

https://linuxconfig.org/netplan-network-configuration-tutorial-for-beginners

https://linuxconfig.org/how-to-add-static-route-with-netplan-on-ubuntu-22-04-jammy-jellyfish-linux


Parfait, merci pour la précision. Ubuntu Server 22.04.5 LTS utilise **Netplan** pour la configuration réseau. Voici donc les étapes **claires et précises** pour changer l’adresse IP de ton serveur Nextcloud **en installation classique** (hors Docker ou Snap), en supposant qu’il tourne avec **Apache ou Nginx**.

---

## ✅ ÉTAPES POUR CHANGER L’ADRESSE IP SUR UBUNTU SERVER 22.04.5

### 1. 📁 Trouver le bon fichier Netplan

Généralement, le fichier de config se trouve ici :

```bash
/etc/netplan/01-netcfg.yaml
```

ou

```bash
/etc/netplan/00-installer-config.yaml
```

> Tu peux les lister avec :

```bash
ls /etc/netplan/
```

---

### 2. ✏️ Modifier l’adresse IP

Ouvre le fichier avec un éditeur :

```bash
sudo nano /etc/netplan/01-netcfg.yaml
```

Exemple de configuration pour une IP statique :

```yaml
network:
  version: 2
  ethernets:
    enp0s3:
      addresses:
        - 192.168.1.50/24   # ← Mets ici ta nouvelle IP
      gateway4: 192.168.1.1
      nameservers:
        addresses: [1.1.1.1, 8.8.8.8]
```

> ⚠️ Remplace `enp0s3` par le nom de ton interface réseau si différent (tu peux le vérifier avec `ip a`).

---

### 3. ✅ Appliquer la nouvelle configuration

Une fois modifié :

```bash
sudo netplan apply
```

Tu peux vérifier l’IP avec :

```bash
ip a
```

---

## 🔐 ÉTAPES POUR METTRE À JOUR NEXTCLOUD

Nextcloud n’accepte pas automatiquement les nouvelles IP. Il faut les ajouter dans le fichier `config.php`.

### 4. 🛠️ Modifier `config.php`

```bash
sudo nano /var/www/nextcloud/config/config.php
```

Ajoute ta nouvelle IP dans `trusted_domains` :

```php
'trusted_domains' =>
  array (
    0 => 'localhost',
    1 => '192.168.1.50',  // ← nouvelle IP ici
  ),
```

---

### 5. 🔁 Redémarrer le serveur web

* Pour Apache :

  ```bash
  sudo systemctl restart apache2
  ```

* Pour Nginx :

  ```bash
  sudo systemctl restart nginx
  ```

---

## 🧪 Vérification

Depuis un autre appareil du réseau, teste dans un navigateur :

```
http://192.168.1.50/
```

Tu devrais accéder à ton instance Nextcloud sans message d’erreur.

---

Souhaites-tu également :

* Passer à une **adresse IP dynamique (DHCP)** ?
* Configurer un **nom de domaine ou un accès HTTPS** ?
* Ajouter un **reverse proxy (ex : avec Nginx)** ?

### 

Super, passons à la mise en place de l’accès **HTTPS** pour Nextcloud sur Ubuntu Server 22.04.5. Voici comment faire **proprement et gratuitement** avec **Let’s Encrypt** (certificat SSL gratuit) et le serveur **Apache** (ou Nginx si tu préfères, dis-le-moi).

---

## ✅ PRÉREQUIS AVANT DE PASSER À HTTPS

1. 🔍 **Nom de domaine (ou sous-domaine)** pointant vers ton serveur (même local ou via un DNS dynamique comme No-IP, DuckDNS ou DynDNS).
2. 📤 Le port **443 (HTTPS)** et **80 (HTTP)** doivent être ouverts dans le pare-feu et redirigés si tu es derrière une box/routeur.
3. 🧭 Nextcloud doit être accessible via ce nom de domaine en HTTP d’abord.

> Exemple : `nextcloud.mondomaine.tld`

---

## 🚀 INSTALLATION DU HTTPS AVEC LET’S ENCRYPT + APACHE

### Étape 1 : Installer Certbot (outil Let's Encrypt)

```bash
sudo apt update
sudo apt install certbot python3-certbot-apache -y
```

---

### Étape 2 : Activer le module SSL d’Apache

```bash
sudo a2enmod ssl
sudo systemctl restart apache2
```

---

### Étape 3 : Demander le certificat SSL

```bash
sudo certbot --apache
```

➡️ **Réponds aux questions** :

* Ton email pour les notifications.
* Accepter les conditions.
* Choisir le domaine pour lequel tu veux activer HTTPS.
* Et surtout : choisis l’option qui **force la redirection HTTP → HTTPS**.

---

### Étape 4 : Vérifie dans le navigateur

Essaie :

```
https://nextcloud.mondomaine.tld
```

Tu devrais avoir un cadenas 🔒 dans la barre d'adresse, signe que le HTTPS est actif.

---

## 🔄 RENOUVELLEMENT AUTOMATIQUE

Let’s Encrypt expire tous les 90 jours, mais Certbot s’en charge automatiquement. Pour t’en assurer :

```bash
sudo systemctl list-timers
```

Tu devrais voir un timer pour `certbot.timer`.

---

## ⚙️ AJOUTER LE DOMAINE DANS NEXTCLOUD

Ajoute aussi ton nom de domaine dans `config.php` :

```bash
sudo nano /var/www/nextcloud/config/config.php
```

```php
'trusted_domains' =>
  array (
    0 => 'localhost',
    1 => '192.168.1.50',
    2 => 'nextcloud.mondomaine.tld',  // ← ici
  ),
```

---

## (Optionnel) REDIRIGER TOUT VERS HTTPS (si Certbot ne l’a pas fait)

```bash
sudo nano /etc/apache2/sites-available/000-default.conf
```

Ajoute :

```apache
<VirtualHost *:80>
    ServerName nextcloud.mondomaine.tld
    Redirect permanent / https://nextcloud.mondomaine.tld/
</VirtualHost>
```

Puis redémarre Apache :

```bash
sudo systemctl restart apache2
```

---

Souhaites-tu que je t’aide à :

* Configurer un **nom de domaine dynamique gratuit (ex : DuckDNS)** ?
* Faire la même chose avec **Nginx** au lieu d’Apache ?
* Générer un certificat **autosigné** si tu es 100% en local sans DNS ?

### 
