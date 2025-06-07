#!/bin/bash

# Configuration
NAS_IP="192.168.1.107"       # IP de ton NAS
COMMUNITY="maison"           # Communauté SNMP
SNMP_VERSION="2c"            # Version SNMP

# Fonction d'affichage
function display {
    echo "=== $1 ==="
    echo "$2"
    echo
}

while true;
do
	date
        # Nom d'hôte
        HOSTNAME=$(snmpget -v$SNMP_VERSION -c $COMMUNITY $NAS_IP 1.3.6.1.2.1.1.5.0 -Ovq)
        display "Nom de l'hôte" "$HOSTNAME"

	NET_FACE=$(snmpwalk -v$SNMP_VERSION -c $COMMUNITY $NAS_IP 1.3.6.1.2.1.2.2.1.2 -Ovq)
        display "Interface" "$NET_FACE"
	
        # Uptime
        UPTIME=$(snmpget -v$SNMP_VERSION -c $COMMUNITY $NAS_IP 1.3.6.1.2.1.1.3.0 -Ovq)
        display "Uptime" "$UPTIME"

        # Charge CPU (si disponible)
        CPU_LOAD=$(snmpwalk -v$SNMP_VERSION -c $COMMUNITY $NAS_IP 1.3.6.1.4.1 | grep -i 'cpu' | head -n 5)
        display "Utilisation CPU (approx.)" "$CPU_LOAD"

        # Mémoire totale et libre (exemple avec UCD-SNMP-MIB)
        MEM_TOTAL=$(snmpget -v$SNMP_VERSION -c $COMMUNITY $NAS_IP 1.3.6.1.4.1.2021.4.5.0 -Ovq)
        MEM_FREE=$(snmpget -v$SNMP_VERSION -c $COMMUNITY $NAS_IP 1.3.6.1.4.1.2021.4.6.0 -Ovq)
        display "Mémoire (kB)" "Total: $MEM_TOTAL kB - Libre: $MEM_FREE kB"

        # Espace disque (UCD-SNMP-MIB hrStorage)
        DISKS=$(snmpwalk -v$SNMP_VERSION -c $COMMUNITY $NAS_IP 1.3.6.1.2.1.25.2.3.1.3)
        USAGES=$(snmpwalk -v$SNMP_VERSION -c $COMMUNITY $NAS_IP 1.3.6.1.2.1.25.2.3.1.6)
#        display "Espaces disques détectés" "$DISKS"
#        display "Utilisation de l’espace disque" "$USAGES"

	read -t 1 -n 1 key
	if [[ $? == 0 ]]; then
		echo "Touche détectée : $key — arrêt de la boucle."
		break
	fi
done
