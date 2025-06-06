#!/bin/bash

echo "🖥️  Audit Synology DSM - $(date)"
echo "===================================="

# 🧩 Version système
echo -e "\n📌 Version DSM et noyau :"
uname -a
cat /etc/VERSION 2>/dev/null

# 💾 Mémoire et CPU
echo -e "\n🧠 Ressources mémoire / CPU :"
uptime
free -h
echo -e "\n📈 Charge CPU :"
top -bn1 | head -n 10

# 📦 Disques
echo -e "\n💽 Espace disque :"
df -hT | grep -v tmpfs

echo -e "\n🧪 Santé des disques (SMART) :"
for disk in /dev/sd?; do
    echo "→ $disk :"
    /usr/syno/bin/smartctl -H "$disk" | grep -i "SMART"
done

# 🌡️ Température disques
echo -e "\n🌡️ Température disques :"
for disk in /dev/sd?; do
    temp=$(/usr/syno/bin/smartctl -A "$disk" | grep -i temperature)
    echo "$disk → ${temp:-Temp non disponible}"
done

# 🌐 Réseau
echo -e "\n🌐 Interfaces réseau :"
ip addr show | grep -E '^[0-9]|inet '

echo -e "\n🔌 Connexions réseau actives (ports écoutés) :"
netstat -tuln | grep LISTEN

# 📦 Paquets DSM installés
echo -e "\n📦 Paquets DSM installés :"
synopkg list 2>/dev/null || echo "Commande synopkg indisponible pour cet utilisateur"

# 📋 Services DSM
echo -e "\n🛠️ Services DSM en cours :"
synoservice --list 2>/dev/null || echo "Commande synoservice indisponible"

# 📁 Volumes
echo -e "\n📁 Volumes DSM :"
/usr/syno/bin/synodisk --enum || echo "Info volume indisponible"

echo -e "\n✅ Audit terminé."

