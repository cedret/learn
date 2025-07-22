linux process

Plougoumelen: 2APQDtaGqeVt65513U

https://www.tutos.eu/4844

https://www.hostinger.com/tutorials/how-to-kill-a-process-in-linux?utm_campaign=Generic-Tutorials-DSA|NT:Se|LO:FR-EN&utm_medium=ppc&gad_source=1&gad_campaignid=20586398874&gclid=EAIaIQobChMIudr6psOJjgMVMlFBAh1Fgi3AEAAYASAAEgLZEvD_BwE

https://www.cyberciti.biz/faq/show-progress-during-file-transfer/

https://www.cyberciti.biz/faq/unix-linux-bash-script-check-if-variable-is-empty/



https://github.com/Rem0o/FanControl.Releases

gparted
vlc
sublime text
chromium
brave
nmap
https://blog.stephane-robert.info/docs/securiser/reseaux/analyse/nmap/

``scp sc13savedata.sh @192.168.1.217:/volume1/home/secours``

``lspci | grep -i network``

### Monter disque dur -2506-

secours@mni25nvme:~$ sudo chown secours /media/secours/fix25vsy

https://belginux.com/monter-un-disque-dur-sous-debian/

https://doc.ubuntu-fr.org/mount_fstab

https://www.it-connect.fr/ajouter-un-disque-dur-sous-linux/

https://borntocode.fr/linux-monter-son-second-disque-dur-de-maniere-permanente/



``lsblk -o name,fstype,size,fsused,fsuse%,fsavail,label,mountpoint | grep -Ev "loop"``

secours@mni25nvme:~$ lsblk -o name,fstype,size,fsused,fsuse%,fsavail,label,mountpoint | grep -Ev "loop"
NAME        FSTYPE   SIZE FSUSED FSUSE% FSAVAIL LABEL    MOUNTPOINT
sda                447,1G                                
└─sda1      ext4   447,1G    28K     0%  416,7G fix25vsy /media/secours/fix25vsy
sdb                    0B                                
nvme0n1            465,8G                                
├─nvme0n1p1 vfat     512M   6,1M     1%  504,8M          /boot/efi
└─nvme0n1p2 ext4   465,3G   123G    27%  310,6G          /

secours@mni25nvme:~$ sudo blkid
[sudo] Mot de passe de secours :       
/dev/nvme0n1p1: UUID="0441-692B" BLOCK_SIZE="512" TYPE="vfat" PARTLABEL="EFI System Partition" PARTUUID="d1ebe30b-597f-4efd-bbba-af949e61f338"
/dev/nvme0n1p2: UUID="c95f21de-cdd3-4bc6-a5e6-ef9ce01fe58b" BLOCK_SIZE="4096" TYPE="ext4" PARTUUID="df34622a-5401-49c0-af1c-1b793d1eb106"
/dev/sda1: LABEL="fix25vsy" UUID="3581b22f-678c-4acf-babe-94eb6d4377dd" BLOCK_SIZE="4096" TYPE="ext4" PARTUUID="f50c3345-01"

sudo mkdir /mnt/backup
sudo chown secours /mnt/backup
sudo mount /dev/sdb1 /mnt/backup

___

conky !!!!!!

RSYNC vitesse correcte: 40 MB/s
Asustor SMB synchro 100 MB/s max

Thunderbird:

/home/secours/.thunderbird/5si8ucbv.default-esr/

https://www.cdiscount.com/high-tech/televiseurs/toshiba-40lv2e63dg-tv-led-40-102-cm-full-h/f-1062613-tos4024862130657.html?cid=search_pla&cm_mmc=PLA!COR!!CD!17321031537!m102400825_pTOS4024862130657_l9056443_tpla-2325947134722__a140645654801&gad_source=1&gad_campaignid=17321031537&gclid=EAIaIQobChMI8tn0r--VjgMV0otoCR0pRxt8EAQYBiABEgItjPD_BwE

https://www.e.leclerc/fp/sharp-40fh2ea-tv-101-6-cm-40-full-hd-smart-tv-wifi-noir-5903802469912?et_keyword=&et_campaign=20398152464&et_device=c&et_matchtype=&utm_source=google&utm_medium=cpc&utm_campaign=FR/PMAX/SUE/High-Tech/TV&gad_source=1&gad_campaignid=18154233106&gclid=EAIaIQobChMI8tn0r--VjgMV0otoCR0pRxt8EAQYBCABEgL9j_D_BwE

https://www.electrodepot.fr/tv-image-son/television/tv-moins-de-108-cm.html?sort=Prix%20d%C3%A9croissant

40FH2EA

https://www.youtube.com/watch?v=6VlA57z_5Qo

15DES129
https://www.but.fr/produits/4024862130701/Televiseur-Full-HD-43-108cm-TOSHIBA-43LV2E63DG.html

Agathe 2025 juillet

P250675748

VieEtudes;10

VER5-WGFSZB-04

## INSTALLER KVM [LINUX MINT]

egrep -c '(vmx|svm)' /proc/cpuinfo
sudo apt update
sudo apt install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager
sudo usermod -aG libvirt $(whoami)
reboot
virsh list --all
virt-manager

## Activer le réseau en pont:
ip a
nmcli device status
### 2. Créer un pont avec NetworkManager
🧱 Étapes en interface graphique (recommandé pour Linux Mint)

    Ouvre Paramètres réseau (clic droit sur l’icône réseau dans la barre d’outils → "Paramètres réseau").

    Clique sur l’onglet "Ponts" ou "+" → Pont.

    Donne un nom au pont, par exemple br0.

    Ajoute ton interface réseau principale au pont (ex : enp3s0).

    Active DHCP ou configure une IP statique selon ton besoin.

    Applique et redémarre la connexion.

### Avec CLI
sudo nano /etc/NetworkManager/system-connections/bridge-br0.nmconnection
```
[connection]
id=bridge-br0
type=bridge
interface-name=br0
autoconnect=true

[bridge]
stp=false

[ipv4]
method=auto

[ipv6]
method=ignore

[proxy]
```
sudo systemctl restart NetworkManager

ip a

## Ajout user

ls -ld /var/lib/libvirt/images/
sudo usermod -aG libvirt secours
ls -ld /var/lib/libvirt/images/
