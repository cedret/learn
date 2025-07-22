Pour donner l'accès au dossier `/var/lib/libvirt/images/` à un utilisateur nommé `toto`, tu as plusieurs options selon le niveau de contrôle et de sécurité que tu veux garder.

---

### 🔒 Par défaut, ce répertoire appartient à `root:libvirt` avec des permissions restrictives :

```bash
drwx--x---  libvirt-qemu kvm  /var/lib/libvirt/images/
```

Tu ne veux **pas** ouvrir ce dossier à tout le monde, mais plutôt donner accès à l'utilisateur `toto` de manière sécurisée.

---

## ✅ Solution recommandée : Ajouter `toto` au groupe `libvirt`

1. 🔍 Vérifie le groupe propriétaire :

   ```bash
   ls -ld /var/lib/libvirt/images/
   ```

   Exemple typique :

   ```
   drwx--x---  5 root libvirt 4096 ... /var/lib/libvirt/images/
   ```

2. 👤 Ajoute l'utilisateur `toto` au groupe `libvirt` :

   ```bash
   sudo usermod -aG libvirt toto
   ```

3. 🔁 Déconnecte et reconnecte `toto` ou redémarre sa session pour que le changement prenne effet.

4. ✅ Vérifie :

   ```bash
   groups toto
   ```

   Il doit être listé dans `libvirt`.

---

## 📁 Option supplémentaire : Donner accès uniquement à un fichier/disque spécifique

Si tu ne veux pas donner accès à **tout le dossier**, tu peux :

1. Créer un fichier ou un dossier dédié dans `/var/lib/libvirt/images/` :

   ```bash
   sudo touch /var/lib/libvirt/images/vm1.qcow2
   sudo chown root:toto /var/lib/libvirt/images/vm1.qcow2
   sudo chmod 660 /var/lib/libvirt/images/vm1.qcow2
   ```

2. Ou monter un autre dossier ailleurs (e.g., `/home/toto/vms`) et faire un lien symbolique, mais **Libvirt** peut refuser selon les permissions SELinux/AppArmor.

---

## 🔐 Si SELinux est activé (Red Hat, Fedora, etc.)

Même si les permissions Unix sont bonnes, SELinux peut bloquer.

Vérifie le contexte :

```bash
ls -Z /var/lib/libvirt/images/
```

Si nécessaire, ajuste le contexte :

```bash
sudo chcon -t virt_image_t /chemin/vers/fichier.qcow2
```

---

Souhaites-tu que `toto` puisse **lancer des VMs** avec `virsh`, ou juste accéder aux fichiers de disque ?
Les permissions nécessaires peuvent varier selon le cas.
