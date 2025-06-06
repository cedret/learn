#!/bin/bash

echo "🖥️  Audit Synology DSM - $(date)"
echo "===================================="

while true;
do
	echo ""
 	echo "Mois de Juin 2025"
  	echo "===== PREPARATION"
  	echo "---1 OS           ---3 Disques ---5 T° disques ---7         ---9 Volumes"
   	echo "---2 Mémoire CPU  ---4         ---6 Réseau     ---8 Disques ---10"
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
