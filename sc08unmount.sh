#!/bin/bash

echo "1 ------ Démontage intelligent"
for m in $(mount | awk '$3 ~ "^/mnt" {print $3}'); do
  echo "Démontage de : $m"
  sudo umount -lf "$m"
done

echo "2 ------ Détection dossiers"
for dir in /mnt/*; do
  if mountpoint -q "$dir"; then
    echo "$dir est un point de montage actif"
	ls -ld
  else
    echo "$dir n'est PAS un point de montage"
  fi
done


echo "3 ----- Nettoyage des dossiers vides non montés dans /mnt..."

for dir in /mnt/*; do
  # Vérifie si c'est un dossier
  [ -d "$dir" ] || continue

  # Vérifie s'il est un point de montage actif
  if mountpoint -q "$dir"; then
    echo "⚠️  $dir est un point de montage actif. On ne le supprime pas."
  elif [ -z "$(ls -A "$dir")" ]; then
    echo "🧹 Suppression du dossier vide : $dir"
    sudo rmdir "$dir"
  else
    echo "📁 $dir n'est pas vide. Ignoré."
  fi
done

echo "Nettoyage terminé."
echo "Vérifier droits: ls -ld /mnt/usb"
echo "Changer permissions: sudo chown $USER:$USER /mnt/usb"
