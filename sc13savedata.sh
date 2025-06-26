#!/bin/bash

# La fonction 7 est la plus complète à ce jour

# === Configuration ===
# Dossier local contenant les sources

#SRC1BASE="/Users/access/Documents/_MNI0*"
#SRC8BASE="/Users/access/Documents/_MNI08_Sante_coll"

# Depuis local//macmini vers DS207
SRC1BASE="/Users/access/Documents"
DST_USER="access"                       # Nom d'utilisateur distant
DST1HOST="192.168.1.207"                # IP ou hostname de la machine distante
DST2RSNC="/Volumes/nfs207tri2/rsy$(date +%Ys%V)mni" #Cible pour rsync
MNT2NFS="/Volumes/nfs207tri2/"

# Depuis smb//macmini vers local
SRC2HOST="192.168.1.249"
SRC2MNT="/mnt/partage1smb"
SRC2BASE="/mnt/partage1smb/Documents"
SRC3BASE="/mnt/partage1smb/Documents/_MNI03_Dox_Pro"
SRC4BASE="/mnt/partage1smb/Documents/_MNI04_Dox_Crea"
SRC5BASE="/mnt/partage1smb/Documents/_MNI05_Dox_Per"
DST2HOST="/home/secours/Documents/rsy$(date +%Ys%V)"
DST2LOCAL="/home/????"
SOURCE0=""

# Chemin sur la machine distante
#DST_RSNC="/Volumes/vsy21tri2int/rsy_2506mni"
DST_SUPP="vide"

# DST2RSNC="/private/nfs207tri2/rsy_2506test"
#DST_SCP="/volume2/vsy21tri2int/scp_2505mni"
#DST_LFTP="/vsy21tri2int"
#DST_SUPP="/Volumes/vsy21tri2int/rsy$(date +%Ys%V)mni"
PSWD=""					# Mot de passe
#MNT1NFS="/private/nfs207tri2/"         # Enlever / ???

# FICHIERS LOGS
LOGFIX="$HOME/logs/savedata$(date +%Ys%V).log"
LOGFMR="$HOME/logs/savelast$(date +%Ys%V).log"
# LOGFIX="$HOME/logs/copie_$(date +%Y-S%V_%H-%M-%S).log"
# LOGFIX="savedata.log"

LIMIT1KB=1

# Déclarer un tableau vide pour liste des répertoires
declare -a sources
declare -a directories

function to_bytes() {
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

function controleflux() {
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
#check_confirmation
# Le script continue ici après la fonction, si confirm est valide
echo "--- Le script continue..."

function get_large_dirs() {
# ATTENTION AUX BLOCS DE 512 octets au lieu de 1024 (sur MacOs?) !!!!!
    local line
    limit_blocks=$((limit_kb * 2))
    while IFS= read -r line; do
        DIRS_WITH_SIZES+=("$line")
#	echo "F_Tableau: $line, $limit; $limit_kb, $limit_blocks"
    done < <(du -s "$SRC0BASE"/*/ 2>/dev/null | awk -v limit="$limit_blocks" '$1 >= limit')
}

function comparaison(){
		SOURCE=="$1"
		DEST=="$2"
		echo "--f Comparaison -$SOURCE- avec -$DEST-" | tee -a "$LOGFIX"
		rsync -avun --ignore-existing --dry-run --itemize-changes $SOURCE $DEST
}


function listesource(){
	# Dossier source
	local source_dir=$SRC2MNT
	if [[ ! -d "$source_dir" ]]; then
	    echo "--- ⚠️-ANOMALIE-⚠️ : Montage invalide"
    	exit 1
	else
		echo "--- Point de départ: $source_dir"
# Remplir le tableau avec les répertoires
		i=0
		for dir in "$source_dir"/*; do
	  	if [ -d "$dir" ]; then
	 	   sources[$i]="$dir"
		    ((i++))
		  fi
		done

	fi

# Afficher les répertoires stockés dans le tableau
#		echo "Liste des répertoires :"
#		for dir in "${directories[@]}"; do
#		  echo "$dir"
#		done

# Afficher les répertoires stockés dans le tableau avec index
	echo "--- Liste des sources:"
	for i in "${!sources[@]}"; do
	  echo "--- $i - ${sources[$i]}"
	done
# Demande à l'utilisateur de choisir un index
		read -p "--- Choisissez l'index de la source à synchroniser : " source_select

# Vérification que l'index est valide
		if [[ $source_select -ge 0 && $source_select -lt ${#sources[@]} ]]; then
		  SOURCE0="${sources[$source_select]}"
		else
			echo "---  ⚠️ ⚠️ ANOMALIE  ⚠️ ⚠️ ---"
		fi
}


function listedossier(){
	# Dossier source
#	local source_dir=$SRC2BASE
	local source_dir=$SOURCE0
	echo "--- Source actuelle: $source_dir"

# Remplir le tableau avec les répertoires
	i=0
	for dir in "$source_dir"/*; do
	  if [ -d "$dir" ]; then
	    directories[$i]="$dir"
	    ((i++))
	  fi
	done

# Afficher les répertoires stockés dans le tableau
#		echo "Liste des répertoires :"
#		for dir in "${directories[@]}"; do
#		  echo "$dir"
#		done

# Afficher les répertoires stockés dans le tableau avec index
	echo "--- Liste des répertoires :"
	for i in "${!directories[@]}"; do
	  echo "--- $i - ${directories[$i]}"
	done
}




# if [ -d "$dossier" ] && [ -n "$(ls -A "$dossier")" ]; then

function bloc5go() {
local
SOURCE_DIR="$1"
DEST_DIR="$2"
LIMIT_GB="${3:-5}"  # seuil en Go
LIMIT_KB=$((LIMIT_GB * 1000000))

echo "=== function bloc5go"

if [[ ! -d "$SOURCE_DIR" ]]; then
    echo "--- Erreur : dossier source invalide"
    exit 1
fi

mkdir -p "$DEST_DIR"

echo "--- Recherche des sous-répertoires > ${LIMIT_GB} Go dans : $SOURCE_DIR"
echo

# Lister les répertoires à copier

while IFS= read -r line; do
    DIRS_TO_COPY+=("$line")
done < <(
    find "$SOURCE_DIR" -mindepth 1 -maxdepth 1 -type d |
    while read -r dir; do
        size_kb=$(du -sk "$dir" 2>/dev/null | cut -f1)
        [[ $size_kb -ge $LIMIT_KB ]] && echo "$dir"
    done
)
#mapfile -t DIRS_TO_COPY < <(
#    find "$SOURCE_DIR" -mindepth 1 -maxdepth 1 -type d |
#    while read -r dir; do
#        size_kb=$(du -sk "$dir" 2>/dev/null | cut -f1)
#        [[ $size_kb -ge $LIMIT_KB ]] && echo "$dir"
#    done
#)

# Afficher chaque ligne du tableau
		echo "--- Affiche tableau"
  		for ligne in "${DIRS_TO_COPY[@]}"; do
  			echo "Ligne: $ligne"
		done

total=${#DIRS_TO_COPY[@]}
#if [[ $total -eq 0 ]]; then
#    echo "--- Aucun répertoire > ${LIMIT_GB} Go trouvé."
#    exit 0
#fi

echo "--- $total sous-répertoire(s) à copier."

# Chronomètre global
start_time=$(date +%s)
copied=0

for dir in "${DIRS_TO_COPY[@]}"; do
    copied=$((copied + 1))
    base=$(basename "$dir")
    size_h=$(du -sh "$dir" 2>/dev/null | cut -f1)

    # Calcul du temps écoulé et estimation
    now=$(date +%s)
    elapsed=$((now - start_time))
    if (( copied > 1 )); then
        avg_time=$((elapsed / (copied - 1)))
        remaining=$((avg_time * (total - copied + 1)))
# linux
#       eta=$(date -ud "@$remaining" +%T)
# macos
		eta=$(date -ur "$remaining" +%T)
        echo
        echo "--- Estimation bloc actuel, encore ~$eta"
    fi

    echo
    echo "--- [$copied / $total] $base ($size_h) → $DEST_DIR/$base" | tee -a "$LOGFIX"

#    rsync -a --progress "$dir/" "$DEST_DIR/$base/"
	rsync -av --whole-file --no-owner --no-group --progress --timeout=60 --stats "$dir/" "$DEST_DIR/$base/" >> "$LOGFMR" 2>&1 &
	RSYNC_PID=$!
	status=$?
	progression
    echo "--- Copie achevée --- $base"
done

# Fin
end_time=$(date +%s)
total_time=$((end_time - start_time))

# linux
# duration=$(date -ud "@$total_time" +%T)
# macos
duration=$(date -ur "@$total_time" +%T)

echo
echo "--- Total copié : $copied répertoire(s)"
echo "--- Temps total : $duration"
}

function progression(){
# FONCTION PROGRESSION   
			# Affichage toutes les 60s pendant l'exécution
			local cycle=0
			local values restf totalf prog percent estimation
			while kill -0 "$RSYNC_PID" 2>/dev/null; do
   			    sleep 10
#			    echo "--- Minute $cycle --- $(date '+%Y-%m-%d %H:%M:%S') --- extraire to-check/ taille fichier(s)?"
			    ((cycle++))
			# FOrmats d'affichage possibles
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
						        echo "--- ⚠️ ⚠️ ANOMALIE : fichier '$LOGFMR' introuvable." | tee -a "$LOGFIX"
						        return 1
						    fi

					    # Trouve la dernière ligne contenant to-check
					    line=$(grep 'to-check=' "$LOGFMR" | tail -n 1)
#						echo "--- test --- $line"
					    # Si aucune ligne valide
					    if [[ -z "$line" ]]; then
					        echo "--- ⚠️ ⚠️ Aucune ligne contenant 'to-check=' trouvée." | tee -a "$LOGFIX"
					        return 1
					    fi

					    # Extraction des valeurs
#					    local values checked total prog percent
					    values=$(echo "$line" | grep -o 'to-check=[0-9]*/[0-9]*' | cut -d= -f2)
					    restf=${values%%/*}
					    totalf=${values##*/}

					    # Sécurité contre division par zéro
					    if [[ "$totalf" -eq 0 ]]; then
					        echo "--- ⚠️ ⚠️ ANOMALIE : total = 0, division impossible." | tee -a "$LOGFIX"
					        return 1
					    fi
						prog=$((totalf - restf))
						percent=$((100 * prog / totalf))
      					estimation=$((restf * SECONDS / prog))
#	    				echo "--- tests: $totalf - $restf = $prog > $percent% fait, restent $estimation minutes"
						echo "--- Sondage $cycle --- $(date '+%Y-%m-%d %H:%M:%S') --- $prog/$totalf=$percent% restent $estimation secondes"
					;;
#			    tail -n 5 "$LOGFMR" | grep -oP '(\d+%)|to-check=\d+/\d+'
#			    tail -n 5 "$LOGFMR" | grep -oE '[0-9]+%|to-check=[0-9]+/[0-9]+'
#			    tail -n 5 "$LOGFMR" | grep -oE 'to-check=[0-9]+/[0-9]+'
#			    tail -n 1 "$LOGFMR"
					esac
			done
# FIN FONCTION PROGRESSION
}

echo -e "\n===== ===== DEBUT SCRIPT RSYNC ===== ATTENTION AUX CABLES RESEAU !!!!! -2025 juin-"
echo "===== ===== ET A L'ECONOMIE D'ENERGIE/ ECRAN/ DISQUES DU CLIENT !!!!!!"
mkdir -p "$HOME/logs"
# echo "MacOs - IP locale  : $(ipconfig getifaddr $(route get default | awk '/interface:/ {print $2}'))" && echo "IP publique : $(curl -s https://api.ipify.org)"
echo "--- IP locale : $(ip addr show $(ip route | awk '/default/ {print $5}') | grep inet | awk '{ print $2 }' | cut -d/ -f1)"
echo "--- IP : $(hostname -I)" >> "$LOGFIX"
hostname
cat /etc/os-release
# Vérifie que rsync est installé
if ! command -v rsync &> /dev/null; then
    echo "rsync n'est pas installé. Installe-le avec : sudo apt install rsync" | tee -a "$LOGFIX"
    exit 1
fi
echo "reset" > "$LOGFMR"
echo " - - - - - - - - - - - - - - - - - - - - " >> "$LOGFIX" # $hostname
hostname >> "$LOGFIX"
echo " - - - - - - - - - - - - - - - - - - - - " >> "$LOGFIX" # $hostname
uname -a
df -H
while true;
do
	echo ""
  	echo "-$SRC0BASE- vers -$DST_RSNC- ou =$DST_SCP="
  	echo "===== PREPARATION"
  	echo "--1 Informations --4 Montage NFS [MacOs] --7 Choisir source(s) + rsync [MacOs]"
   	echo "--2 Suite        --5 Démontage NFS       --8 Choisir source(s) [LMint]"
    echo "--3 Crontab      --6 Montage sur Qnap    --9 "
  	echo "===== ===== MONTAGES & TESTS"
   	echo "--11 Vérifier montages    --14                     --17 Montage smb:MacOs depuis local"
	echo "--12 Tout démonter        --15 Supprimer /mnt//    --18 "
 	echo "--13 Démonter intelligent --16 Démontages ???      --19 "
	echo "===== ===== ===== (RESTAURATIONS) ----- Tests de macmini vers LM -----"
  	echo "--31 rsync/debian    --34 Test rsync MacOs >> local  -37 Rsync ciblé"
	echo "--32 rsync/MBA       --35 Lister répertoires sources -38 Rsync global"
 	echo "--33 rsync/variables --36 Comparaison rsync          -39 Rsync progressif"
	echo "===== ===== ===== ===== SAUVEGARDES"
	echo "--41 rsync << mni(macos) --44 scp << mba(zorin)       --47 lftp < mni(macos)-"
	echo "--42 rsync << mba(zorin) --45 smbclient << mni(macos) --48"
 	echo "--43 scp << mni(macos)   --46 smbclient << mba(zorin) --49"
 	echo "===== ===== ===== ===== ===== COMPARAISONS"
	echo "--51 par rsync    -54 simple    -57"
	echo "--52 par diff     -55 avec hash -58"
	echo "--53 par checksum -56           -59"
 	echo "===== ===== ===== ===== ===== ===== SUPPRESSIONS"
 	echo "--71 Supprimer avec macos/debian cible -$DST_SUPP-"
 	echo "--72 Supprimer avec debian cible -$DST_SUPP-"
   	echo "--73 Par rsync"
	echo "===== ===== ===== ===== ===== ===== ===== AUTRES"
   	echo "--91 Activité CPU du Nas  --94 Consulter log -fmr- --97 Tester commande"
   	echo "--92 Gestion des erreurs  --95 Consulter log -fix- --98 Ajouter dans .log"
	echo "--93 Reset log actuel     --96 Anomalies?          --99 Remplacer ce script"
 	echo "===== ===== 0 pour quitter"
 	echo "=====  ⚠️ - ATTENTION AUX OPTIONS & TELECHARGEMENT - ⚠️ !!!!!"
 	
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
		SRC0BASE=$SRC1BASE
		LIMIT_GB=100
#		SOURCE_BASE="$HOME"
		DESTINATION=$DST2RSNC
#		DESTINATION="/Volumes/nfs207tri2/rsy$(date +%Ys%V)mni"

		echo -e "\n==7 Rsync du contenu: $SRC0BASE ---" | tee -a "$LOGFIX"

# Choix du tri
		echo "--- Affichage des répertoires source(s):"
		echo "--- 1) Par nom"
		echo "--- 2) Par taille"
		echo "--- 3) Par date de modification"
		echo "--- Limite actuelle de découpage des copies: $LIMIT_GB Go" | tee -a "$LOGFIX"
		read -p "--- Choisissez le mode de tri [1-3, défaut=2] : " sort_mode
		sort_mode=${sort_mode:-2}

# Demander taille limite
		read -p "--- Choisir les répertoires de plus de combien de ko ? [défaut = 1000] : " size_limit_kb
		size_limit_gb=${size_limit_gb:-1}  # valeur par défaut : 1 Go
#		limit_kb=$((size_limit_gb * 1000000))  # conversion Go → kilo-octets
		limit_kb=${size_limit_kb:-1000}
		echo "La lmite actuelle est $limit_kb ko"

# Trouver et filtrer les répertoires dépassant la taille limite
#		mapfile -t DIRS_WITH_SIZES < <(du -s "$SRC0BASE"/*/ 2>/dev/null | awk -v limit="$limit_kb" '$1 >= limit')
		echo "--1: Création DIRS_WITH_SIZES() avec fonction 'get_large_dirs'"
		DIRS_WITH_SIZES=()

# Version pour MacOs
		get_large_dirs
  
#		while IFS= read -r line; do
#		    DIRS_WITH_SIZES+=("$line")
# 		    echo "Tableau: $line, $limit, $limit_kb"
#		done < <(du -s "$SRC0BASE"/*/ 2>/dev/null | awk -v limit="$limit_kb" '$1 >= limit')

  		echo "--2: Vérification: Chaque ligne de 'DIRS_WITH_SIZES'"
#  		for ligne in "${DIRS_WITH_SIZES[@]}"; do
# 			echo "Ligne: $ligne"
#		done

#		echo "--- Etape2a: # nombre de lignes?"
#		echo "${#DIRS_WITH_SIZES[@]}"
#		echo "--- Etape2b: tout sur une ligne"
#		echo "${DIRS_WITH_SIZES[@]}"
#		echo "--- Etape2c: première ligne"
# 		echo "${DIRS_WITH_SIZES}"

# Trouver et filtrer les répertoires > 1 Go
#		mapfile -t DIRS_WITH_SIZES < <(du -s "$SRC0BASE"/*/ 2>/dev/null | awk '$1 >= 1000000')
# Afficher chaque ligne tu tableau
#		echo "--- Etape2d: Chaque ligne?"
#  		for ligne in "${DIRS_WITH_SIZES[@]}"; do
#  			echo "Ligne: $ligne"
#		done

		echo "--3: résultat non vide?"
		if [[ ${#DIRS_WITH_SIZES[@]} -eq 0 ]]; then
		    echo "--- ⚠ ⚠ Aucun répertoire de plus de $size_limit_gb Go trouvé. ⚠ ⚠"
#		    exit 0
		    exit 1
		fi
  

		DIRS=()
		SIZES=()
		sorted=()

# Extraire chemins et tailles
		echo "--4: Extraction chemins et tailles"
		for entry in "${DIRS_WITH_SIZES[@]}"; do
		    size_kb=$(awk '{print $1}' <<< "$entry")
		    path=$(awk '{print $2}' <<< "$entry")
		    DIRS+=("$path")
		    SIZES+=("$size_kb")
		done
  
		echo "--5: Sort mode"
# Tri
		case "$sort_mode" in
		    2)
# par taille croissante -n, ou décroissante -nr
			while IFS= read -r line; do
			    sorted+=("$line")
			done < <(for i in "${!DIRS[@]}"; do echo "${SIZES[$i]}|${DIRS[$i]}"; done | sort -nr)
# décroissant si
#			sort -nr
			echo "--- case 2"
#		        mapfile -t sorted < <(for i in "${!DIRS[@]}"; do echo "${SIZES[$i]}|${DIRS[$i]}"; done | sort -nr)
		        ;;
		    3)
# par date
			while IFS= read -r line; do
			    sorted+=("$line")
			done < <(for i in "${!DIRS[@]}"; do echo "$(stat -c '%Y' "${DIRS[$i]}")|${DIRS[$i]}"; done | sort -nr)

#		        mapfile -t sorted < <(for i in "${!DIRS[@]}"; do echo "$(stat -c '%Y' "${DIRS[$i]}")|${DIRS[$i]}"; done | sort -nr)
			echo "--- case 3"
	  		;;
		    *)
# par nom
			echo "--- case *"
   			while IFS= read -r line; do
			    sorted+=("$line")
			done < <(for dir in "${DIRS[@]}"; do echo "$dir"; done | sort | awk '{print "|" $0}')
#		        mapfile -t sorted < <(for dir in "${DIRS[@]}"; do echo "$dir"; done | sort | awk '{print "|" $0}')
		        ;;
		esac
# Afficher chaque ligne tu tableau

		echo "--6: Ré-assembler DIRS"
# mapfile -t DIRS < <(command) remplacer avec:
# DIRS=()
# while IFS= read -r line; do
#    DIRS+=("$line")
# done < <(command)

# Réassembler DIRS depuis le tri
		DIRS=()
		for line in "${sorted[@]}"; do
		    path="${line#*|}"
		    DIRS+=("$path")
#		    echo "$path - $DIRS"
		done
  
		echo "--7: Affichage taille source"
# Affichage avec taille lisible
		for ((i = 0; i < ${#DIRS[@]}; i++)); do
  		    path="${DIRS[$i]%/}" #supprime /
		    dir_name="${path##*/}" #extrire nom dossier
#		    dir_name="${DIRS[$i]##*/}"
		    size=$(du -sh "${DIRS[$i]}" 2>/dev/null | cut -f1)
#		    echo "[$((i))] ($size) $dir_name"
		    echo "[$((i))] ($size) $dir_name"
		done

		echo -e "\n--8: Affichage état destination"
		# Lister les répertoires déjà dans destination
  		if [ ! -d "$DESTINATION" ]; then
  			echo "---  ⚠ ⚠ Répertoire(s) cible(s) manquant(s) ⚠ ⚠"
			echo "Créer le dossier cible: $DESTINATION" | tee -a "$LOGFIX"
			mkdir -p "$DESTINATION"
		fi
		echo "--- Répertoires actuels dans cible: $DESTINATION..."
		sudo ls $DESTINATION


#		echo "--- Répertoires dans source: $SRC0BASE..."
#		DIRS=($(find "$SRC0BASE" -mindepth 1 -maxdepth 1 -type d))

# Affiche la liste avec index et taille
#		for ((i = 0; i < ${#DIRS[@]}; i++)); do
#		    dir_name="${DIRS[$i]##*/}"
#		    dir_path="${DIRS[$i]}"
#		    size=$(du -sh "$dir_path" 2>/dev/null | cut -f1)
#		    echo "[$((i + 1))] $dir_name ($size)"
#		done
#		liste=()
		# Demande de sélection
		echo -ne "\n--- Entrez les numéros des répertoires à copier (ex: 1 7 12), * pour tout sélectionner, vide (ou -) pour quitter : "
		read -r liste
		liste=$(echo "$liste" | tr ',' ' ')  # remplace les virgules par des espaces

  		echo "--9: Transformation en array"
		# Gérer les options
		if [[ "$liste" == "-" ]]; then
		    echo "---  ⚠ ⚠ Abandon ⚠ ⚠  "
		    exit 0
		elif [[ "$liste" == "*" || "$liste" == "all" ]]; then
		    # sélectionne tout
		    indices=($(seq 1 ${#DIRS[@]}))
		    echo "---  ⚠ ⚠  SELECTION INTEGRALE  ⚠ ⚠ ---" | tee -a "$LOGFIX"
		else
		    # sélection personnalisée
		    indices=($liste)
		fi

		item_count=$(echo "$liste" | tr ',' ' ' | wc -w)

		# Affichage des choix
		echo "-10: Disques existants :"
		for idx in "${indices[@]}"; do
		    # Vérifie que l'index est valide
		    if (( idx >= 1 && idx <= ${#DIRS[@]} )); then
		        echo " - ${DIRS[$((idx - 1))]##*/}"
		    else
		        echo "---  ⚠ ⚠ Index invalide : $idx"
		    fi
		done
  
	 	df -H
#		echo "--- Voir alternatives pour annulation"
#		echo -ne "\n   Confirmer la copie ? (o/n):"
#		read -r confirm

#		if [[ ! "$confirm" =~ ^[Oo]$ ]]; then
#		  echo "--- Copie annulée." | tee -a "$LOGFIX"
#		  return 1
#		fi
		echo "-11: Vérification/création cible"

#		date >> $LOGFIX

		# Copier les répertoires sélectionnés avec rsync
		echo "-12: Sélection(s) de ${#indices[@]} source(s) pour rsync" | tee -a "$LOGFIX"
		for index in "${indices[@]}"; do
		  if [[ "$index" =~ ^[0-9]+$ ]] && [ "$index" -lt "${#DIRS[@]}" ]; then
			src="${DIRS[$index]}"
			dst="$DESTINATION/rsy$(basename "$src")"

			if [ ! -d "$src" ]; then      # src absent?
				echo "---  ⚠ ⚠ Anomalie avec --- $src" | tee -a "$LOGFIX"
			elif [ -z "$(ls -A $src)" ]; then
				echo "---  ⚠ ⚠ Pas de contenu dans --- $src" | tee -a "$LOGFIX"
			else
				TAILLE1=$(du -sm "$src" | cut -f1)
				if [ -d "$dst" ]; then  # Vérifie si le répertoire existe
#				if [ -d "{$dst}" ]; then  # Vérifie si le répertoire existe
		   			TAILLE3=$(du -sm "$dst" | cut -f1) # taille destination présente
					else
					TAILLE3=0
				fi

#			    rsync -az --inplace --no-owner --no-group --progress "$src/" "$dst/"
#			    rsync -a --inplace --no-owner --no-group --progress "$src/" "$dst/" >> /path/to/LOGFIX.log 2>&1 && echo "[$(date '+%Y-%m-%d %H:%M:%S')] Copie terminée avec succès" >> /path/to/LOGFIX.log || echo "[$(date '+%Y-%m-%d %H:%M:%S')] Erreur lors de la copie" >> "$LOGFIX"
#		    	rsync -a --inplace --no-owner --no-group --progress "$src/" "$dst/" >> /path/to/LOGFIX.log 2>&1 && echo "[$(date '+%Y-%m-%d %H:%M:%S')] Copie terminée avec succès. Total des fichiers transférés : $(find "$dst" -type f | wc -l)" >> /path/to/LOGFIX.log || echo "[$(date '+%Y-%m-%d %H:%M:%S')] Erreur lors de la copie" >> "$LOGFIX"
#				rsync -a --inplace --no-owner --no-group --progress "$src/" "$dst/" >> "$LOGFMR" 2>&1 && \
#				echo "[$(date '+%Y-%m-%d %H:%M:%S')] Copie terminée avec succès" >> "$LOGFIX" || \
#				echo "[$(date '+%Y-%m-%d %H:%M:%S')] Erreur lors de la copie" >> "$LOGFIX"

# version avec nombre de fichiers!
#				rsync -a --inplace --no-owner --no-group --progress "$src/" "$dst/" >> "$LOGFMR" 2>&1 && \
#  				echo "[$(date '+%Y-%m-%d %H:%M:%S')] --- ℹ ℹ Rsync sans erreur ℹ ℹ --- Total des fichiers transférés : $(find "$dst" -type f | wc -l)" | tee -a "$LOGFIX" || \
#     			echo "[$(date '+%Y-%m-%d %H:%M:%S')] --- ⚠️ ⚠️ Rsync avec erreur(s): (code $status) ⚠️ ⚠️ -----" | tee -a "$LOGFIX"
##				$RSYNC1CMD
# Lancer rsync en arrière-plan
#				rsync -av --progress --log-file="$LOGFMR" source/ dest/ &
#				rsync -av --inplace --no-owner --no-group --progress --timeout=60 --stats "$src/" "$dst/" >> "$LOGFMR" 2>&1 &

# Calculate the size of src in bytes
#			    SOURCE_SIZE_BYTES
#			    SOURCE_SIZE_BYTES=$(du -sb "$src" | awk '{ print $1 }')
# Convert the size from bytes to gigabytes
#			    SOURCE_SIZE_GB
#			    SOURCE_SIZE_GB=$(echo "scale=2; $SOURCE_SIZE_BYTES / (1024*1024*1024)" | bc)

#				RSYNC1CMD="rsync -a --inplace --no-owner --no-group --progress --timeout=60 --stats "$src/" "$dst/" >> "$LOGFMR" 2>&1"

				TIMESTAMP1=$(date '+%Y-%m-%d %H:%M:%S')
				SECONDES=1
				echo "--- $TAILLE1 Mo --- $src ---"
				echo "--- $TAILLE3 Mo --- $dst ---"


# FILTRAGE PAR TAILLE
# Calculate the size of src in kilobytes
			    SOURCE_SIZE_KB=$(du -sk "$src" | awk '{ print $1 }')
# Convert the size from kilobytes to gigabytes
			    SOURCE_SIZE_GB=$(echo "scale=2; $SOURCE_SIZE_KB / (1024*1024)" | bc)

			    echo "-13 TEST: Source directory size: $SOURCE_SIZE_GB GB (LIMIT = $LIMIT_GB GB)"



# COMMANDES ESSENTIELLES:

# Check if the size exceeds the limit
			    if (( $(echo "$SOURCE_SIZE_GB > $LIMIT_GB" | bc -l) )); then
			        echo "--- Source directory size > $LIMIT_GB GB, copies découpées"
			        echo "--- Rsync découpé de $src " | tee -a "$LOGFIX"
# Rsync des fichiers immédiats
		    	    rsync -avm --whole-file --stats --include='*/' --include='*' --exclude='*' --no-owner --no-group --progress --timeout=60 "$src/" "$dst/" >> "$LOGFMR" 2>&1 &
			        bloc5go $src $dst 0
			    else
####				if [[ $src -ne 0 ]]; then
#					if [ ! -d "$src" ]; then
#						echo "--- $src refusé" | tee -a "$LOGFIX"
#					elif [ -z "$(ls -A $src)" ]; then
#						echo "--- $src vide" | tee -a "$LOGFIX"
#					else
				    echo "--- Source directory size < $LIMIT_GB GB, copie en un seul bloc"
					rsync -av --whole-file --no-owner --no-group --progress --timeout=60 --stats "$src/" "$dst/" >> "$LOGFMR" 2>&1 &
					RSYNC_PID=$!
	      			status=$?
	      			progression
#	    	  		fi
			    fi



#				rsync -av --inplace --no-owner --no-group --progress --timeout=60 --stats "$src/" "$dst/" | grep -oP 'to-check=\d+/\d+' | awk -F= '{print $2}'
#				grep -oP 'to-check=\d+/\d+' logfile.txt | awk -F= '{print $2}'
#   			grep -oP '(\d+%)|to-check=\d+/\d+' logfile.txt
#				tail -n 5 logfile.txt | grep -oP '(\d+%)|to-check=\d+/\d+'
#				rsync -a --inplace --no-owner --no-group --progress --timeout=60 --stats "$src/" "$dst/" >> "$LOGFMR" 2>&1 
#				TOTALR=$(ls -l $DESTINATION| grep -v '^d' | wc -l)
				TOTALR=$(find $dst -type f | wc -l | awk '{print $1}')
				TIMESTAMP2=$(date '+%Y-%m-%d %H:%M:%S')
# Calcul vitesse data transfer
# Get the size of the source (in a human-readable format)
				TAILLE2=$(du -sm "$dst"| cut -f1)
# Extract the size part (without the human-readable unit, e.g., "5.2M")
#				SIZE1=$(echo "$TAILLE1" | cut -f1)
				SIZE1=$(echo "$TAILLE1" | awk '{print $1}')
				SIZE2=$(echo "$TAILLE2" | awk '{print $1}')
#				SIZE2=$(echo "$TAILLE2" | cut -f1)
# Convert the human-readable size into bytes
#				SIZE1BYTES=$(echo "$SIZE1" | numfmt --from=iec)
#				SIZE2BYTES=$(to_bytes $SIZE2)
#				echo "--- $SIZE2 en $SIZE2BYTES ---"
				MINUTES=$((SECONDES / 60))
#				SPEED_BPS=$((SIZE2BYTES / SECONDES))
				SPEED2BPS=$((TAILLE2 / SECONDES * 60))
				SPEED2FPS=$((TOTALR / SECONDES * 60))
   				MOYFIC=$((TAILLE2 / TOTALR))
#				SPEED_MBPS=$(echo "scale=2; $SPEED_BPS / 1048576" | bc)  # Convert bytes per second to MB per second
# Format and print the output
#				echo "[$TIMESTAMP2] $TAILLE transferred in $MINUTES minutes at a speed of $SPEED_MBPS MB/s" | tee -a "$LOGFIX"
# Vérification du code de sortie de rsync
				echo "--- DE [$TIMESTAMP1] - $TAILLE1 Mo ---$src" | tee -a "$LOGFIX"
				echo "---  A [$TIMESTAMP2] - $TAILLE2 Mo ---$dst" | tee -a "$LOGFIX"
				echo "--- $TOTALR fichiers en $MINUTES min, environ $MOYFIC Mo/fichier" | tee -a "$LOGFIX"
#      			echo "[$TIMESTAMP2] $MINUTES min. à $SPEED2BPS Mo/s" | tee -a "$LOGFIX"
#				echo "$(date '+%Y-%m-%d %H:%M:%S') - Size1: $TAILLE1, Size2: $TAILLE2, Total Size: $SIZE, Duration: $MINUTES minutes, Speed: $SPEED_MBPS Mbps" | tee -a "$LOGFIX"

	   			if [ $status -eq 0 ]; then
					echo "--- Vitesses moyennes: $SPEED2BPS Mo/min & $SPEED2FPS f/min" | tee -a "$LOGFIX"
					echo "--- Stats des logs" >> "$LOGFIX"
#					echo "[$TIMESTAMP2] --- ℹ ℹ Rsync en $MINUTES min. de $(find "$dst" -type f | wc -l) fichiers: $SPEED_BPS B/s" | tee -a "$LOGFIX"
#    				fichier="fichier.log"
#					tail -n 12 "$LOGFMR" >> "$LOGFIX"
					tail -n 14 "$LOGFMR" | head -n 4 >> "$LOGFIX"
				else
					echo "[$TIMESTAMP2] --- ⚠️ ⚠️ Rsync avec erreur(s): (code $status) après $MINUTES min." | tee -a "$LOGFIX"
#					echo "Détails de l'erreur:" >> "$LOGFIX"
					tail -n 15 "$LOGFMR" | grep -i 'error' >> "$LOGFIX"
				fi
			fi
#		    STATUS="Rsync vers '$dst' fini à:" 
#		    date >> $LOGFIX
#		    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
#			rsync -avz source/ user@host:/destination/
#		    echo "Code retour rsync : $?" | tee -a "$LOGFIX"
#		    echo "$DATE0 | $STATUS [$TIMESTAMP]" >> "$LOGFIX"
#		    sudo rsync -avh --no-owner --no-group --progress $SRC0BASE $DST2RSNC
		  else
		    echo "--- ⚠️ ⚠️ Index invalide : $index (ignoré) ---" | tee -a "$LOGFIX"
		  fi
		done
		echo "=== Rsync terminé, voir logs pour détails ===" | tee -a "$LOGFIX"
		;;
	8)
		echo "--8"
		listesource
		;;
	11)
		mount | grep '^/mnt'
		echo "--- 		mount | grep '^/mnt'"
		df -h
		echo "--- df -h"
		;;
   	12)
		sudo umount -lf /mnt/*
		echo "-12 démontage partitions" | tee -a "$LOGFIX"
		df -h
		;;
	13)
		for m in $(mount | awk '$3 ~ "^/mnt" {print $3}'); do
		echo "Démontage de : $m"
		sudo umount -lf "$m"
		done
		;;
	15)
		echo "sudo rm -r /mnt/vsy21tri2int/ccc2505mba/"
		sudo rm -r /mnt/vsy21tri2int/ccc2505mba/
		;;
	16)
		sudo unmount /mnt/secu7test1
		sudo unmount /mnt/secu7test2
		sudo unmount /mnt/secu7test3
		sudo unmount /mnt/secu7test4
		sudo unmount /mnt/secu7test5
		sudo unmount /mnt/vsy21tri2int
		;;
	17)
		echo "-17 Montage smb:MacOs depuis LM" | tee -a "$LOGFIX"
# SRC2HOST="192.168.1.249"
# SRC2BASE="/mnt/partage1smb/Documents/ZOUT"
# DST2HOST="/home/secours/Documents/backup/"

# Montage de la source
#	smb://mini14.local/access/

# Dossier local de montage
		MONTAGE=$SRC2MNT

# Crée le dossier s’il n’existe pas
		sudo mkdir -p "$MONTAGE"

# Monte le partage Samba
		sudo mount -t cifs //mini14.local/access "$MONTAGE" \
		  -o credentials=/home/$USER/.smbcredentials,uid=$UID,gid=$(id -g),iocharset=utf8,nounix,vers=3.0

# Vérifier si l'erreur spécifique est survenue
		if [ $? -ne 0 ]; then
			echo "Échec de connexion: Vérifier les paramètres et les cables..."
		else
			df -h
			ls $MONTAGE
		fi

# mount //mini14.local/partage /mnt/point_de_montage 2>&1 | grep -i "could not resolve address" && echo "Échec de connexion"

# sudo mount -t cifs //192.168.1.100/partage /mnt/smb -o username=ton_utilisateur,password=ton_motdepasse

		;;
	18)

		;;
  	31)
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
	32)
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
  	33)
		# === Synchronisation ===
		for dir in "$SRC0BASE"/tosave*/; do
		    if [ -d "$dir" ]; then
		        echo "Synchronisation de: $dir"
		        rsync -av -e ssh "$dir" "${DST_USER}@${DST1HOST}:${DST_RSNC}/"
		    else
		        echo "--- ⚠️ ⚠️ Aucun dossier correspondant trouvé: $dir"
		    fi
		done

  		for dir in /Users/access/Documents/_MNI04*;
  			do
#			rsync -avh --progress -e ssh "$dir" access@192.168.1.207:/vsy21tri2int/ccc2506mni/
   			sudo rsync -avh --progress "$dir" /Volumes/vsy21tri2int/ccc2506mni/
			done
		;;

	34)
		echo "-34 Test rsync MacOs vers LM" | tee -a "$LOGFIX"
		SOURCE0=$SRC2BASE
		DEST0=$DST2HOST
		echo "--- Test rsync depuis: $SOURCE0"
		ls $SOURCE0
		echo "Résultat de ls $SOURCE0"
  		echo "==> Pause : appuyez sur une touche pour continuer."
		read -n 1 -s -r  # -n 1 : lit un caractère, -s : silencieux, -r : brut
  		date >> "$LOGFIX"
# Le sudo créé des blocages?
#		sudo rsync -avh --progress $MONTAGE/Documents/ZOUT/ /home/secours/Musique/test25mni15/
		rsync -av --progress $SOURCE0 $DEST0

		echo "----- sudo rsync -av $SOURCE0/Documents/ZOUT"
		echo "----- Fin copie test vers debian à:" >> "$LOGFIX"
		date >> "$LOGFIX"
  		;;

	35)
		echo "-35 Liste des répertoires" | tee -a "$LOGFIX"
# Dossier source
		source_dir=$SRC2BASE

# Remplir le tableau avec les répertoires
		i=0
		for dir in "$source_dir"/*; do
		  if [ -d "$dir" ]; then
		    directories[$i]="$dir"
		    ((i++))
		  fi
		done

# Afficher les répertoires stockés dans le tableau
#		echo "Liste des répertoires :"
#		for dir in "${directories[@]}"; do
#		  echo "$dir"
#		done

# Afficher les répertoires stockés dans le tableau avec index
		echo "Liste des répertoires :"
		for i in "${!directories[@]}"; do
		  echo "Index $i : ${directories[$i]}"
		done
		;;
  	36)
		comparaison
		;;

	37)
		echo "-37 Rsync sélection répertoire" | tee -a "$LOGFIX"
		SOURCE0=$SRC2BASE
		DEST0=$DST2HOST
		listedossier

#		echo "--- Liste des répertoires :"
#		for i in "${!directories[@]}"; do
#		  echo "Index $i : ${directories[$i]}"
#		done

# Demande à l'utilisateur de choisir un index
		read -p "--- Choisissez l'index du répertoire à synchroniser : " chosen_index

# Vérification que l'index est valide
		if [[ $chosen_index -ge 0 && $chosen_index -lt ${#directories[@]} ]]; then
		  src="${directories[$chosen_index]}"
			echo "--- RSYNC $src vers $DEST0/$(basename "$src")/ ?"
			echo "--- touche clavier pour rsync"
			read -n 1 -s -r  # -n 1 : lit un caractère, -s : silencieux, -r : brut
# Commande rsync
			rsync -av --progress "$src" "$DEST0"
#			rsync -av --progress "$src" "$DEST0/$(basename "$src")"
		else
		  echo "--- Index invalide. Veuillez choisir un index valide."
		fi

# Vérification
		echo 
		read -p "--- Voulez-vous comparer $src & $DEST0/$(basename "$src") ? (entrée pour continuer)" choix

		if [ -z "$choix" ]
		then
		    echo "--- \$choix is empty"
			rsync -avun --ignore-existing --dry-run --itemize-changes "$src" "$DEST0"
#		      comparaison "$src" "$DEST0/"
#		      comparaison "$src" "$DEST0/$(basename "$src")/"
		else
		    echo "--- \$choix is NOT empty - Sans comparaison -"
		fi
		;;
	38)
		echo "-38 Rsync global" | tee -a "$LOGFIX"
		listesource
# Dossier source
		dir=$SOURCE0

# Dossier de destination
		dst=$DST2HOST		
		dstici=$dst/$(basename "$dir")

		echo "-----     -----     -----     -----     -----     -----     -----" | tee -a "$LOGFIX"
		echo "--1 variables globales - $dir - $dst -"
		echo "--2 variables locales -  - $dstici -"
		echo "--3 Entrée pour continuer " choix
		read -n 1 -s -r  # -n 1 : lit un caractère, -s : silencieux, -r : brut

			if [ ! -d "$dstici" ]; then
				TIMESTAMP1=$(date '+%Y-%m-%d %H:%M:%S')
	   			echo "--4 La destination est absente, création de $dstici"
	   			mkdir -p "$dstici"
				echo "--5 $TIMESTAMP1 Rsync -$dir- vers -$dst-..." | tee -a "$LOGFIX"
				rsync -a --info=progress2 "$dir" "$dst"
			else
				echo "--7 Destination existe et contient:"
				ls "$dstici"
				read -p "--8 Répeter rsync ? Entrée pour continuer - sinon sauter" choix
					if [ -z "$choix" ]
					then
						rsync -a --info=progress2 "$dir" "$dst"
					fi
			fi
		echo "-99 Rsync global fini."
		;;
	39)
		echo "-39 Rsync progressif" | tee -a "$LOGFIX"
#  		echo "==> Pause : Entrée pour continuer"

# Dossier source
		source_dir=$SRC2BASE

# Dossier de destination
		dst=$DST2HOST

		listedossier

# Variable de controle
		stop=0

# Déclarer un tableau pour les répertoires
#		declare -a directories

# Remplir le tableau avec les répertoires
#		i=0
#		for dir in "$source_dir"/*; do
#		  if [ -d "$dir" ]; then
#		    directories[$i]="$dir"
#		    ((i++))
#		  fi
#		done

# Boucle sur chaque répertoire et exécuter rsync
		for dir in "${directories[@]}"; do
			dstici=$dst/$(basename "$dir")
			echo "-----     -----     -----     -----     -----     -----     -----" | tee -a "$LOGFIX"
			echo "--1 variables fixes - $source_dir - $dst -"
			echo "--2 variables boucle - $stop - $dir - $dstici -"
			read -p "-2b Entrée pour continuer - sinon sauter" choix
#		read -n 1 -s -r  # -n 1 : lit un caractère, -s : silencieux, -r : brut
			if [ -z "$choix" ]
			then
				stop=0
			else
				stop=1
			fi

				if [ "$stop" -eq 1 ]; then
			        echo "--3 Interruption"
	        		break
	        	else
	    
	# Utilisation de rsync pour synchroniser chaque répertoire vers le dossier de destination
#						if [ -d "$dest" ] && [ -z "$(ls -A "$dest")" ]; then
#						if [ -d "$dstici" ] && [ -z "$(ls -A "$dstici")" ]; then
						if [ ! -d "$dstici" ]; then
							TIMESTAMP1=$(date '+%Y-%m-%d %H:%M:%S')
			    			echo "--4 La destination est absente, création de $dstici"
			    			mkdir -p "$dstici"
#							ls "$dstici"
							echo "--5 $TIMESTAMP1 Rsync -$dir- vers -$dst-..." | tee -a "$LOGFIX"
#							rsync -a --progress "$dir/" "$dst/"
							rsync -a --info=progress2 "$dir" "$dst"
							if [ $? -ne 0 ]; then
	      						echo "--6 Erreur avec $dir, ANOMALIE"
#						    	stop=1  # Pour arrêter la boucle
							fi
						else
							echo "--7 Destination existe et contient:"
							ls "$dstici"
							read -p "-7b Répeter rsync ? Entrée pour continuer - sinon sauter" choix
							if [ -z "$choix" ]
							then
								rsync -a --info=progress2 "$dir" "$dst"
							fi
						fi
	# Vérification	
						echo 
						read -p "--8 Voulez-vous comparer $dir & $dstici/ ? Entrée pour continuer - sinon sauter" choix

						if [ -z "$choix" ]
						then
					    	echo "--9 \$choix is empty - étape suivante - COMPARAISON -"
							rsync -avun --ignore-existing --dry-run --itemize-changes "$dir" "$dst"
#			      comparaison "$src" "$DEST0/"
#			      comparaison "$src" "$DEST0/$(basename "$src")/"
						else
						    echo "-10 \$choix is NOT empty - étape postérieure -"
						fi
#					read -p "-11 Rsync avec répertoire suivant? Entrée pour continuer - sinon stop" choix
#					if [ -z "$choix" ]
#					then
#						echo "-12 Rsync suivant"
#					else
#				        echo "-13 Arrêt des Rsync"
#				        stop=1
#	        		fi
				fi
		done

		echo "-99 Rsync progressif fini."
		;;

 	41)
# Choisir sauvegarde(s) + rsync
		echo "-41 rsync depuis mni(macos) -$SRC0BASE- vers -$DST2RSNC-"
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
	42)
		echo "-42 rsync depuis mba(zorin) vers ccc -$SRC0BASE-"
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
	43)
	 	echo "-43 scp depuis mni(macos) =$SRC0BASE= vers =$DST_SCP="
  		echo ">>>>> ATTENTION AU MODE DE MONTAGE DE(S) DOSSIER(S) DISTANT(S) !!!!!"
		echo "===== Pause : appuyez sur une touche pour scp ....."
		read -n 1 -s -r  # -n 1 : lit un caractère, -s : silencieux, -r : brut
  		date >> savedata.log
		scp -v -r -p $SRC0BASE $DST1HOST:$DST_SCP
  		echo "===== scp -v -r -p =$SRC0BASE =$DST1HOST:$DST_SCP" >> "$LOGFIX"
   		du -sh $SRC0BASE >> "$LOGFIX"
		echo "===== Fin à:" >> "$LOGFIX" && date >> "$LOGFIX"
  		;;
	45)
	  	echo "-45 smbclient depuis mni(macos) =$SRC0BASE= vers -"
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
	47)
	    	echo "-47 lftp depuis mni(macos) -$SRC0BASE- vers -"
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
    	51)
     		rsync -avnc --delete /Users/ton_utilisateur/Documents/dossier_local/ /Volumes/partage_smb/dossier_distant/
		;;
  	52)
   		diff -qr /Users/ton_utilisateur/Documents/dossier_local /Volumes/partage_smb/dossier_distant
		;;
  	53)
   		# Générer des listes de fichiers avec hash
		find /Users/ton_utilisateur/Documents/dossier_local -type f -exec shasum {} \; | sort > local_hashes.txt
		find /Volumes/partage_smb/dossier_distant -type f -exec shasum {} \; | sort > distant_hashes.txt

		# Comparer les deux fichiers
		diff local_hashes.txt distant_hashes.txt
		;;
    	54)
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
  	55)
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
		echo "-71 SUPPRESSION destination depuis MACOS/Debian"
		sudo ls $DST_SUPP
#		ls -al $dst_SUPP
		du -sh $DST_SUPP
    	echo ">>>>> ATTENTION AU MODE DE MONTAGE SI DOSSIER(S) DISTANT(S) !!!!!"
		echo "==> Pause : appuyez sur une touche pour suppression forcée: $DST_SUPP"
		read -n 1 -s -r  # -n 1 : lit un caractère, -s : silencieux, -r : brut
#		sudo rm -r /Volumes/vsy21tri2int/ccc2506mni
  		sudo rm -rf $DST_SUPP
#    		sudo rmdir $dst_SUPP
		echo "sudo rm -rf $DST_SUPP"
		echo "-71 Fin suppression $DST_SUPP:" >> "$LOGFIX"
		date >> "$LOGFIX"
		;;
	72)
		DST_SUPP=$DST2HOST
		echo "-72 SUPPRESSION $DST_SUPP depuis "
		sudo ls $DST_SUPP
#		ls -al $dst_SUPP
		du -sh $DST_SUPP
    	echo ">>>>> ATTENTION AU MODE DE MONTAGE SI DOSSIER(S) DISTANT(S) !!!!!"
		echo "==> Pause : appuyez sur une touche pour suppression forcée: $DST_SUPP"
		read -n 1 -s -r  # -n 1 : lit un caractère, -s : silencieux, -r : brut
#		sudo rm -r /Volumes/vsy21tri2int/ccc2506mni
  		sudo rm -rf $DST_SUPP
#    		sudo rmdir $dst_SUPP
		echo "sudo rm -rf $DST_SUPP"
		echo "-72 Fin suppression $DST_SUPP:" >> "$LOGFIX"
		date >> "$LOGFIX"
		;;
	73)
 		mkdir empty_dir
		rsync -a --delete --progress empty_dir/ target_dir/
		;; 
	93)
		TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
		echo "--- [$TIMESTAMP] --- Reset savedata___.log" > "$LOGFIX"
   		;;
    94)
 		echo -e "\n---8 Afficher Logs fmr"
		cat $LOGFMR
  		ls $HOME/logs
		;;
  	95)
 		echo -e "\n---9 Afficher logs fix"
		cat $LOGFIX
  		ls $HOME/logs
		;;
	96)
	  	echo "-- En attente: Fonctions et return!!!! (annulation)"
  		echo "-- En attente: Coupure NFS après 12 minutes: Economie OS client?"
	  	echo "-- ANOMALIE: blog5go ajoute des copies dans d'autres cibles"
  		echo "-- ANOMALIE: Pourquoi -10 est vide ???"
  		;;
  	97)
		echo "$DST2RSNC"
		find $DST2RSNC -type f | wc -l | awk '{print $1}'
#		TOTALR=$(ls -l $DESTINATION| grep -v '^d' | wc -l)
		echo "$TOTALR"
		;;
	98)
 		echo "Quantité de données dupliquées ou information?"
		read donnees
  		$donness >> "$LOGFIX"
 		;;
	99)
 		cp Downloads/sc12savedata.sh . && rm Downloads/sc12savedata.sh
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
   		echo "--- Break script" >> "$LOGFIX"
		break
		;;
	esac
done
echo "Script terminé à:"
date
