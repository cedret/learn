#!/bin/bash

# === Configuration ===
# Dossier local contenant les sources
SRC0BASE="/Users/access/Documents"
SRC1BASE="/Users/access/Documents/_MNI0*"
SRC8BASE="/Users/access/Documents/_MNI08_Sante_coll"
DST_USER="access"                       # Nom d'utilisateur distant
DST1HOST="192.168.1.207"                # IP ou hostname de la machine distante
# Chemin sur la machine distante
DST_RSNC="/Volumes/vsy21tri2int/rsy2506mni"
DST2RSNC="/private/nfs207tri2/rsy2506test"
DST_SCP="/volume2/vsy21tri2int/scp2505mni"
DST_LFTP="/vsy21tri2int"
DST_SUPP="/Volumes/vsy21tri2int/ccc2506mni"
PSWD=""
MNT1NFS="/private/nfs207tri2/"         # Enlever / ???
LOGFILE="$HOME/logs/savedata$(date +%Ys%V).log"
# LOGFILE="$HOME/logs/copie_$(date +%Y-S%V_%H-%M-%S).log"
# LOGFILE="savedata.log"
echo "===== DEBUT SCRIPT RSYNC ====="
mkdir -p "$HOME/logs"
echo "MacOs - IP locale  : $(ipconfig getifaddr $(route get default | awk '/interface:/ {print $2}'))" && echo "IP publique : $(curl -s https://api.ipify.org)"
# echo "---------- IP : $(hostname -I)" >> rsync.log
echo "" >> $LOGFILE
hostname >> $LOGFILE
uname -a
df -H
while true;
do
	echo ""
 	echo "Mois de Juin 2025"
  	echo "===== PREPARATION"
  	echo "---1 Informations ---3 ---5 Montage NFS (MacOs) ---7 Monter disques qnap ---9 Choisir source(s) + rsync"
   	echo "---2 Suite        ---4 ---6 Démontage NFS       ---8                     ---10 Incrémenter savedata.log"
	echo "===== RESTAURATIONS"
  	echo "---1 Informations ---3 ---5 Montage NFS (MacOs) ---7 Monter disques qnap ---9 Choisir sauvegarde(s) + rsync"
	echo "---14 rsync depuis .207 -v3-"
	echo "---15 rsync depuis .207 -tri4ext- environ 3h"
	echo "---16 rsync depuis .207 -mni01- vers MBA"
	echo "---19 rsync avec variables"
	echo "===== SAUVEGARDES -$SRC0BASE- vers -$DST_RSNC- ou =$DST_SCP="
	echo "---21 rsync depuis mni(macos) ---23 scp depuis mni(macos) ---25 smbclient depuis mni(macos)"
	echo "---22 rsync depuis mba(zorin) ---24 scp depuis mba(zorin) ---26 smbclient depuis mba(zorin)"
    	echo "---27 lftp depuis mni(macos)-"
	echo "===== COMPARAISONS"
	echo "---31 par rsync ---32 par diff ---33 par checksum"
  	echo "---34 simple    ---35 avec hash"
 	echo "===== SUPPRESSIONS"
 	echo "41 Supprimer depuis macos/debian cible -$DST_SUPP-"
 	echo "43 Supprimer depuis debian cible -$DST_SUPP-"
   	echo "49 Par rsync"
	echo "===== LOGS"
	echo "51 voir savedata.log"
	echo "===== AUTRES"
	echo "91 Monter disques qnap"
	echo "92 Vérifier montages"
	echo "93 Démonter intelligent"
	echo "95 Supprimer /mnt///ccc2505mba"
	echo "97 Tout démonter"
 	echo "98 ajouter quantité de données dupliquées au .log"
	echo "99 Remplacer ce script"
 	echo " 0 pour quitter"

	read choix

	case $choix in
	1)
		systemctl status smbd
		lsblk -f
		echo "----- source// lsblk -f"
#		df -h
#		echo "----- source// df -h"
		sleep 1
		# sudo mkdir -p /mnt/secu7mni01
		# ls -al /mnt/secu7mni01
		ls -al $SRC0BASE
		du -sh $SRC0BASE
		pwd
		echo "----- Contenu source -$SRC0BASE-"
		sleep 1
		# mkdir /home/secours/Documents/ccc2505mni01
		sudo ls $DST_RSNC
		echo "----- Contenu destination -$DST_RSNC-"
		sleep 1
		du -hs *
		;;
  	2)
   		ls -n /volume2/vsy21tri2int/rsy2506mni/
     		ls -ld /volume2/vsy21tri2int/rsy2506mni/
       		;;
  	5)
   		echo "---5 Montage NFS (MacOs)"
		echo "--- showmount -e $DST1HOST"  | tee -a "$LOGFILE"
     		showmount -e $DST1HOST
     		sudo mkdir -p $MNT1NFS
		sudo mount -t nfs -o resvport,rw $DST1HOST:/volume2/vsy21tri2int $MNT1NFS
  		echo "--- df -H"
	 	df -H
		echo "--- Montage nfs -$MNT1NFS-" | tee -a "$LOGFILE"
  		date >> $LOGFILE
# --exemples--
#		sudo mount -o rw -t nfs $DEST1HOST:/volume2/vsy21tri2int $MNT1NFS
#		sudo mount -t nfs -o resvport,rw
#		mount -t nfs 192.168.1.50:/share/nfs /mnt/disque-nfs
#  		sudo umount /nfs/home
		;;
  	6)
   		sudo umount $MNT1NFS
     		echo "--- Démontage nfs -$MNT1NFS-"  | tee -a "$LOGFILE"
     		;;
  	7)
	  	echo "9- Monter disques qnap -smb-" | tee -a "$LOGFILE"
 		sudo mkdir /media/secours/secu2505v1
		sudo mount /dev/sda /media/secours/secu2505v1
		sudo mkdir /media/secours/secu2505v2
		sudo mount /dev/sdb /media/secours/secu2505v2
#		Add total data transferred
#		Total Download: ${totaldown enp2s0} 
#		Total Upload: ${totalup enp2s0}
		;;
	9)
#		SOURCE_BASE="$HOME"
		DESTINATION=$DST2RSNC

		# Vérifie que rsync est installé
		if ! command -v rsync &> /dev/null; then
		    echo "rsync n'est pas installé. Installe-le avec : sudo apt install rsync" | tee -a "$LOGFILE"
		    exit 1
		fi

		# Lister les répertoires dans $HOME
		echo "Recherche des répertoires dans $SRC0BASE..."
		DIRS=($(find "$SRC0BASE" -mindepth 1 -maxdepth 1 -type d))

		if [ ${#DIRS[@]} -eq 0 ]; then
		  echo "Aucun répertoire trouvé dans $SRC0BASE." | tee -a "$LOGFILE"
		  exit 1
		fi

		# Affichage numéroté
		echo "Répertoires disponibles :"
		for i in "${!DIRS[@]}"; do
		  echo "[$i] ${DIRS[$i]##*/}"
		done

		# Demander plusieurs choix
		echo -ne "\n Entrez les numéros des répertoires à copier (ex: 0 2 4) : "
		read -r input

		input=$(echo "$input" | tr ',' ' ')
		indices=($input)
	 	df -H
		echo -ne "\n Confirmer la copie ? (o/n) : "
		read -r confirm

		if [[ ! "$confirm" =~ ^[Oo]$ ]]; then
		  echo "Copie annulée." | tee -a "$LOGFILE"
		  exit 0
		fi

		# Créer le dossier de destination
		mkdir -p "$DESTINATION"

		# Copier les répertoires sélectionnés avec rsync
		echo -e "---9 Copie des répertoires sélectionnés avec rsync..."
		date >> $LOGFILE
		for index in "${indices[@]}"; do
		  if [[ "$index" =~ ^[0-9]+$ ]] && [ "$index" -lt "${#DIRS[@]}" ]; then
		    src="${DIRS[$index]}"
		    dest="$DESTINATION/$(basename "$src")"
		    echo -e "\n Copie de '$src' vers '$dest'..." | tee -a "$LOGFILE" 
		    rsync -a --no-owner --no-group --progress "$src/" "$dest/"
#		    sudo rsync -avh --no-owner --no-group --progress $SRC0BASE $DST2RSNC
		    du -sh $src >> $LOGFILE
		  else
		    echo " Index invalide : $index (ignoré)" | tee -a "$LOGFILE"
		  fi
		done
		date >> $LOGFILE
		echo -e "\n Copie terminée avec rsync."
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
  		date >> savedata.log
		sudo rsync -av /mnt/secu7test5 /media/secours/secu2505v2
		echo "----- sudo rsync -av /mnt/secu7test5 /media/secours/secu2505v2"
		echo "----- Fin copie test vers debian à:" >> savedata.log 
		date >> $LOGFILE
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
		date >> $LOGFILE
		sudo rsync -avh --progress /mnt/secu7mni01/ccc2505mni01 /home/secours/Documents/ccc2505mni01
		echo "----- sudo rsync -av /mnt/secu7mni01/ccc2505mni01 /Documents..."
		echo "----- Fin copie mni01 vers mba à:" >> savedata.log 
		date >> $LOGFILE
		;;
  	19)
		# === Synchronisation ===
		for dir in "$SRC0BASE"/tosave*/; do
		    if [ -d "$dir" ]; then
		        echo "Synchronisation de: $dir"
		        rsync -av -e ssh "$dir" "${DST_USER}@${DST1HOST}:${DST_RSNC}/"
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
		echo "21 rsync depuis mni(macos) -$SRC0BASE- vers -$DST2RSNC-"
#    		ifconfig
#		sudo mkdir -p /Volumes/vsy21tri2int
		ls /Volumes/
#		sudo mount_smbfs //access@192.168.1.207/vsy21tri2int /Volumes/vsy21tri2int
		sudo ls $DST2RSNC
  		echo ">>>>> ATTENTION AU MODE DE MONTAGE DE(S) DOSSIER(S) DISTANT(S) !!!!!"
		echo "===== Pause : appuyez sur une touche pour rsync ....."
		read -n 1 -s -r  # -n 1 : lit un caractère, -s : silencieux, -r : brut
#--- FUSION  	rsync -av /home/user/tosave*/ /destination/
#		sudo rsync -avh --progress /Users/access/Documents/_MNI*/ /Volumes/vsy21tri2int/ccc2506mni/
#--- SSH	rsync -av -e ssh "$dir" remoteuser@remotehost:/chemin/destination/
		date >> $LOGFILE
		sudo rsync -avh --no-owner --no-group --progress $SRC0BASE $DST2RSNC
# -A TESTER-	sudo rsync -ah --info=stats source/ destination/
# -memoire-	rsync -a --no-owner --no-group source/ /private/nfs207tri2/rsy2506mni/
#		> rsync0output.log 2>&1
#  		sudo rsync -avh --progress /Users/access/Documents/_MNI1* /Volumes/vsy21tri2int/ccc2506mni/ > rsync1output.log 2>&1
#    		sudo rsync -avh --progress /Users/access/Documents/_MNI2* /Volumes/vsy21tri2int/ccc2506mni/ > rsync2output.log 2>&1
#  		echo "----- sudo rsync -avh --progress $SRC0BASE $DST2RSNC"
#		sudo rsync -avh --progress /Users/access/Documents/_MNI01_Fixe /Volumes/secu25dest207/mni01ccc2505/
#		tail -n 5 rsync0output.log >> savedata.log
# 		echo "--- tail5rsync0.log"
#		tail -n 5 rsync1output.log >> savedata.log
# 		echo "--- tail5rsync1.log"
#		tail -n 5 rsync2output.log >> savedata.log
# 		echo "--- tail5rsync2.log"
		echo "----- Fin sudo rsync -avh --no-owner --no-group --progress $SRC0BASE $DST2RSNC" >> savedata.log
     		du -sh $SRC0BASE >> $LOGFILE
		date >> $LOGFILE
  		;;
	22)
		echo "22 rsync depuis mba(zorin) vers ccc -$SRC0BASE-"
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
  		date >> $LOGFILE
		sudo rsync -avh --progress /home/secours/.thunderbird/5w2sovhl.default-release/Mail/pop.sfr.fr/ /mnt/vsy21tri2int/ccc2505test
#		sudo rsync -avh --progress /home/secours/.thunderbird/5w2sovhl.default-release/Mail/ /mnt/vsy21tri2int/ccc2505mba
		echo "----- sudo rsync -avh --progress /home/secours/.thunderbird /mnt/vsy21tri2int/ccc2505mba"
		echo "----- Fin copie mba vers ccc/wifi à:" >> savedata.log 
		date >> $LOGFILE
  		;;
	23)
	 	echo "23 scp depuis mni(macos) =$SRC0BASE= vers =$DST_SCP="
  		echo ">>>>> ATTENTION AU MODE DE MONTAGE DE(S) DOSSIER(S) DISTANT(S) !!!!!"
		echo "===== Pause : appuyez sur une touche pour scp ....."
		read -n 1 -s -r  # -n 1 : lit un caractère, -s : silencieux, -r : brut
  		date >> savedata.log
		scp -v -r -p $SRC0BASE $DST1HOST:$DST_SCP
  		echo "===== scp -v -r -p =$SRC0BASE =$DST1HOST:$DST_SCP" >> savedata.log
   		du -sh $SRC0BASE >> savedata.log
		echo "===== Fin à:" >> savedata.log && date >> savedata.log
  		;;
	25)
	  	echo "25 smbclient depuis mni(macos) =$SRC0BASE= vers -"
  		echo ">>>>> ATTENTION AU MODE DE MONTAGE DE(S) DOSSIER(S) DISTANT(S) !!!!!"
		echo "===== Pause : appuyez sur une touche pour scp ....."
		read -n 1 -s -r  # -n 1 : lit un caractère, -s : silencieux, -r : brut
  		date >> savedata.log
		smbclient //$DST1HOST/$DST_RSNC -U $DST_USER
#		scp -v -r -p $SOURCE_BASE $DEST_HOST:$DEST_SCP
  		echo "===== smbclient //$DST1HOST/$DST_RSNC -U $DST_USER" >> savedata.log
   		du -sh $SRC0BASE >> savedata.log
		echo "===== Fin à:" >> savedata.log && date >> savedata.log
  		;;
	27)
	    	echo "27 lftp depuis mni(macos) -$SRC0BASE- vers -"
  		echo ">>>>> ATTENTION AU MODE DE MONTAGE DE(S) DOSSIER(S) DISTANT(S) !!!!!"
		echo "===== Pause : appuyez sur une touche pour lftp ....."
		read -n 1 -s -r  # -n 1 : lit un caractère, -s : silencieux, -r : brut
  		date >> savedata.log
		lftp -u "$DST_USER","$PSWD" "$DST_HOST" <<EOF
		mirror -R "$SOURCE_BASE" "$DEST_PATH"
		bye
EOF
  		echo "===== smbclient //$DST1HOST/$DST_LFTP -U $DST_USER" >> savedata.log
   		du -sh $SRC0BASE >> savedata.log
		echo "===== Fin à:" >> savedata.log && date >> savedata.log
  		;;
    	31)
     		rsync -avnc --delete /Users/ton_utilisateur/Documents/dossier_local/ /Volumes/partage_smb/dossier_distant/
		;;
  	32)
   		diff -qr /Users/ton_utilisateur/Documents/dossier_local /Volumes/partage_smb/dossier_distant
		;;
  	33)
   		# Générer des listes de fichiers avec hash
		find /Users/ton_utilisateur/Documents/dossier_local -type f -exec shasum {} \; | sort > local_hashes.txt
		find /Volumes/partage_smb/dossier_distant -type f -exec shasum {} \; | sort > distant_hashes.txt

		# Comparer les deux fichiers
		diff local_hashes.txt distant_hashes.txt
		;;
    	34)
		# Répertoires à comparer
		LOCAL_DIR="/Users/ton_utilisateur/Documents/dossier_local"
		SMB_DIR="/Volumes/partage_smb/dossier_distant"

		# Vérifie si le répertoire SMB est monté
		if [ ! -d "$SMB_DIR" ]; then
		  echo "Le dossier SMB '$SMB_DIR' n'est pas monté. Monte-le d'abord."
		  exit 1
		fi

		# Log de sortie
		LOG_FILE="rapport_diff_$(date +%Y%m%d_%H%M%S).log"

		# Comparaison récursive silencieuse avec résumé
		echo "Comparaison de :"
		echo "Local : $LOCAL_DIR"
		echo "SMB   : $SMB_DIR"
		echo "---------------------------------------------"

		diff -qr "$LOCAL_DIR" "$SMB_DIR" | tee "$LOG_FILE"

		echo ""
		echo "Comparaison terminée. Rapport enregistré dans : $LOG_FILE"
		;;
  	35)
		LOCAL_DIR="/Users/ton_utilisateur/Documents/dossier_local"
		SMB_DIR="/Volumes/partage_smb/dossier_distant"
		TMP1=$(mktemp)
		TMP2=$(mktemp)

		echo "Génération des checksums SHA-1..."

		find "$LOCAL_DIR" -type f -exec shasum {} \; | sed "s|$LOCAL_DIR/||" | sort > "$TMP1"
		find "$SMB_DIR" -type f -exec shasum {} \; | sed "s|$SMB_DIR/||" | sort > "$TMP2"

		echo "Comparaison des checksums..."
		diff "$TMP1" "$TMP2" > comparaison_hashes.log

		if [ $? -eq 0 ]; then
		  echo "Tous les fichiers sont identiques !"
		else
		  echo "Des différences ont été trouvées. Voir : comparaison_hashes.log"
		fi

		# Nettoyage
		rm "$TMP1" "$TMP2"
		;;
    	41)
		echo "----- SUPPRESSION depuis MACOS/Debian"
		sudo ls $DST_SUPP
#		ls -al $DEST_SUPP
		du -sh $DST_SUPP
    		echo ">>>>> ATTENTION AU MODE DE MONTAGE DE(S) DOSSIER(S) DISTANT(S) !!!!!"
		echo "==> Pause : appuyez sur une touche pour suppression forcée: $DST_SUPP"
		read -n 1 -s -r  # -n 1 : lit un caractère, -s : silencieux, -r : brut
#		sudo rm -r /Volumes/vsy21tri2int/ccc2506mni
  		sudo rm -rf $DST_SUPP
#    		sudo rmdir $DEST_SUPP
		echo "sudo rm -rf $DST_SUPP"
		echo "----- Fin suppression $DST_SUPP:" >> savedata.log 
		date >> $LOGFILE
		;;
	39)
 		mkdir empty_dir
		rsync -a --delete --progress empty_dir/ target_dir/
		;;
	51)
 		echo -e "\n ---51 Logs"
		cat $LOGFILE
  		ls $HOME/logs
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
	96)
		sudo unmount /mnt/secu7test1
		sudo unmount /mnt/secu7test2
		sudo unmount /mnt/secu7test3
		sudo unmount /mnt/secu7test4
		sudo unmount /mnt/secu7test5
		sudo unmount /mnt/vsy21tri2int
		;;
	97)
		sudo umount -lf /mnt/*
		;;
	98)
 		echo "Quantité de données dupliquées?"
		read donnees
  		$donness >> savedata.log
 		;;
	99)
 		cp Downloads/sc02savedata.sh . && rm Downloads/sc02savedata.sh
   		;;
  	0)
		break
		;;
	esac
done
echo "Script terminé à:"
date
