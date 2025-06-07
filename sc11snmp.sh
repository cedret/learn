#!/bin/bash

# Configuration
NAS_IP="192.168.1.107"       # IP de ton NAS
COMMUNITY="maison"           # Communauté SNMP
SNMPV="2c"            # Version SNMP

OID_IDLE=".1.3.6.1.4.1.2021.11.9.0"
OID_USER=".1.3.6.1.4.1.2021.11.11.0"
OID_SYSTEM=".1.3.6.1.4.1.2021.11.10.0"

# Contrôle des débits réseau (interface 1 par défaut — à adapter si nécessaire)
IF_INDEX=1
OID_IN="1.3.6.1.2.1.2.2.1.10.${IF_INDEX}"
OID_OUT="1.3.6.1.2.1.2.2.1.16.${IF_INDEX}"

# Fonction d'affichage
function display {
    echo "=== $1 ==="
    echo "$2"
    echo
}
echo "Mesures SNMP $SNMPV de $NAS_IP"
while true;
do
	date

 	# Lire les octets à t0
	IN1=$(snmpget -v$SNMPV -c $COMMUNITY $NAS_IP $OID_IN -Ovq)
	OUT1=$(snmpget -v$SNMPV -c $COMMUNITY $NAS_IP $OID_OUT -Ovq)
 
 	# Nom d'hôte
        HOSTNAME=$(snmpget -v$SNMPV -c $COMMUNITY $NAS_IP 1.3.6.1.2.1.1.5.0 -Ovq)
        display "Nom de l'hôte" "$HOSTNAME"

	NET_FACE=$(snmpwalk -v$SNMPV -c $COMMUNITY $NAS_IP 1.3.6.1.2.1.2.2.1.2 -Ovq)
        display "Interface" "$NET_FACE"
	
        # Uptime
        UPTIME=$(snmpget -v$SNMPV -c $COMMUNITY $NAS_IP 1.3.6.1.2.1.1.3.0 -Ovq)
        display "Uptime" "$UPTIME"

        # Charge CPU (si disponible)
        CPU_LOAD=$(snmpwalk -v$SNMPV -c $COMMUNITY $NAS_IP 1.3.6.1.4.1 | grep -i 'cpu' | head -n 5)
        display "Utilisation CPU (approx.)" "$CPU_LOAD"

        # Mémoire totale et libre (exemple avec UCD-SNMP-MIB)
        MEM_TOTAL=$(snmpget -v$SNMPV -c $COMMUNITY $NAS_IP 1.3.6.1.4.1.2021.4.5.0 -Ovq)
        MEM_FREE=$(snmpget -v$SNMPV -c $COMMUNITY $NAS_IP 1.3.6.1.4.1.2021.4.6.0 -Ovq)
        display "Mémoire (kB)" "Total: $MEM_TOTAL kB - Libre: $MEM_FREE kB"

        # Espace disque (UCD-SNMP-MIB hrStorage)
#        DISKS=$(snmpwalk -v$SNMP_VERSION -c $COMMUNITY $NAS_IP 1.3.6.1.2.1.25.2.3.1.3)
#        USAGES=$(snmpwalk -v$SNMP_VERSION -c $COMMUNITY $NAS_IP 1.3.6.1.2.1.25.2.3.1.6)
#        display "Espaces disques détectés" "$DISKS"
#        display "Utilisation de l’espace disque" "$USAGES"

# --- Utilisation CPU (en %) ---

CPU_IDLE=$(snmpget -v$SNMPV -c $COMMUNITY $NAS_IP $OID_IDLE -Ovq)
CPU_USER=$(snmpget -v$SNMPV -c $COMMUNITY $NAS_IP $OID_USER -Ovq)
CPU_SYSTEM=$(snmpget -v$SNMPV -c $COMMUNITY $NAS_IP $OID_SYSTEM -Ovq)

CPU_USED=$((100 - CPU_IDLE))
display "Utilisation CPU" "🧠 User: ${CPU_USER}% | System: ${CPU_SYSTEM}% | Total: ${CPU_USED}%"

# sleep 1
# Pause écart temps réseau

# Lire les octets à t1
IN2=$(snmpget -v$SNMPV -c $COMMUNITY $NAS_IP $OID_IN -Ovq)
OUT2=$(snmpget -v$SNMPV -c $COMMUNITY $NAS_IP $OID_OUT -Ovq)

# Calcul des débits (octets/sec), puis conversion en kilobits/sec (Kb/s)
DELTA_IN=$((IN2 - IN1))
DELTA_OUT=$((OUT2 - OUT1))
SPEED_IN_KBPS=$((DELTA_IN * 8 / 1024))
SPEED_OUT_KBPS=$((DELTA_OUT * 8 / 1024))

# Affichage
display "Débit réseau (interface $IF_INDEX)" "Entrant : ${SPEED_IN_KBPS} Kb/s | Sortant : ${SPEED_OUT_KBPS} Kb/s"

	read -t 1 -n 1 key
	if [[ $? == 0 ]]; then
		echo "Touche détectée : $key — arrêt de la boucle."
		break
	fi
done
