#!/bin/bash

# === Configuration ===
NAS_LIST=(
    "access@192.168.1.207"
    "access@192.168.1.209"
    "access@192.168.1.211"
    "access@192.168.1.213"
)

SCRIPT_LOCAL="audit1nas.sh"
LOG_DIR="$HOME/logs/audit_nas"
mkdir -p "$LOG_DIR"

# === Test si le script d’audit existe ===
if [[ ! -f "$SCRIPT_LOCAL" ]]; then
    echo "❌ Script '$SCRIPT_LOCAL' introuvable. Place-le dans le même dossier."
    exit 1
fi

echo "🚀 Lancement de l'audit pour ${#NAS_LIST[@]} NAS..."

for NAS in "${NAS_LIST[@]}"; do
    IP=${NAS#*@}
    DATE_TAG=$(date +%Y-S%V)
    LOGFILE="$LOG_DIR/audit_${IP}_$DATE_TAG.log"

    echo -e "\n🔧 Audit de $NAS → $LOGFILE"
    ssh -o ConnectTimeout=10 "$NAS" 'bash -s' < "$SCRIPT_LOCAL" > "$LOGFILE" 2>&1

    if [[ $? -eq 0 ]]; then
        echo "✅ Audit de $NAS terminé avec succès."
    else
        echo "❌ Échec de l'audit de $NAS (voir $LOGFILE)."
    fi
done

echo -e "\n📦 Tous les audits sont enregistrés dans : $LOG_DIR"
