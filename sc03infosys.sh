#!/bin/bash

fichier="/tmp/info_machine.txt"

{
  echo "========== INFOS SYSTÈME =========="
  echo "Date              : $(date)"
  echo "Nom d'hôte        : $(hostname)"
  echo "Utilisateur       : $(whoami)"
  echo "Adresse IP        : $(hostname -I | awk '{print $1}')"
  echo "OS                : $(uname -o)"
  echo "Version du noyau  : $(uname -r)"
  echo "Uptime            : $(uptime -p)"
  echo ""
  
  echo "====== MÉMOIRE (RAM) ======"
  free -h | grep Mem | awk '{print "Utilisée : " $3 ", Libre : " $4 ", Totale : " $2}'
  echo ""

  echo "====== CPU ======"
  lscpu | grep -E '^Model name|^CPU\(s\)|^Thread|^Core|^Socket' 2>/dev/null
  echo ""

  echo "====== DISQUE ======"
  df -h --total | grep -E 'Filesystem|total'
  echo ""

  echo "====== TOP PROCESSUS (CPU) ======"
  ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -n 6
  echo ""

  echo "====== TOP PROCESSUS (RAM) ======"
  ps -eo pid,comm,%cpu,%mem --sort=-%mem | head -n 6
  echo "==================================="
} > "$fichier"

echo "Les informations détaillées ont été enregistrées dans : $fichier"
cat $fichier
