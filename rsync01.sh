#!/bin/bash

pwd
echo "----- Montage secu7mni01"
sudo mkdir -p /mnt/secu7mni01
ls -al /mnt/secu7mni01
echo "^^^^^ Contenu de mnt/secu7mni01"
sleep 5

mkdir /home/secours/Documents/ccc2505mni01
ls -al /home/secours/Documents/ccc2505mni01
pwd
echo "^^^^^ Contenu de /home... mni01"
sleep 5

df -h
echo "^^^^^ df -h"
sleep 5

lsblk -f
echo "^^^^^ lsblk -f"
sleep 5

date >> listrsync
echo "test" >> listrsync 


while true;
do
  echo "RESTAURATIONS"
	echo "11 rsync depuis .207 -v1-"
	echo "12 rsync depuis .207 -v2-"
	echo "13 rsync depuis .207 -v2-"
	echo "14 rsync depuis .207 -v3-"
	echo "15 rsync depuis .207 -tri4ext- environ 3h"
	echo "16 rsync depuis .207 -mni01- vers MBA"
  echo "SAUVEGARDES"
  echo "21 rsync vers ccc depuis mni01"
	echo "99 Tout démonter"
	echo " 0 pour quitter"

	read choix

	case $choix in
	15)
		sudo mkdir -p /mnt/secu7test5
		sudo mount -t cifs //192.168.1.207/vsy21v4vrac /mnt/secu7test5 -o username=accesr,password=difficiL3
		cd /mnt/secu7test5/
		ls -al
		pwd
		echo "Contenu de secu7test5"
		sudo rsync -av /mnt/secu7test5 /media/secours/secu2505v2
		echo "sudo rsync -av /mnt/secu7test5 /media/secours/secu2505v2"
		echo "terminé à"
		date
		;;
	16)
#		sudo mkdir -p /mnt/secu7mni01
		date >> listrsync
		echo "-Début copie mni01 vers mba" >> listrsync 
		sudo mount -t cifs //192.168.1.207/vsy21tri2int /mnt/secu7mni01 -o username=accesr,password=difficiL3
		sudo ls -al /mnt/secu7mni01/ccc2505mni01
		pwd
		echo "^^^^^ Contenu de mnt/secu7mni01/ccc2505... rsync imminent"
		sleep 10
		sudo rsync -avh --progress /mnt/secu7mni01/ccc2505mni01 /home/secours/Documents/ccc2505mni01
		echo "sudo rsync -av /mnt/secu7mni01/ccc2505mni01 /Documents..."
		echo "-Fin copie mni01 vers mba" >> listrsync 
		date >> listrsync
		date
		;;
  21)
    ifconfig
    date >> listrsync
		echo "-Début copie mni01 vers ccc" >> listrsync 
    sudo mkdir -p /Volumes/secu25dest207tri2
    ls /Volumes/
    sudo mount_smbfs //access@192.168.1.207/vsy21tri2int /Volumes/secu25dest207tri2/
    sudo ls /Volumes/secu25dest207tri2
    sudo rsync -avh --progress /Users/access/Documents/_MNI01_Fixe/miraheze /Volumes/secu25dest207/test.rep/
    sudo rsync -avh --progress /Users/access/Documents/_MNI01_Fixe /Volumes/secu25dest207/mni01ccc2505/
    echo "sudo rsync -av /Documents... /Volumes..."
		echo "-Fin copie mni01 vers ccc" >> listrsync 
		date >> listrsync
		date
		;;
	88)
		date
		sudo rsync -av /mnt/secu7mni01 /media/secours/secu2505v2
		echo "sudo rsync -av /mnt/secu7test5 /media/secours/secu2505v2"
		echo "terminé à"
		date
		;;
	99)
		sudo unmount /mnt/secu7test1
		sudo unmount /mnt/secu7test2
		sudo unmount /mnt/secu7test3
		sudo unmount /mnt/secu7test4
		sudo unmount /mnt/secu7test5
		;;
	0)
		 break
		;;
	esac
done
echo "Script fini"
