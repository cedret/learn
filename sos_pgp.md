## bloc 01

Voici une clé PGP en ASCII :

```
-----BEGIN PGP PUBLIC KEY BLOCK-----

mQINBGXYZ2EBEACx1v6Iz5XbNc7c5GF7HnHsF8Yoel5gNJvE6Oxd4U+qD5AZLt5W
b1x5b6xCbQdt0Ab5+ZdmcCMKnpLYG1ug1JQbFZbF/xPyA6LUt2Eo5RxXZrsXkVMP
...
(Public key data here)
...
OBMPo5zz7V2LWtJ5Tgf3AiYy60OwB6REuFTtfOP2XlUdVa06c7tzTQARAQABtBxU
ZXN0IFVzZXIgPHRlc3RAY2hhdHB0Zy5haT6JAlQEEwEIAD4WIQT2N5zN4U1N5X5m
VTRxKNtZl6yo9wUCYFhngwIbAwUJA8JnAAULCQgHAgYVCgkICwIEFgIDAQIeAQIX
gAAKCRBxKNtZl6yo98I1D/46JDmlHbo9ukIbMlg0Oe2tY0lCmZ4KvIlo3BAV7Guk
...
(Public key data here)
...
=abcd
-----END PGP PUBLIC KEY BLOCK-----
```

Si vous souhaitez générer une clé PGP réelle pour votre usage, vous pouvez utiliser un outil comme GnuPG avec la commande :

```sh
gpg --gen-key
```

Ou pour exporter votre clé publique en ASCII :

```sh
gpg --export --armor your@email.com
```

Si vous avez besoin d'aide pour générer ou utiliser votre clé PGP, faites-moi savoir ! 😊


## bloc 02

Pour importer une clé publique PGP d'un contact, suivez ces étapes :

### 📌 **Méthode 1 : Importer une clé depuis un fichier**

Si votre contact vous a envoyé un fichier contenant sa clé publique (par exemple, `contact_key.asc`), utilisez cette commande dans un terminal :

```sh
gpg --import contact_key.asc
```

### 📌 **Méthode 2 : Importer une clé depuis un serveur de clés**

Si la clé est disponible sur un serveur de clés publiques, recherchez-la avec :

```sh
gpg --search-keys "email@contact.com"
```

Ou importez-la directement en utilisant son identifiant (Key ID ou Fingerprint) :

```sh
gpg --recv-keys 0xKEYID
```

Par exemple, si l'ID de la clé est `12345678ABCDEF90`, utilisez :

```sh
gpg --recv-keys 12345678ABCDEF90
```

### 📌 **Vérification après import**

Une fois la clé importée, vous pouvez la vérifier avec :

```sh
gpg --list-keys
```

Si besoin, signez la clé pour indiquer que vous lui faites confiance :

```sh
gpg --edit-key "email@contact.com"
> trust
> 5  (ultimate)
> save
```

Si vous avez un fichier de clé à me fournir, je peux également vous aider à l'analyser. 😊

## bloc 03

Pour exporter une clé publique PGP en ASCII, utilisez la commande suivante dans un terminal :

```sh
gpg --export --armor your@email.com
```

🔹 **Explication :**

* `--export` : Exporte la clé publique.
* `--armor` : Convertit la clé en format ASCII (au lieu d'un binaire).
* `your@email.com` : Remplacez par l'adresse email associée à la clé.

📌 **Exporter vers un fichier**
Si vous souhaitez enregistrer la clé dans un fichier `.asc`, utilisez :

```sh
gpg --export --armor your@email.com > my_public_key.asc
```

📌 **Exporter une clé privée (⚠️ à ne faire que si nécessaire et en toute sécurité)**
Si vous avez besoin d'exporter votre **clé privée** (⚠️ très sensible), utilisez :

```sh
gpg --export-secret-keys --armor your@email.com > my_private_key.asc
```

Assurez-vous de la stocker en lieu sûr et de ne jamais la partager publiquement ! 🔐

Si vous avez besoin d'autres infos, n'hésitez pas ! 😊

## Bloc 04

Pour chiffrer un fichier avec **GPG** en utilisant votre clé publique, suivez ces étapes :

---

### 📌 **1. Chiffrer un fichier pour vous-même**

Si vous souhaitez **chiffrer un fichier** (`mon_fichier.txt`) pour que **vous seul** puissiez le déchiffrer (avec votre propre clé privée), utilisez :

```sh
gpg --encrypt --recipient "your@email.com" --armor mon_fichier.txt
```

🔹 **Explication :**

* `--encrypt` : Chiffre le fichier.
* `--recipient "your@email.com"` : Utilise votre clé publique pour le chiffrement.
* `--armor` : Produit un fichier ASCII (`.asc`) au lieu d’un binaire (`.gpg`).
* `mon_fichier.txt` : Remplacez par le fichier que vous voulez chiffrer.

Cela génère un fichier `mon_fichier.txt.asc`.

---

### 📌 **2. Chiffrer un fichier pour un contact**

Si vous envoyez un fichier chiffré à quelqu’un, utilisez sa clé publique :

```sh
gpg --encrypt --recipient "contact@email.com" mon_fichier.txt
```

Cela génère un fichier `mon_fichier.txt.gpg` que seul votre contact pourra déchiffrer avec **sa** clé privée.

---

### 📌 **3. Chiffrer et signer un fichier**

Si vous voulez **chiffrer et signer** le fichier (prouvant que c'est bien vous l'expéditeur), utilisez :

```sh
gpg --encrypt --sign --recipient "contact@email.com" mon_fichier.txt
```

Cela garantit à votre contact que vous êtes bien l’auteur du fichier.

---

### 📌 **4. Déchiffrer un fichier chiffré**

Si vous recevez un fichier chiffré (`mon_fichier.txt.gpg`), déchiffrez-le avec :

```sh
gpg --decrypt mon_fichier.txt.gpg
```

Si vous voulez **enregistrer le fichier déchiffré** au lieu de l'afficher dans le terminal :

```sh
gpg --output mon_fichier_dechiffre.txt --decrypt mon_fichier.txt.gpg
```

---

Si vous avez des questions ou besoin d'aide pour un cas spécifique, n'hésitez pas ! 😊🔐

## bloc 05
