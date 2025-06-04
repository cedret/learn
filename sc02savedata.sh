#!/bin/bash

# === Configuration ===
SOURCE_BASE="/Users/access/Documents/"                  # Dossier local contenant les tosave*
DEST_USER="access"                       # Nom d'utilisateur distant
DEST_HOST="192.168.1.207"                       # IP ou hostname de la machine distante
DEST_PATH="/Volumes/vsy21tri2int/"              # Chemin sur la machine distante
DEST_SUPP="/Volumes/vsy21tri2int/ccc2506mni"
echo "===== DEBUT SCRIPT RSYNC ====="
echo "MacOs - IP locale  : $(ipconfig getifaddr $(route get default | awk '/interface:/ {print $2}'))" && echo "IP publique : $(curl -s https://api.ipify.org)"
# echo "---------- IP : $(hostname -I)" >> rsync.log
hostname >> rsync.log
date >> rsync.log 

while true;
do
	echo ""
 	echo "Mois de Juin 2025"
  	echo "1 Informations"
   	echo "===== RESTAURATIONS"
	echo "11 rsync depuis .207 -v1-"
	echo "12 rsync depuis .207 -v2-"
	echo "13 rsync depuis .207 -v2-"
	echo "14 rsync depuis .207 -v3-"
	echo "15 rsync depuis .207 -tri4ext- environ 3h"
	echo "16 rsync depuis .207 -mni01- vers MBA"
	echo "19 rsync avec variables"
	echo "===== SAUVEGARDES"
	echo "21 rsync depuis mni(macos) vers ccc (eth=60Go/h?) -$SOURCE_BASE-"
	echo "22 rsync depuis mba(zorin) vers ccc -$SOURCE_BASE-"
 	echo "23 scp depuis mni(macos) vers ccc -$SOURCE_BASE-"
  	echo "24 scp depuis mba(zorin) vers ccc -$SOURCE_BASE-"
 	echo "25 smbclient depuis mni(macos) vers ccc -$SOURCE_BASE-"
  	echo "26 smbclient depuis mba(zorin) vers ccc -$SOURCE_BASE-"
	echo "===== SUPPRESSIONS"
 	echo "31 Supprimer depuis macos/debian cible -$DEST_SUPP-"
 	echo "33 Supprimer depuis debian cible -$DEST_SUPP-"
   	echo "39 Par rsync"
	echo "===== LOGS"
	echo "51 voir rsync.log"
	echo "===== AUTRES"
	echo "91 Monter disques qnap"
	echo "92 Vérifier montages"
	echo "93 Démonter intelligent"
	echo "95 Supprimer /mnt///ccc2505mba"
	echo "98 Tout démonter"
 	echo "99 ajouter quantité de données dupliquées au .log"
	echo " 0 pour quitter"

	read choix

	case $choix in
	1)
		systemctl status smbd
		lsblk -f
		echo "----- source// lsblk -f"
		df -h
		echo "----- source// df -h"
		sleep 1
		# sudo mkdir -p /mnt/secu7mni01
		# ls -al /mnt/secu7mni01
		ls -al $SOURCE_BASE
		du -sh $SOURCE_BASE
		pwd
		echo "----- Contenu source -$SOURCE_BASE-"
		sleep 1
		# mkdir /home/secours/Documents/ccc2505mni01
		sudo ls $DEST_PATH
		echo "----- Contenu destination -$DEST_PATH-"
		sleep 1
		;;
	15)
 		echo "----- RESTAURATION vers DEBIAN -.207v?-"
		sudo mkdir -p /mnt/secu7test5
		sudo mount -t cifs //192.168.1.207/vsy21v4vrac /mnt/secu7test5 -o username=accesr,password=fastoche
		cd /mnt/secu7test5/
		ls -al
		pwd
		echo "----- Contenu de secu7test5"
  		echo "==> Pause : appuyez sur une touche pour continuer."
		read -n 1 -s -r  # -n 1 : lit un caractère, -s : silencieux, -r : brut
		sudo rsync -av /mnt/secu7test5 /media/secours/secu2505v2
		echo "----- sudo rsync -av /mnt/secu7test5 /media/secours/secu2505v2"
		echo "----- Fin copie test vers debian à:" >> rsync.log 
		date >> rsync.log
		;;
	16)
		echo "----- RESTAURATION vers DEBIAN -mni01-"
#		sudo mkdir -p /mnt/secu7mni01
		sudo mount -t cifs //192.168.1.207/vsy21tri2int /mnt/secu7mni01 -o username=accesr,password=difficiL3
		sudo ls -al /mnt/secu7mni01/ccc2505mni01
		pwd
		echo "^^^^^ Contenu de mnt/secu7mni01/ccc2505... rsync imminent"
		echo "==> Pause : appuyez sur une touche pour continuer."
		read -n 1 -s -r  # -n 1 : lit un caractère, -s : silencieux, -r : brut
		sudo rsync -avh --progress /mnt/secu7mni01/ccc2505mni01 /home/secours/Documents/ccc2505mni01
		echo "----- sudo rsync -av /mnt/secu7mni01/ccc2505mni01 /Documents..."
		echo "----- Fin copie mni01 vers mba à:" >> rsync.log 
		date >> rsync.log
		;;
  	19)
		# === Synchronisation ===
		for dir in "$SOURCE_BASE"/tosave*/; do
		    if [ -d "$dir" ]; then
		        echo "Synchronisation de: $dir"
		        rsync -av -e ssh "$dir" "${DEST_USER}@${DEST_HOST}:${DEST_PATH}/"
		    else
		        echo "----- Aucun dossier correspondant trouvé: $dir"
		    fi
		done

  		for dir in /Users/access/Documents/_MNI04*;
  			do
#			rsync -avh --progress -e ssh "$dir" access@192.168.1.207:/vsy21tri2int/ccc2506mni/
   			sudo rsync -avh --progress "$dir" /Volumes/vsy21tri2int/ccc2506mni/
			done
		;;
 	21)
		echo "----- SAUVEGARDE depuis MACOS -mni*//tri2/ccc2506-"
#    		ifconfig
#		sudo mkdir -p /Volumes/vsy21tri2int
		ls /Volumes/
#		sudo mount_smbfs //access@192.168.1.207/vsy21tri2int /Volumes/vsy21tri2int
		sudo ls /Volumes/vsy21tri2int
  		echo ">>>>> ATTENTION AU MODE DE MONTAGE DE(S) DOSSIER(S) DISTANT(S) !!!!!"
		echo "===== Pause : appuyez sur une touche pour rsync en ssh ....."
		read -n 1 -s -r  # -n 1 : lit un caractère, -s : silencieux, -r : brut
#--- FUSION  	rsync -av /home/user/tosave*/ /destination/
#		sudo rsync -avh --progress /Users/access/Documents/_MNI*/ /Volumes/vsy21tri2int/ccc2506mni/
#--- SSH	rsync -av -e ssh "$dir" remoteuser@remotehost:/chemin/destination/
		sudo rsync -avh --progress /Users/access/Documents/_MNI0* /Volumes/vsy21tri2int/ccc2506mni/ > rsync0output.log 2>&1
#  		sudo rsync -avh --progress /Users/access/Documents/_MNI1* /Volumes/vsy21tri2int/ccc2506mni/ > rsync1output.log 2>&1
#    		sudo rsync -avh --progress /Users/access/Documents/_MNI2* /Volumes/vsy21tri2int/ccc2506mni/ > rsync2output.log 2>&1
  		echo "----- sudo rsync -avh --progress /Users/access/Documents/_MNI0* /Volumes/vsy21tri2int/ccc2506mni/"
#		sudo rsync -avh --progress /Users/access/Documents/_MNI01_Fixe /Volumes/secu25dest207/mni01ccc2505/
#		echo "sudo rsync -av /Documents... /Volumes..."
#		rsync --stats source/ destination/ >> rsync.log
		tail -n 5 rsync0output.log >> rsync.log
  		echo "--- tail5rsync0.log"
		tail -n 5 rsync1output.log >> rsync.log
  		echo "--- tail5rsync1.log"
		tail -n 5 rsync2output.log >> rsync.log
  		echo "--- tail5rsync2.log"
		echo "----- Fin copie $SOURCE_BASE vers $DEST_PATH /eth à:" >> rsync.log
		date >> rsync.log
  		;;
	22)
		echo "22 rsync depuis mba(zorin) vers ccc -$SOURCE_BASE-"
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
		echo "----- Fin copie mba vers ccc/wifi à:" >> rsync.log 
		date >> rsync.log
  		;;
	23)
	 	echo "23 scp depuis mni(macos) vers ccc -$SOURCE_BASE-"
		ls /Volumes/
		sudo ls $DEST_PATH
  		echo ">>>>> ATTENTION AU MODE DE MONTAGE DE(S) DOSSIER(S) DISTANT(S) !!!!!"
		echo "===== Pause : appuyez sur une touche pour scp -0 -r ....."
		read -n 1 -s -r  # -n 1 : lit un caractère, -s : silencieux, -r : brut
		scp -v -r $SOURCE_BASE/MNI0* $DEST_HOST:$DEST_PATH
#		sudo rsync -avh --progress /Users/access/Documents/_MNI0* /Volumes/vsy21tri2int/ccc2506mni/ > rsync0output.log 2>&1
  		echo "----- sudo rsync -avh --progress /Users/access/Documents/_MNI0* /Volumes/vsy21tri2int/ccc2506mni/"
		tail -n 5 rsync0output.log >> rsync.log
  		echo "--- tail5rsync0.log"
		echo "----- Fin copie $SOURCE_BASE vers $DEST_PATH /eth à:" >> rsync.log
		date >> rsync.log
  		;;
    	31)
		echo "----- SUPPRESSION depuis MACOS/Debian"
		sudo ls $DEST_SUPP
#		ls -al $DEST_SUPP
		du -sh $DEST_SUPP
    		echo ">>>>> ATTENTION AU MODE DE MONTAGE DE(S) DOSSIER(S) DISTANT(S) !!!!!"
		echo "==> Pause : appuyez sur une touche pour suppression forcée: $DEST_SUPP"
		read -n 1 -s -r  # -n 1 : lit un caractère, -s : silencieux, -r : brut
#		sudo rm -r /Volumes/vsy21tri2int/ccc2506mni
  		sudo rm -rf $DEST_SUPP
#    		sudo rmdir $DEST_SUPP
		echo "sudo rm -rf $DEST_SUPP"
		echo "----- Fin suppression $DEST_SUPP:" >> rsync.log 
		date >> rsync.log
		;;
	39)
 		mkdir empty_dir
		rsync -a --delete --progress empty_dir/ target_dir/
		;;
	51)
		cat rsync.log
		;;

	91)
	  	echo "51 Monter disques qnap"
 		sudo mkdir /media/secours/secu2505v1
		sudo mount /dev/sda /media/secours/secu2505v1
		sudo mkdir /media/secours/secu2505v2
		sudo mount /dev/sdb /media/secours/secu2505v2
#		Add total data transferred
#		Total Download: ${totaldown enp2s0} 
#		Total Upload: ${totalup enp2s0}
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
	97)
		sudo unmount /mnt/secu7test1
		sudo unmount /mnt/secu7test2
		sudo unmount /mnt/secu7test3
		sudo unmount /mnt/secu7test4
		sudo unmount /mnt/secu7test5
		sudo unmount /mnt/vsy21tri2int
		;;
	98)
		sudo umount -lf /mnt/*
		;;
	99)
 		echo "Quantité de données dupliquées?"
		read donnees
  		$donness >> rsync.log
 		;;
	 0)
		break
		;;
	esac
done
echo "Script terminé à:"
date
