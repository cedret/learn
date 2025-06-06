#!/bin/bash

echo "🖥️  Audit Synology DSM - $(date)"
echo "===================================="

while true;
do
	echo ""
 	echo "Mois de Juin 2025"
  	echo "===== PREPARATION"
  	echo "---1 Informations ---3 ---5 Montage NFS (MacOs) ---7 Monter disques qnap ---9 Choisir source(s) + rsync"
   	echo "---2 Suite        ---4 ---6 Démontage NFS       ---8                     ---10 Incrémenter savedata.log"
	echo "===== RESTAURATIONS"
  	echo "---11 ---13              ---15           ---17 ---19 Choisir sauvegarde(s) + rsync"
	echo "---12 ---14 rsync/debian ---16 rsync/MBA ---18 rsync/variables"
	echo "===== SAUVEGARDES -$SRC0BASE- vers -$DST_RSNC- ou =$DST_SCP="
	echo "---21 rsync < mni(macos) ---23 scp < mni(macos) ---25 smbclient < mni(macos) ---27 lftp < mni(macos)-"
	echo "---22 rsync < mba(zorin) ---24 scp < mba(zorin) ---26 smbclient < mba(zorin) ---28"
 	echo "===== COMPARAISONS"
	echo "---31 par rsync ---32 par diff   ---33 par checksum"
  	echo "---34 simple    ---35 avec hash"
 	echo "===== SUPPRESSIONS"
 	echo "---41 Supprimer avec macos/debian cible -$DST_SUPP-"
 	echo "---43 Supprimer avec debian cible -$DST_SUPP-"
   	echo "---49 Par rsync"
	echo "===== LOGS"
	echo "---51 voir savedata.log"
	echo "===== AUTRES"
	echo "---91 Monter disques qnap ---92 Vérifier montages ---93 Démonter intelligent"
	echo "95 Supprimer /mnt///ccc2505mba"
	echo "97 Tout démonter"
 	echo "98 ajouter quantité de données dupliquées au .log"
	echo "99 Remplacer ce script"
 	echo " 0 pour quitter"

	read choix

	case $choix in
	1)
# 🧩 Version système
echo -e "\n📌 Version DSM et noyau :"
uname -a
cat /etc/VERSION 2>/dev/null
        ;;
    2)
# 💾 Mémoire et CPU
echo -e "\n🧠 Ressources mémoire / CPU :"
uptime
free -h
echo -e "\n📈 Charge CPU :"
top -bn1 | head -n 10
        ;;
    3)
# 📦 Disques
echo -e "\n💽 Espace disque :"
df -hT | grep -v tmpfs
        ;;
    4)
echo -e "\n🧪 Santé des disques (SMART) :"
for disk in /dev/sd?; do
    echo "→ $disk :"
    /usr/syno/bin/smartctl -H "$disk" | grep -i "SMART"
done
        ;;
    5)
# 🌡️ Température disques
echo -e "\n🌡️ Température disques :"
for disk in /dev/sd?; do
    temp=$(/usr/syno/bin/smartctl -A "$disk" | grep -i temperature)
    echo "$disk → ${temp:-Temp non disponible}"
done
        ;;
    6)
# 🌐 Réseau
echo -e "\n🌐 Interfaces réseau :"
ip addr show | grep -E '^[0-9]|inet '

echo -e "\n🔌 Connexions réseau actives (ports écoutés) :"
netstat -tuln | grep LISTEN
        ;;
    7)
# 📦 Paquets DSM installés
echo -e "\n📦 Paquets DSM installés :"
synopkg list 2>/dev/null || echo "Commande synopkg indisponible pour cet utilisateur"
        ;;
    8)
# 📋 Services DSM
echo -e "\n🛠️ Services DSM en cours :"
synoservice --list 2>/dev/null || echo "Commande synoservice indisponible"
        ;;
    9)
# 📁 Volumes
echo -e "\n📁 Volumes DSM :"
/usr/syno/bin/synodisk --enum || echo "Info volume indisponible"
        ;;
    esac
done
echo -e "\n✅ Audit terminé."
