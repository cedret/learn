#!/bin/bash

systemctl status smbd

lsblk -f
echo "----- lsblk -f /source"

df -h
echo "----- df -h /source"
sleep 3

pwd
echo "----- Montage secu7mni01"
# sudo mkdir -p /mnt/secu7mni01
# ls -al /mnt/secu7mni01
ls -al
echo "^^^^^ Contenu destination -test-"
sleep 3

# mkdir /home/secours/Documents/ccc2505mni01
ls -al /home/secours/Documents/ccc2505mni01
pwd
echo "^^^^^ Contenu source -test-"
sleep 3

echo "---------- IP : $(hostname -I)" >> listrsync
hostname >> rsync.log
date >> rsync.log 

while true;
do
	echo ""
 	echo "Mois de Juin"
  	echo "===== RESTAURATIONS"
	echo "11 rsync depuis .207 -v1-"
	echo "12 rsync depuis .207 -v2-"
	echo "13 rsync depuis .207 -v2-"
	echo "14 rsync depuis .207 -v3-"
	echo "15 rsync depuis .207 -tri4ext- environ 3h"
	echo "16 rsync depuis .207 -mni01- vers MBA"
 	echo "===== SAUVEGARDES"
	echo "21 rsync depuis mni(macos) vers ccc (eth=60Go/h?)"
 	echo "22 Supprimer sauvegarde antérieure depuis macos"
	echo "23 rsync depuis mba(zorin) vers ccc"
 	echo "29 Supprimer sauvegarde antérieure"
	echo "===== AUTRES"
 	echo "31 Monter diques qnap"
	echo "91 voir listrsync"
	echo "92 Vérifier montages"
	echo "93 Démonter intelligent"
	echo "95 Supprimer /mnt///ccc2505mba"
	echo "99 Tout démonter"
	echo " 0 pour quitter"

	read choix

	case $choix in
	15)
		sudo mkdir -p /mnt/secu7test5
		sudo mount -t cifs //192.168.1.207/vsy21v4vrac /mnt/secu7test5 -o username=accesr,password=fastoche
		cd /mnt/secu7test5/
		ls -al
		pwd
		echo "Contenu de secu7test5"
  		echo "==> Pause : appuyez sur une touche pour continuer."
		read -n 1 -s -r  # -n 1 : lit un caractère, -s : silencieux, -r : brut
		sudo rsync -av /mnt/secu7test5 /media/secours/secu2505v2
		echo "sudo rsync -av /mnt/secu7test5 /media/secours/secu2505v2"
		echo "terminé à"
		date
		;;
	16)
#		sudo mkdir -p /mnt/secu7mni01
		sudo mount -t cifs //192.168.1.207/vsy21tri2int /mnt/secu7mni01 -o username=accesr,password=difficiL3
		sudo ls -al /mnt/secu7mni01/ccc2505mni01
		pwd
		echo "^^^^^ Contenu de mnt/secu7mni01/ccc2505... rsync imminent"
		echo "==> Pause : appuyez sur une touche pour continuer."
		read -n 1 -s -r  # -n 1 : lit un caractère, -s : silencieux, -r : brut
		sudo rsync -avh --progress /mnt/secu7mni01/ccc2505mni01 /home/secours/Documents/ccc2505mni01
		echo "sudo rsync -av /mnt/secu7mni01/ccc2505mni01 /Documents..."
		echo "-Fin copie mni01 vers mba" >> rsync.log 
		date
		;;
 	21)
		echo "----- SAUVEGARDE"
    		ifconfig
		sudo mkdir -p /Volumes/vsy21tri2int
		ls /Volumes/
		sudo mount_smbfs //access@192.168.1.207/vsy21tri2int /Volumes/vsy21tri2int
		sudo ls /Volumes/vsy21tri2int
		echo "==> Pause : appuyez sur une touche pour continuer."
		read -n 1 -s -r  # -n 1 : lit un caractère, -s : silencieux, -r : brut
		sudo rsync -avh --progress /Users/access/Documents/_MNI01_Fixe /Volumes/vsy21tri2int/ccc2505mni12test
		echo "sudo rsync -av /Documents... /Volumes...-test-mni01-"
#		sudo rsync -avh --progress /Users/access/Documents/_MNI01_Fixe /Volumes/secu25dest207/mni01ccc2505/
#		echo "sudo rsync -av /Documents... /Volumes..."
		echo "----- Fin copie mni01 vers ccc/eth" >> rsync.log 
		date >> rsync.log
		;;
  	22)
		echo "----- SUPPRESSION"
    		ifconfig
		sudo mkdir -p /Volumes/vsy21tri2int
		ls /Volumes/
		sudo mount_smbfs //access@192.168.1.207/vsy21tri2int /Volumes/vsy21tri2int
		sudo ls /Volumes/vsy21tri2int
		echo "==> Pause : appuyez sur une touche pour continuer."
		read -n 1 -s -r  # -n 1 : lit un caractère, -s : silencieux, -r : brut
		sudo rsync -avh --progress /Users/access/Documents/_MNI01_Fixe /Volumes/vsy21tri2int/ccc2505mni12test
		echo "sudo rsync -av /Documents... /Volumes...-test-mni01-"
#		sudo rsync -avh --progress /Users/access/Documents/_MNI01_Fixe /Volumes/secu25dest207/mni01ccc2505/
#		echo "sudo rsync -av /Documents... /Volumes..."
		echo "----- Fin suppression depuis mni01 vers ccc" >> rsync.log 
		date >> rsync.log
		;;
   
	23)
		sudo mkdir -p /mnt/vsy21tri2int
#		sudo mount -t cifs //192.168.1.207/vsy21tri2int /mnt/vsy21tri2int -o username=access,password=illicO12
		sudo mount -t cifs //192.168.1.207/vsy21tri2int /mnt/vsy21tri2int -o username=access
		sudo ls -al /mnt/vsy21tri2int
		pwd
#		sudo mkdir /mnt/vsy21tri2int/ccc2505mba
		sudo ls /mnt/vsy21tri2int/ccc2505mba
		echo "----- Contenu de /mnt/vsy21tri2int/ccc2505mba... rsync imminent"
		df -h
		echo ""
		echo "==> Pause : appuyez sur une touche pour continuer."
		read -n 1 -s -r  # -n 1 : lit un caractère, -s : silencieux, -r : brut
		sudo rsync -avh --progress /home/secours/.thunderbird/5w2sovhl.default-release/Mail/pop.sfr.fr/ /mnt/vsy21tri2int/ccc2505test
#		sudo rsync -avh --progress /home/secours/.thunderbird/5w2sovhl.default-release/Mail/ /mnt/vsy21tri2int/ccc2505mba
		echo "----- sudo rsync -avh --progress /home/secours/.thunderbird /mnt/vsy21tri2int/ccc2505mba"
		echo "----- Fin copie mba vers ccc/wifi" >> rsync.log 
		date >> rsync.log
	31)
 		sudo mkdir /media/secours/secu2505v1
		sudo mount /dev/sda /media/secours/secu2505v1
		sudo mkdir /media/secours/secu2505v2
		sudo mount /dev/sdb /media/secours/secu2505v2
		;;
  # Add total data transferred
#		Total Download: ${totaldown enp2s0} 
#		Total Upload: ${totalup enp2s0}
		;;
	91)
		cat rsync.log
		;;

	92)
		mount | grep '^/mnt'
		;;
	93)
		for m in $(mount | awk '$3 ~ "^/mnt" {print $3}'); do
		echo "Démontage de : $m"
		sudo umount -lf "$m"
		done
		;;
	95)
		echo "sudo rm -r /mnt/vsy21tri2int/ccc2505mba/"
		sudo rm -r /mnt/vsy21tri2int/ccc2505mba/
		;;
	98)
		sudo unmount /mnt/secu7test1
		sudo unmount /mnt/secu7test2
		sudo unmount /mnt/secu7test3
		sudo unmount /mnt/secu7test4
		sudo unmount /mnt/secu7test5
		sudo unmount /mnt/vsy21tri2int

		;;
	99)
		sudo umount -lf /mnt/*
		;;

	0)
		 break
		;;
	esac
date
done
echo "Script terminé"
