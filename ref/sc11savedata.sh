#!/bin/bash

# La fonction 7 est la plus complète à ce jour

# === Configuration ===
# Dossier local contenant les sources
SRC0BASE="/Users/access/Documents"
#SRC1BASE="/Users/access/Documents/_MNI0*"
#SRC8BASE="/Users/access/Documents/_MNI08_Sante_coll"
DST_USER="access"                       # Nom d'utilisateur distant
DST1HOST="192.168.1.207"                # IP ou hostname de la machine distante
# Chemin sur la machine distante
#DST_RSNC="/Volumes/vsy21tri2int/rsy_2506mni"
DST2RSNC="/Volumes/nfs207tri2/rsy$(date +%Ys%V)mni"
# DST2RSNC="/private/nfs207tri2/rsy_2506test"
#DST_SCP="/volume2/vsy21tri2int/scp_2505mni"
#DST_LFTP="/vsy21tri2int"
#DST_SUPP="/Volumes/vsy21tri2int/rsy$(date +%Ys%V)mni"
PSWD=""
#MNT1NFS="/private/nfs207tri2/"         # Enlever / ???
MNT2NFS="/Volumes/nfs207tri2/"
LOGFIX="$HOME/logs/savedata$(date +%Ys%V).log"
LOGFMR="$HOME/logs/savelast$(date +%Ys%V).log"
# LOGFIX="$HOME/logs/copie_$(date +%Y-S%V_%H-%M-%S).log"
# LOGFIX="savedata.log"

to_bytes() {
    local size=$1
    local num unit

    if [[ "$size" =~ ^([0-9]+(\.[0-9]+)?)([KkMmGgTt]?)$ ]]; then
        num="${BASH_REMATCH[1]}"
        unit="${BASH_REMATCH[3]}"
    else
        echo "Erreur : format de taille invalide: $size" >&2
        return 1
    fi

    echo "fonction -to_bytes- $size, $unit, $num" | tee -a "$LOGFIX"

    awk -v n="$num" -v u="$unit" '
        BEGIN {
            scale = 1
            if (u == "K" || u == "k") scale = 1024
            else if (u == "M" || u == "m") scale = 1024^2
            else if (u == "G" || u == "g") scale = 1024^3
            else if (u == "T" || u == "t") scale = 1024^4
            printf "%.0f\n", n * scale
        }
    '
}

controleflux() {
cancelled=0
if [[ ! "$confirm" =~ ^[Oo]$ ]]; then
  echo "--- Copie annulée." | tee -a "$LOGFIX"
  cancelled=1  # Marque que l'opération est annulée
fi
# Le script continue ici
if [[ $cancelled -eq 1 ]]; then
  echo "Opération annulée. Le script peut continuer avec d'autres actions."
else
  echo "La copie a été confirmée. Le script continue..."
  # Ajoutez ici la logique du script pour continuer la copie.
fi
}


function mont_nfs() {
   		echo "----- Montage NFS (MacOs)"
		echo "--- showmount -e $DST1HOST"  | tee -a "$LOGFIX"
     		showmount -e $DST1HOST
     		sudo mkdir -p $MNT2NFS
#		sudo mount -t nfs -o bg,intr,timeo=600,resvport,rw,retrans=10 $DST1HOST:/volume2/vsy21tri2int $MNT2NFS
# Avec Macos
#		sudo mount_nfs -o rw,nolock,timeo=300,retrycnt=3,resvport $DST1HOST:/volume2/vsy21tri2int $MNT2NFS
		sudo mount -t nfs -o bg,intr,timeo=600,resvport,rw,retrans=10 $DST1HOST:/volume2/vsy21tri2int $MNT2NFS
  		echo "--- df -H"
	 	df -H
		echo "--- Test montage nfs (MacOs) -$MNT2NFS-" | tee -a "$LOGFIX"
		mount | grep nfs
  		date >> "$LOGFIX"
# --exemples--
#		sudo mount -o rw -t nfs $dst1HOST:/volume2/vsy21tri2int $MNT2NFS
#		sudo mount -t nfs -o resvport,rw
#		mount -t nfs 192.168.1.50:/share/nfs /mnt/disque-nfs
#  		sudo umount /nfs/home
}

function demont_nfs() {
   		sudo umount $MNT2NFS
     		echo "----- Démontage nfs -$MNT2NFS-"  | tee -a "$LOGFIX"
}

# Fonction qui effectue une vérification et quitte si nécessaire
function check_confirmation() {
  if [[ ! "$confirm" =~ ^[Oo]$ ]]; then
    echo "--- Copie annulée." | tee -a "$LOGFIX"
    return 1  # Sort de la fonction, sans quitter le script global
  fi
}
# Appel de la fonction
check_confirmation
# Le script continue ici après la fonction, si confirm est valide
echo "Le script continue..."

echo -e "\n===== ===== DEBUT SCRIPT RSYNC ===== ATTENTION AUX CABLES RESEAU !!!!! -2025 juin-"
mkdir -p "$HOME/logs"
echo "MacOs - IP locale  : $(ipconfig getifaddr $(route get default | awk '/interface:/ {print $2}'))" && echo "IP publique : $(curl -s https://api.ipify.org)"
# echo "---------- IP : $(hostname -I)" >> rsync.log
# Vérifie que rsync est installé
if ! command -v rsync &> /dev/null; then
    echo "rsync n'est pas installé. Installe-le avec : sudo apt install rsync" | tee -a "$LOGFIX"
    exit 1
fi
echo "reset" > "$LOGFMR"
echo " - - - - - - - - - - - - - - - - - - - - $hostname" >> "$LOGFIX"
#hostname >> "$LOGFIX"
uname -a
df -H
while true;
do
	echo ""
  	echo "===== PREPARATION"
  	echo "---1 Informations ---4 Montage NFS (MacOs) ---7 Choisir source(s) + rsync"
   	echo "---2 Suite        ---5 Démontage NFS       ---8 Consulter log -fmr-"
    	echo "---3 Crontab      ---6 Montage sur Qnap    ---9 Consulter log -fix-"
  	echo "===== ===== MONTAGES"
   	echo "---91 Monter disques qnap ---92 Vérifier montages ---93 Démonter intelligent"
	echo "---94 Tout démonter       ---95 Supprimer /mnt//  ---96"
 	echo "---97                     ---98                   ---99"
	echo "===== ===== ===== RESTAURATIONS"
  	echo "---11 ---13              ---15           ---17 ---19 Choisir sauvegarde(s) + rsync"
	echo "---12 ---14 rsync/debian ---16 rsync/MBA ---18 rsync/variables"
	echo "===== ===== ===== ===== SAUVEGARDES"
 	echo "-$SRC0BASE- vers -$DST_RSNC- ou =$DST_SCP="
	echo "---21 rsync < mni(macos) ---23 scp < mni(macos) ---25 smbclient < mni(macos) ---27 lftp < mni(macos)-"
	echo "---22 rsync < mba(zorin) ---24 scp < mba(zorin) ---26 smbclient < mba(zorin) ---28"
 	echo "===== ===== ===== ===== ===== COMPARAISONS"
	echo "---31 par rsync ---32 par diff   ---33 par checksum"
  	echo "---34 simple    ---35 avec hash  ---36"
 	echo "===== ===== ===== ===== ===== ===== SUPPRESSIONS"
 	echo "---71 Supprimer avec macos/debian cible -$DST_SUPP-"
 	echo "---73 Supprimer avec debian cible -$DST_SUPP-"
   	echo "---79 Par rsync"
	echo "===== ===== ===== ===== ===== ===== ===== AUTRES"
   	echo "---91 Activité CPU du Nas	---92 Gestion des erreurs ---93 Reset log actuel"
   	echo "---94			---95			  ---96 "
     	echo "---97 Tout démonter       ---98 Ajouter dans .log   ---99 Remplacer ce script"
 	echo "===== ===== 0 pour quitter"
  	echo "--- En attente: fonctions et return!!!! (annulation) --- Coupure NFS après 12 minutes?"

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
	3)
 		echo "----- Pour programmer cycle: 0 2 * * * /path/to/backup.sh"
 		crontab -e
		;;
  	4)
		mont_nfs
		;;
  	5)
		demont_nfs
     		;;
  	6)
	  	echo "--6- Monter disques qnap -smb-" | tee -a "$LOGFIX"
 		sudo mkdir /media/secours/secu2505v1
		sudo mount /dev/sda /media/secours/secu2505v1
		sudo mkdir /media/secours/secu2505v2
		sudo mount /dev/sdb /media/secours/secu2505v2
#		Add total data transferred
#		Total Download: ${totaldown enp2s0} 
#		Total Upload: ${totalup enp2s0}
		;;
	7)
#		SOURCE_BASE="$HOME"
#		DESTINATION=$DST2RSNC
		DESTINATION="/Volumes/nfs207tri2/rsy$(date +%Ys%V)mni"

		# Lister les répertoires déjà dans destination
		echo "--- Répertoires actuels dans cible: $DESTINATION..."
		sudo ls $DESTINATION
	
		# Lister les répertoires dans $HOME
		echo "--- Répertoires dans source: $SRC0BASE..."
		DIRS=($(find "$SRC0BASE" -mindepth 1 -maxdepth 1 -type d))

		if [ ${#DIRS[@]} -eq 0 ]; then
		  echo "--- Aucun répertoire trouvé dans $SRC0BASE." | tee -a "$LOGFIX"
		  exit 1
		fi

#		for i in "${!DIRS[@]}"; do
#		for ((i = 0; i < ${#DIRS[@]}; i++)); do
#			echo "[$i] ${DIRS[$i]##*/}"
#			echo "[$(($i + 1))] ${DIRS[$i]##*/}"
#   		done

		for i in "${!DIRS[@]}"; do
  			if [ -d "${DIRS[$i]}" ]; then  # Vérifie si le répertoire existe
				sized=$(du -sh "${DIRS[$i]}" | cut -f1)  # Get the size of the directory
#	   			TAILLE3=$(du -sm "$dst" | cut -f1) # taille destination présente
				else
				sized=0
			fi
		    echo "[$i] - $sized - ${DIRS[$i]##*/}"
		done



  		echo "===== Ajouter tailles dossiers ici? ====="
		# Demander plusieurs choix
		echo -ne "\n --- Entrez les numéros des répertoires à copier (ex: 1 7 12) : [0 pour quitter]"
		read -r input

		input=$(echo "$input" | tr ',' ' ')
		indices=($input)
	 	df -H
		echo "--- Voir alternatives pour annulation"
		echo -ne "\n   Confirmer la copie ? (o/n):"
		read -r confirm

		if [[ ! "$confirm" =~ ^[Oo]$ ]]; then
		  echo "--- Copie annulée." | tee -a "$LOGFIX"
		  return 1
		fi

		if [ ! -d "$DESTINATION" ]; then
			# Créer le dossier de destination
			mkdir -p "$DESTINATION"
		fi
#		date >> $LOGFIX

		# Copier les répertoires sélectionnés avec rsync
		echo "=7= Sélection(s) pour rsync de:" | tee -a "$LOGFIX"
		for index in "${indices[@]}"; do
		  if [[ "$index" =~ ^[0-9]+$ ]] && [ "$index" -lt "${#DIRS[@]}" ]; then
			src="${DIRS[$index]}"
			dst="$DESTINATION/rsy$(basename "$src")"
			TAILLE1=$(du -sm "$src" | cut -f1)

			if [ -d "{$dst}" ]; then  # Vérifie si le répertoire existe
	   			TAILLE3=$(du -sm "$dst" | cut -f1) # taille destination présente
				else
				TAILLE3=0
			fi
			RSYNC1CMD="rsync -a --inplace --no-owner --no-group --progress --timeout=60 --stats "$src/" "$dst/" >> "$LOGFMR" 2>&1"
			TIMESTAMP1=$(date '+%Y-%m-%d %H:%M:%S')
			SECONDS=0
			echo "--- $TAILLE1 Mo --- $src ---"
			echo "--- $TAILLE3 Mo --- $dst ---"
#		    rsync -az --inplace --no-owner --no-group --progress "$src/" "$dst/"
#		    rsync -a --inplace --no-owner --no-group --progress "$src/" "$dst/" >> /path/to/LOGFIX.log 2>&1 && echo "[$(date '+%Y-%m-%d %H:%M:%S')] Copie terminée avec succès" >> /path/to/LOGFIX.log || echo "[$(date '+%Y-%m-%d %H:%M:%S')] Erreur lors de la copie" >> "$LOGFIX"
#		    rsync -a --inplace --no-owner --no-group --progress "$src/" "$dst/" >> /path/to/LOGFIX.log 2>&1 && echo "[$(date '+%Y-%m-%d %H:%M:%S')] Copie terminée avec succès. Total des fichiers transférés : $(find "$dst" -type f | wc -l)" >> /path/to/LOGFIX.log || echo "[$(date '+%Y-%m-%d %H:%M:%S')] Erreur lors de la copie" >> "$LOGFIX"
#		rsync -a --inplace --no-owner --no-group --progress "$src/" "$dst/" >> "$LOGFMR" 2>&1 && \
#			echo "[$(date '+%Y-%m-%d %H:%M:%S')] Copie terminée avec succès" >> "$LOGFIX" || \
#			echo "[$(date '+%Y-%m-%d %H:%M:%S')] Erreur lors de la copie" >> "$LOGFIX"

# version avec nombre de fichiers!
#		rsync -a --inplace --no-owner --no-group --progress "$src/" "$dst/" >> "$LOGFMR" 2>&1 && \
#  			echo "[$(date '+%Y-%m-%d %H:%M:%S')] --- ℹ ℹ Rsync sans erreur ℹ ℹ --- Total des fichiers transférés : $(find "$dst" -type f | wc -l)" | tee -a "$LOGFIX" || \
#     			echo "[$(date '+%Y-%m-%d %H:%M:%S')] --- ⚠️ ⚠️ Rsync avec erreur(s): (code $status) ⚠️ ⚠️ -----" | tee -a "$LOGFIX"
##			$RSYNC1CMD
# Lancer rsync en arrière-plan
#			rsync -av --progress --log-file="$LOGFMR" source/ dest/ &
#			rsync -av --inplace --no-owner --no-group --progress --timeout=60 --stats "$src/" "$dst/" >> "$LOGFMR" 2>&1 &
			rsync -av --whole-file --no-owner --no-group --progress --timeout=60 --stats "$src/" "$dst/" >> "$LOGFMR" 2>&1 &

   
			RSYNC_PID=$!
      			status=$?
			cycle=1
			# Affichage toutes les 60s pendant l'exécution
			while kill -0 "$RSYNC_PID" 2>/dev/null; do
   			    sleep 60
#			    echo "--- Minute $cycle --- $(date '+%Y-%m-%d %H:%M:%S') --- extraire to-check/ taille fichier(s)?"
			    ((cycle++))

				filtre=4
    				case $filtre in
					1)
#				       grep -o 'to-check=[0-9]*/[0-9]*' "$LOGFMR" | sed -E 's/to-check=([0-9]*)\/([0-9]*)/\1 \2/'

					# Extraire les 5 dernières lignes et les lignes contenant "to-check"
					tail -n 5 "$LOGFMR" | grep -oE 'to-check=[0-9]+/[0-9]+' | while read line; do
					x=$(echo $line | grep -oE '[0-9]+(?=/)' )  # Valeur x avant "/"
					y=$(echo $line | grep -oE '(?<=/)[0-9]+' )  # Valeur y après "/"
					ratio=$(echo "scale=2; $x/$y" | bc)
					echo "Ratio $x/$y = $ratio"
						done
    					;;
	 				2)
					line=$(grep -o 'to-check=[0-9]*/[0-9]*' "$LOGFMR" | tail -n 1)
					values=${line#to-check=}

					checked=${values%%/*}   # encore à faire
					total=${values##*/}     # total à faire

					prog=$((total - checked))
					percent=$(( 100 * done / total ))
					echo "Progression : $percent% ($prog sur $total fichiers traités)"
					;;
     					3)
						IFS=/ read checked total <<< $(grep -o 'to-check=[0-9]*/[0-9]*' log.txt | tail -n 1 | cut -d= -f2)
					;;
     					4)
						# Vérifie que le fichier existe
						if [[ ! -f "$LOGFMR" ]]; then
						        echo "--- Erreur : fichier '$LOGFMR' introuvable."
						        return 1
						    fi

					    # Trouve la dernière ligne contenant to-check
					    line=$(grep 'to-check=' "$LOGFMR" | tail -n 1)
#						echo "--- test --- $line"
					    # Si aucune ligne valide
					    if [[ -z "$line" ]]; then
					        echo "--- Aucune ligne contenant 'to-check=' trouvée."
					        return 1
					    fi

					    # Extraction des valeurs
#					    local values checked total prog percent
					    values=$(echo "$line" | grep -o 'to-check=[0-9]*/[0-9]*' | cut -d= -f2)
					    restf=${values%%/*}
					    totalf=${values##*/}

					    # Sécurité contre division par zéro
					    if [[ "$totalf" -eq 0 ]]; then
					        echo "Erreur : total = 0, division impossible."
					        return 1
					    fi
						prog=$((totalf - restf))
						percent=$((100 * prog / totalf))
      						estimation=$((restf * SECONDS / prog / 60))
#	    					echo "--- tests: $totalf - $restf = $prog > $percent% fait, restent $estimation minutes"
						echo "--- Sondage $cycle --- $(date '+%Y-%m-%d %H:%M:%S') --- $prog/$totalf=$percent% restent $estimation minutes"
						;;
#			    tail -n 5 "$LOGFMR" | grep -oP '(\d+%)|to-check=\d+/\d+'
#			    tail -n 5 "$LOGFMR" | grep -oE '[0-9]+%|to-check=[0-9]+/[0-9]+'
#			    tail -n 5 "$LOGFMR" | grep -oE 'to-check=[0-9]+/[0-9]+'
#			    tail -n 1 "$LOGFMR"
					esac
			done
#			rsync -av --inplace --no-owner --no-group --progress --timeout=60 --stats "$src/" "$dst/" | grep -oP 'to-check=\d+/\d+' | awk -F= '{print $2}'
#			grep -oP 'to-check=\d+/\d+' logfile.txt | awk -F= '{print $2}'
#   			grep -oP '(\d+%)|to-check=\d+/\d+' logfile.txt
#			tail -n 5 logfile.txt | grep -oP '(\d+%)|to-check=\d+/\d+'

#			rsync -a --inplace --no-owner --no-group --progress --timeout=60 --stats "$src/" "$dst/" >> "$LOGFMR" 2>&1 

			TIMESTAMP2=$(date '+%Y-%m-%d %H:%M:%S')
# Calcul vitesse data transfer
# Get the size of the source (in a human-readable format)
			TAILLE2=$(du -sm "$dst"| cut -f1)
# Extract the size part (without the human-readable unit, e.g., "5.2M")
#			SIZE1=$(echo "$TAILLE1" | cut -f1)
			SIZE1=$(echo "$TAILLE1" | awk '{print $1}')
			SIZE2=$(echo "$TAILLE2" | awk '{print $1}')
#			SIZE2=$(echo "$TAILLE2" | cut -f1)
# Convert the human-readable size into bytes
#			SIZE1BYTES=$(echo "$SIZE1" | numfmt --from=iec)
#			SIZE2BYTES=$(to_bytes $SIZE2)
#			echo "--- $SIZE2 en $SIZE2BYTES ---"
			MINUTES=$((SECONDS / 60))
#			SPEED_BPS=$((SIZE2BYTES / SECONDS))
			SPEED2BPS=$((TAILLE2 / MINUTES))
			SPEED2FPS=$((totalf / MINUTES))
   			MOYFIC=$((TAILLE2 / totalf))
#			SPEED_MBPS=$(echo "scale=2; $SPEED_BPS / 1048576" | bc)  # Convert bytes per second to MB per second
# Format and print the output
#			echo "[$TIMESTAMP2] $TAILLE transferred in $MINUTES minutes at a speed of $SPEED_MBPS MB/s" | tee -a "$LOGFIX"
# Vérification du code de sortie de rsync
			echo "--- DE [$TIMESTAMP1] - $TAILLE1 Mo ---$src" >> "$LOGFIX"
			echo "---  A [$TIMESTAMP2] - $TAILLE2 Mo ---$dst" >> "$LOGFIX"
			echo "--- $totalf fichiers en $MINUTES min, environ $MOYFIC Mo/fichier" >> "$LOGFIX"
#      			echo "[$TIMESTAMP2] $MINUTES min. à $SPEED2BPS Mo/s" | tee -a "$LOGFIX"
#			echo "$(date '+%Y-%m-%d %H:%M:%S') - Size1: $TAILLE1, Size2: $TAILLE2, Total Size: $SIZE, Duration: $MINUTES minutes, Speed: $SPEED_MBPS Mbps" | tee -a "$LOGFIX"

   			if [ $status -eq 0 ]; then
				echo "--- Vitesses moyennes: $SPEED2BPS Mo/min & $SPEED2FPS f/min" | tee -a "$LOGFIX"
				echo "--- Stats des logs" >> "$LOGFIX"
#				echo "[$TIMESTAMP2] --- ℹ ℹ Rsync en $MINUTES min. de $(find "$dst" -type f | wc -l) fichiers: $SPEED_BPS B/s" | tee -a "$LOGFIX"
#    				fichier="fichier.log"
#				tail -n 12 "$LOGFMR" >> "$LOGFIX"
				tail -n 14 "$LOGFMR" | head -n 4 >> "$LOGFIX"
			else
				echo "[$TIMESTAMP2] --- ⚠️ ⚠️  Rsync avec erreur(s): (code $status) après $MINUTES min. ⚠ ⚠" | tee -a "$LOGFIX"
#			echo "Détails de l'erreur:" >> "$LOGFIX"
				tail -n 15 "$LOGFMR" | grep -i 'error' >> "$LOGFIX"
			fi
			echo "=== Cycle terminé, démonter/remonter réseau entre chaque itération?"
#		    STATUS="Rsync vers '$dst' fini à:" 
#		    date >> $LOGFIX
#		    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
		#   rsync -avz source/ user@host:/destination/
#		    echo "Code retour rsync : $?" | tee -a "$LOGFIX"
#		    echo "$DATE0 | $STATUS [$TIMESTAMP]" >> "$LOGFIX"
#		    sudo rsync -avh --no-owner --no-group --progress $SRC0BASE $DST2RSNC
		  else
		    echo "--- Index invalide : $index (ignoré)" | tee -a "$LOGFIX"
		  fi
		done
		echo "=== Rsync terminé, voir logs pour détails."
		;;
    	8)
 		echo -e "\n ---8 Logs fmr"
		cat $LOGFMR
  		ls $HOME/logs
		;;
  	9)
 		echo -e "\n ---9 Logs fix"
		cat $LOGFIX
  		ls $HOME/logs
		;;
  	14)
 		echo "----- RESTAURATION vers DEBIAN -.207v?-"
		sudo mkdir -p /mnt/secu7test5
		sudo mount -t cifs //192.168.1.207/vsy21v4vrac /mnt/secu7test5 -o username=accesr,password=fastoche
		cd /mnt/secu7test5/
		ls -al
		pwd
		echo "----- Contenu de secu7test5"
  		echo "==> Pause : appuyez sur une touche pour continuer."
		read -n 1 -s -r  # -n 1 : lit un caractère, -s : silencieux, -r : brut
  		date >> "$LOGFIX"
		sudo rsync -av /mnt/secu7test5 /media/secours/secu2505v2
		echo "----- sudo rsync -av /mnt/secu7test5 /media/secours/secu2505v2"
		echo "----- Fin copie test vers debian à:" >> "$LOGFIX"
		date >> "$LOGFIX"
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
		date >> "$LOGFIX"
		sudo rsync -avh --progress /mnt/secu7mni01/ccc2505mni01 /home/secours/Documents/ccc2505mni01
		echo "----- sudo rsync -av /mnt/secu7mni01/ccc2505mni01 /Documents..."
		echo "----- Fin copie mni01 vers mba à:" >> "$LOGFIX"
		date >> "$LOGFIX"
		;;
  	18)
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
		date >> "$LOGFIX"
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
     		du -sh $SRC0BASE >> "$LOGFIX"
		date >> "$LOGFIX"
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
  		date >> "$LOGFIX"
		sudo rsync -avh --progress /home/secours/.thunderbird/5w2sovhl.default-release/Mail/pop.sfr.fr/ /mnt/vsy21tri2int/ccc2505test
#		sudo rsync -avh --progress /home/secours/.thunderbird/5w2sovhl.default-release/Mail/ /mnt/vsy21tri2int/ccc2505mba
		echo "----- sudo rsync -avh --progress /home/secours/.thunderbird /mnt/vsy21tri2int/ccc2505mba"
		echo "----- Fin copie mba vers ccc/wifi à:" >> savedata.log 
		date >> "$LOGFIX"
  		;;
	23)
	 	echo "23 scp depuis mni(macos) =$SRC0BASE= vers =$DST_SCP="
  		echo ">>>>> ATTENTION AU MODE DE MONTAGE DE(S) DOSSIER(S) DISTANT(S) !!!!!"
		echo "===== Pause : appuyez sur une touche pour scp ....."
		read -n 1 -s -r  # -n 1 : lit un caractère, -s : silencieux, -r : brut
  		date >> savedata.log
		scp -v -r -p $SRC0BASE $DST1HOST:$DST_SCP
  		echo "===== scp -v -r -p =$SRC0BASE =$DST1HOST:$DST_SCP" >> "$LOGFIX"
   		du -sh $SRC0BASE >> "$LOGFIX"
		echo "===== Fin à:" >> "$LOGFIX" && date >> "$LOGFIX"
  		;;
	25)
	  	echo "25 smbclient depuis mni(macos) =$SRC0BASE= vers -"
  		echo ">>>>> ATTENTION AU MODE DE MONTAGE DE(S) DOSSIER(S) DISTANT(S) !!!!!"
		echo "===== Pause : appuyez sur une touche pour scp ....."
		read -n 1 -s -r  # -n 1 : lit un caractère, -s : silencieux, -r : brut
  		date >> savedata.log
		smbclient //$DST1HOST/$DST_RSNC -U $DST_USER
#		scp -v -r -p $SOURCE_BASE $dst_HOST:$dst_SCP
  		echo "===== smbclient //$DST1HOST/$DST_RSNC -U $DST_USER" >> "$LOGFIX"
   		du -sh $SRC0BASE >> "$LOGFIX"
		echo "===== Fin à:" >> "$LOGFIX" && date >> "$LOGFIX"
  		;;
	27)
	    	echo "27 lftp depuis mni(macos) -$SRC0BASE- vers -"
  		echo ">>>>> ATTENTION AU MODE DE MONTAGE DE(S) DOSSIER(S) DISTANT(S) !!!!!"
		echo "===== Pause : appuyez sur une touche pour lftp ....."
		read -n 1 -s -r  # -n 1 : lit un caractère, -s : silencieux, -r : brut
  		date >> "$LOGFIX"
		lftp -u "$DST_USER","$PSWD" "$DST_HOST" <<EOF
		mirror -R "$SOURCE_BASE" "$dst_PATH"
		bye
EOF
  		echo "===== smbclient //$DST1HOST/$DST_LFTP -U $DST_USER" >> "$LOGFIX"
   		du -sh $SRC0BASE >> "$LOGFIX"
		echo "===== Fin à:" >> "$LOGFIX" && date >> "$LOGFIX"
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

		diff -qr "$LOCAL_DIR" "$SMB_DIR" | tee "$LOGFIX"

		echo ""
		echo "Comparaison terminée. Rapport enregistré dans : $LOGFIX"
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
    	71)
		echo "----- SUPPRESSION depuis MACOS/Debian"
		sudo ls $DST_SUPP
#		ls -al $dst_SUPP
		du -sh $DST_SUPP
    		echo ">>>>> ATTENTION AU MODE DE MONTAGE DE(S) DOSSIER(S) DISTANT(S) !!!!!"
		echo "==> Pause : appuyez sur une touche pour suppression forcée: $DST_SUPP"
		read -n 1 -s -r  # -n 1 : lit un caractère, -s : silencieux, -r : brut
#		sudo rm -r /Volumes/vsy21tri2int/ccc2506mni
  		sudo rm -rf $DST_SUPP
#    		sudo rmdir $dst_SUPP
		echo "sudo rm -rf $DST_SUPP"
		echo "----- Fin suppression $DST_SUPP:" >> "$LOGFIX"
		date >> "$LOGFIX"
		;;
	79)
 		mkdir empty_dir
		rsync -a --delete --progress empty_dir/ target_dir/
		;;
	92)
		mount | grep '^/mnt'
		;;
	83)
		for m in $(mount | awk '$3 ~ "^/mnt" {print $3}'); do
		echo "Démontage de : $m"
		sudo umount -lf "$m"
		done
		;;
	93)
		TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
		echo "--- [$TIMESTAMP] --- Reset savedata___.log" > "$LOGFIX"
   		;;
   	94)
		sudo umount -lf /mnt/*
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

	98)
 		echo "Quantité de données dupliquées ou information?"
		read donnees
  		$donness >> "$LOGFIX"
 		;;
	99)
 		cp Downloads/sc11savedata.sh . && rm Downloads/sc11savedata.sh
   		;;
	100)
 		echo "---4- Montage NFS (MacOs)"
		echo "--- showmount -e $DST1HOST"  | tee -a "$LOGFIX"
     		showmount -e $DST1HOST
     		sudo mkdir -p $MNT1NFS
		sudo mount -t nfs -o resvport,rw $DST1HOST:/volume2/vsy21tri2int $MNT1NFS
  		echo "--- df -H"
	 	df -H
		echo "--- Montage nfs -$MNT1NFS-" | tee -a "$LOGFIX"
  		date >> "$LOGFIX"
# --exemples--
#		sudo mount -o rw -t nfs $dst1HOST:/volume2/vsy21tri2int $MNT1NFS
#		sudo mount -t nfs -o resvport,rw
#		mount -t nfs 192.168.1.50:/share/nfs /mnt/disque-nfs
#  		sudo umount /nfs/home
		;;
  	0)
   		echo "Sortie script" >> "$LOGFIX"
		break
		;;
	esac
done
echo "Script terminé à:"
date
