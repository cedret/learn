Créer une clé USB bootable avec une image ISO sous Linux est relativement simple. Voici plusieurs méthodes courantes. Choisis celle qui te convient le mieux :

---

### ✅ **Méthode 1 : Avec `dd` (en ligne de commande)**

> ⚠️ **Attention :** cette méthode est puissante mais dangereuse. Vérifie bien le périphérique USB avant de lancer la commande.

#### Étapes :

1. Insère ta clé USB.

2. Ouvre un terminal.

3. Identifie ta clé avec :

   ```bash
   lsblk
   ```

   Repère le nom du périphérique (ex : `/dev/sdX`, **pas de chiffre à la fin**).

4. Monte pas la clé. Si elle est montée automatiquement, démonte-la :

   ```bash
   umount /dev/sdX*
   ```

5. Lance `dd` :

   ```bash
   sudo dd if=/chemin/vers/image.iso of=/dev/sdX bs=4M status=progress oflag=sync
   ```

   * `if=` : chemin vers ton fichier ISO
   * `of=` : périphérique USB (ex : `/dev/sdX`, **pas de partition comme `/dev/sdX1`**)
   * `bs=4M` : taille des blocs
   * `status=progress` : pour afficher la progression
   * `oflag=sync` : assure l'écriture complète des données

---

### ✅ **Méthode 2 : Avec `balenaEtcher` (interface graphique)**

1. Télécharge **[balenaEtcher](https://www.balena.io/etcher/)** (version AppImage disponible pour Linux).
2. Rends le fichier exécutable :

   ```bash
   chmod +x balenaEtcher-x.x.x-x64.AppImage
   ```
3. Lance-le :

   ```bash
   ./balenaEtcher-x.x.x-x64.AppImage
   ```
4. Sélectionne ton image ISO, la clé USB, et clique sur "Flash".

---

### ✅ **Méthode 3 : Avec `Ventoy` (multi-ISO)**

> Ventoy te permet de mettre **plusieurs ISO** sur une même clé USB.

1. Télécharge Ventoy depuis : [https://www.ventoy.net/en/download.html](https://www.ventoy.net/en/download.html)
2. Extrais le fichier et installe Ventoy sur la clé :

   ```bash
   sudo ./Ventoy2Disk.sh -i /dev/sdX
   ```
3. Copie simplement les fichiers ISO sur la clé (comme une clé normale).
4. Boot sur la clé : un menu Ventoy te permet de choisir l’ISO à lancer.

---

### ✅ **Méthode 4 : Avec `gnome-disks` (utilitaire disque de GNOME)**

1. Lance l’application **Disques** (`gnome-disks`).
2. Sélectionne ta clé USB.
3. Clique sur le menu (⚙️) → **Restaurer l'image disque**.
4. Choisis ton ISO et démarre l’écriture.

---

Souhaites-tu une recommandation selon ton usage ou ton niveau en Linux ?
