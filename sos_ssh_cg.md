### Installer SSH rapidement

https://averagelinuxuser.com/how-to-install-and-use-ssh-on-linux/

### Checklist pour se connecter proprement avec **MobaXterm + clé SSH** à un serveur Ubuntu

---

## 🛠️ Étapes pour générer la clé SSH et configurer MobaXterm

---

### 1️⃣ **Générer une clé SSH avec MobaXterm**
- Ouvre **MobaXterm**.
- Va dans le menu : **Tools → MobaKeyGen (SSH Key Generator)**.
- Clique sur **Generate** (remue un peu la souris dans la fenêtre pour générer de l’aléatoire).
- **Important** :
  - Sauvegarde ta **clé privée** (fichier `.ppk` ou `.pem`).
  - Copie la **clé publique** (affichée dans la fenêtre).
  - Laisse la **passphrase** vide (facultatif mais recommandé si tu veux éviter de taper un mot de passe à chaque connexion).

✅ Résultat : tu as une clé **privée** sur ton PC + une **clé publique** prête à être copiée sur ton serveur.

---

### 2️⃣ **Installer ta clé publique sur ton serveur Ubuntu**
Connecte-toi **temporairement** en SSH par mot de passe (si possible), sinon passe par l’accès direct serveur.

Puis :

- Sur Ubuntu :
```bash
mkdir -p ~/.ssh
nano ~/.ssh/authorized_keys
```
- Colle ta **clé publique** copiée depuis MobaKeyGen dans ce fichier `authorized_keys`.
- Sauvegarde et quitte.

Ensuite, règle les droits :
```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
chown stage:stage ~/.ssh -R
```
(**Important :** Sinon SSH refusera la connexion pour cause de permissions incorrectes.)

---

### 3️⃣ **Configurer MobaXterm pour utiliser ta clé privée**
- Dans MobaXterm :
  - Clique sur **Session** → **SSH**.
  - Renseigne :
    - **Remote host** : `192.168.1.122`
    - **Username** : `stage`
  - Coche **Use private key**.
  - Sélectionne ta clé privée (format `.ppk` ou `.pem`).

✅ Maintenant, MobaXterm utilisera ta **clé privée** pour te connecter automatiquement.

---

### 4️⃣ **Bonus : Vérifier la config SSH du serveur**
Assure-toi que sur Ubuntu `/etc/ssh/sshd_config` il y a :

```bash
PubkeyAuthentication yes
PasswordAuthentication no  # (optionnel pour renforcer la sécurité après)
```

Puis redémarre SSH :
```bash
sudo systemctl restart sshd
```

---

# 🎯 Résultat final :
Quand tu fais :
```bash
ssh stage@192.168.1.122
```
👉 MobaXterm utilisera ta clé et tu seras connecté **sans mot de passe**.

---

Veux-tu que je te prépare aussi un **script automatique** qui configure tout ça côté serveur ? (clé, dossier `.ssh`, permissions) 🔥  
Ça prend 10 secondes ensuite 🚀.
