
https://www.cyberciti.biz/faq/apple-mac-osx-nfs-mount-command-tutorial/

https://www.it-connect.fr/le-protocole-nfs-pour-les-debutants/

https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nfs-mount-on-ubuntu-20-04-fr

https://www.tutos.eu/9011

https://www.linuxtricks.fr/wiki/nfs-parametrer-les-partages-avec-le-fichier-exports

https://doc.ubuntu-fr.org/nfs

https://dadarevue.com/montage-nfs-partage-raspbian-raspberry/


```
----- showmount -e 192.168.1.207
Exports list on 192.168.1.207:
/volume3/vsy21app3os                192.168.1.0/24
/volume1/vsy21bib1med               192.168.1.0/24
/volume2/vsy21tri2int               192.168.1.211
/volume2/vsy21fam2arc               192.168.1.219
/volume4/vsy21tri4ext               192.168.1.0/24
mount_nfs: can't mount /volume2/vsy21tri2int from 192.168.1.207 onto /private/nfs207tri2: Permission denied
----- df -H
Filesystem      Size   Used  Avail Capacity iused               ifree %iused  Mounted on
/dev/disk1s1    240G   198G    37G    85%  824762 9223372036853951045    0%   /
devfs           189k   189k     0B   100%     642                   0  100%   /dev
/dev/disk1s4    240G   4.3G    37G    11%       3 9223372036854775804    0%   /private/var/vm
map -hosts        0B     0B     0B   100%       0                   0  100%   /net
map auto_home     0B     0B     0B   100%       0                   0  100%   /home
```

### Après modification de /etc/exports

```
access@vsy07:/$ sudo cat /etc/exports
Password: 

/volume4/vsy21tri4ext	192.168.1.211(rw,async,no_wdelay,no_root_squash,insecure_locks,sec=sys,anonuid=1025,anongid=100)	192.168.1.0/24(rw,async,no_wdelay,crossmnt,insecure,root_squash,insecure_locks,sec=sys,anonuid=1024,anongid=100)
/volume1/vsy21bib1med	192.168.1.0/24(ro,async,no_wdelay,no_root_squash,insecure_locks,sec=sys,anonuid=1025,anongid=100)
/volume2/vsy21fam2arc	192.168.1.219(rw,async,no_wdelay,all_squash,insecure_locks,sec=sys,anonuid=1025,anongid=100)
/volume3/vsy21app3os	192.168.1.0/24(rw,async,no_wdelay,root_squash,insecure_locks,sec=sys,anonuid=1024,anongid=100)
/volume2/vsy21tri2int	192.168.1.0/24(rw,async,no_wdelay,no_root_squash,insecure_locks,sec=sys,anonuid=1025,anongid=100)

----- showmount -e 192.168.1.207
Exports list on 192.168.1.207:
/volume2/vsy21tri2int               192.168.1.0/24
/volume3/vsy21app3os                192.168.1.0/24
/volume1/vsy21bib1med               192.168.1.0/24
/volume2/vsy21fam2arc               192.168.1.219
/volume4/vsy21tri4ext               192.168.1.0/24
----- df -H
Filesystem                            Size   Used  Avail Capacity iused               ifree %iused  Mounted on
/dev/disk1s1                          240G   198G    37G    85%  825356 9223372036853950451    0%   /
devfs                                 190k   190k     0B   100%     644                   0  100%   /dev
/dev/disk1s4                          240G   4.3G    37G    11%       3 9223372036854775804    0%   /private/var/vm
map -hosts                              0B     0B     0B   100%       0                   0  100%   /net
map auto_home                           0B     0B     0B   100%       0                   0  100%   /home
192.168.1.207:/volume2/vsy21tri2int   2.2T   1.8T   473G    79%  771152           137575344    1%   /private/nfs207tri2
```
### Autres modifs:

```
access@vsy07:/$ sudo cat /etc/exports
Password: 

/volume4/vsy21tri4ext	192.168.1.211(rw,async,no_wdelay,no_root_squash,insecure_locks,sec=sys,anonuid=1025,anongid=100)
						192.168.1.0/24(rw,async,no_wdelay,crossmnt,insecure,root_squash,insecure_locks,sec=sys,anonuid=1024,anongid=100)
/volume1/vsy21bib1med	192.168.1.0/24(ro,async,no_wdelay,no_root_squash,insecure_locks,sec=sys,anonuid=1025,anongid=100)
/volume2/vsy21fam2arc	192.168.1.219(rw,async,no_wdelay,all_squash,insecure_locks,sec=sys,anonuid=1025,anongid=100)
/volume3/vsy21app3os	192.168.1.0/24(rw,async,no_wdelay,root_squash,insecure_locks,sec=sys,anonuid=1024,anongid=100)
/volume2/vsy21tri2int	192.168.1.0/24(rw,sync,no_wdelay,crossmnt,all_squash,insecure_locks,sec=sys,anonuid=1024,anongid=100)
```


Le message d'erreur :

```
mount_nfs: can't mount /volume2/vsy21tri2 from 192.168.100.107 onto /private/nfs107tri2: Permission denied
```

signifie que ton client macOS a essayé de monter le partage NFS depuis le serveur `192.168.100.107`, mais que l’accès a été refusé. Cela peut venir de plusieurs causes :

---

### 🔒 **Causes Possibles et Solutions**

#### 1. **Autorisations sur le serveur NFS (Synology)**

Assure-toi que le dossier partagé (`/volume2/vsy21tri2`) est bien exporté avec les bons droits.

* Sur ton Synology (ou autre serveur NFS), va dans **Panneau de configuration > Services de fichiers > NFS**.
* Vérifie que :

  * **Le partage NFS est activé**.
  * **Le dossier partagé `/volume2/vsy21tri2` est bien exporté.**
  * **L’IP 192.168.x.x du client est autorisée**, par exemple :

    * `192.168.100.0/24` avec les options d’export adéquates (`rw`, `no_root_squash`, etc.).

#### 2. **Permissions Unix sur le répertoire**

Le compte utilisé doit avoir les bons droits sur `/volume2/vsy21tri2`.

* Vérifie avec :

  ```sh
  ls -ld /volume2/vsy21tri2
  ```
* Si l’utilisateur root est utilisé côté client, le paramètre **"squash root"** peut transformer les requêtes root en `nobody`. Assure-toi que le répertoire est lisible/accessible par `nobody` ou utilise `no_root_squash` côté serveur NFS.

#### 3. **Firewall sur le serveur**

Le port NFS peut être bloqué. Assure-toi que :

* Le port **2049** est ouvert.
* Eventuellement, les ports **portmapper (111)** ou autres dépendants de NFSv3 sont ouverts.
* Teste avec :

  ```sh
  telnet 192.168.100.107 2049
  ```

#### 4. **Export NFS mal défini**

Regarde la sortie sur le serveur (ou NAS) avec :

```sh
cat /etc/exports
```

Elle devrait inclure une ligne comme :

```
/volume2/vsy21tri2 192.168.100.0/24(rw,sync,no_root_squash,no_subtree_check)
```

---

### ✅ Test Rapide

Sur ton Mac, tu peux aussi tester la visibilité des exports :

```sh
showmount -e 192.168.100.107
```

Cela te montre les partages NFS visibles. Si le répertoire `vsy21tri2` n’apparaît pas, c’est que le problème est côté export.

---

Souhaite-tu que je t’aide à corriger les exports sur un Synology NAS ?

Merci pour le détail. Ton export NFS :

```
192.168.100.0/24(rw,async,no_wdelay,no_root_squash,insecure_locks,sec=sys,anonuid=1025,anongid=100)
```

est en apparence correct **si** :

* L’adresse IP de ton Mac est bien dans la plage `192.168.100.0/24`
* Le dossier `/volume2/vsy21tri2` est lisible par l'utilisateur **UID 1025 / GID 100** (anonymes)
* Et que ton **client macOS** utilise un mapping NFS compatible avec ça

---

### ✅ Ce que cette configuration implique

* `no_root_squash` : le client `root` reste `root`, donc tu **ne devrais pas** avoir d'erreur de type "Permission denied" si tu montes en `sudo`.
* `anonuid=1025` et `anongid=100` : définissent l'utilisateur "anonyme" pour les accès "squashés" (ce qui **n'est pas censé être le cas ici** à cause du `no_root_squash`, mais reste important si le client se connecte avec un autre utilisateur).
* `rw` : écriture autorisée
* `insecure_locks` + `sec=sys` : typiques pour compatibilité macOS

---

### 🔍 À vérifier côté client (macOS)

1. **Vérifie ton IP locale**

```bash
ifconfig | grep inet
```

Confirme que ton Mac est bien dans le réseau `192.168.100.0/24`.

2. **Teste la visibilité du partage NFS**

```bash
showmount -e 192.168.100.107
```

Tu dois voir `/volume2/vsy21tri2` listé.

3. **Vérifie les permissions Unix sur le NAS**
   Sur le Synology, exécute (via SSH ou terminal admin) :

```bash
ls -ld /volume2/vsy21tri2
```

Puis :

```bash
ls -n /volume2/vsy21tri2
```

Compare les UID/GID : le client montera le partage avec l’utilisateur `root` (si pas squashé) ou `UID 1025`.

Si le répertoire n'est pas accessible par cet UID, tu auras "Permission denied".

---

### 🧪 Test de montage en mode verbeux

Sur macOS :

```bash
sudo mount -v -t nfs -o vers=3,nolocks 192.168.100.107:/volume2/vsy21tri2 /private/nfs107tri2
```

Essaie aussi avec :

```bash
sudo mount -t nfs -o resvport 192.168.100.107:/volume2/vsy21tri2 /private/nfs107tri2
```

> ⚠️ macOS peut exiger l’option `resvport` pour utiliser un port privilégié.

---

### 🛠 En résumé

| Étape                        | À faire                                             |
| ---------------------------- | --------------------------------------------------- |
| IP client dans le bon réseau | Oui → `192.168.100.xxx`                             |
| Exports NFS visibles         | `showmount -e 192.168.100.107`                      |
| UID/GID serveur valides      | Le répertoire est lisible/accessible pour root      |
| Test avec `resvport`         | Option utile sur macOS                              |
| Logs côté Synology           | Regarde dans `/var/log/messages` ou `/var/log/nfs*` |

---

Souhaite-tu que je t’aide à faire une vérification plus précise des UID/GID sur le Synology ?


L'erreur `rsync: chown ... failed: Operation not permitted (1)` signifie que **`rsync` essaie de changer le propriétaire (`chown`)** d’un fichier ou dossier, mais que le **système de fichiers distant (NFS)** **refuse cette opération**.

---

### 🎯 **Pourquoi ça arrive ?**

Même si tu montes le partage NFS en tant que `root`, **le serveur NFS (Synology)** peut **refuser l’opération `chown`** pour des raisons de sécurité ou de configuration.

#### ⚠️ En NFS, `chown` peut être interdit selon :

1. La version de NFS utilisée (souvent NFSv3 sur macOS)
2. Les options d'export du serveur (par exemple, les UID anonymes)
3. Le système de fichiers sous-jacent (ex. : Btrfs sur Synology peut restreindre certains appels root)
4. Le comportement propre de macOS, qui peut forcer `rsync` à faire des `chown` même quand c'est inutile

---

### ✅ **Solutions possibles**

#### ✅ 1. **Ajouter `--no-owner` à `rsync`**

Si tu **n’as pas besoin de conserver les propriétaires exacts**, désactive le `chown` :

```bash
rsync -a --no-owner --no-group source/ /private/nfs207tri2/rsy2506mni/
```

Cela empêche `rsync` d'essayer de faire `chown` / `chgrp`.

---

#### ✅ 2. **Monter le NFS avec `-o noacl` (si supporté)**

Sous certaines versions de Linux, l’option `noacl` peut désactiver la gestion des ACL qui bloque les `chown`. Ce n’est **pas disponible sur macOS**, mais utile à savoir si tu testes depuis Linux.

---

#### ✅ 3. **Changer les exports NFS (NAS Synology)**

Sur ton export, tu as :

```
anonuid=1025, anongid=100
```

Mais comme tu utilises `no_root_squash`, ce paramètre est **inutile** : le client root garde ses privilèges.

> **💡 Cependant**, certains NAS ignorent `no_root_squash` pour `chown`, surtout si le partage est en Btrfs. Tu peux essayer de :

* Créer un **utilisateur dédié sur le NAS** avec UID correspondant
* Monter le partage **en tant qu’utilisateur NFS explicite** (plus complexe avec macOS)

---

#### ✅ 4. **Utiliser `rsync` en ignorant les erreurs `chown`**

Pas idéal, mais si les permissions ne sont pas critiques :

```bash
rsync -a --no-owner --no-group --ignore-errors source/ /private/nfs207tri2/rsy2506mni/
```

---

### 🧪 Test rapide

Avant de relancer ton `rsync`, fais un test simple :

```bash
touch /private/nfs207tri2/testfile
sudo chown 501:20 /private/nfs207tri2/testfile
```

→ Si tu obtiens `Operation not permitted`, c’est bien le `chown` qui est bloqué par le serveur NFS.

---

### 🧵 En résumé

| Cause probable                           | Solution                                                               |
| ---------------------------------------- | ---------------------------------------------------------------------- |
| Serveur NFS interdit `chown`             | Ajouter `--no-owner --no-group` à `rsync`                              |
| UID non mappés ou squashés               | Monter avec UID/GID explicites ou adapter les permissions sur NAS      |
| NAS ignore `no_root_squash` pour `chown` | Tester sans tentative de `chown`, ou créer utilisateurs correspondants |

Souhaite-tu que je t’aide à adapter ton export Synology pour permettre `chown`, ou préfères-tu modifier ta commande `rsync` ?
