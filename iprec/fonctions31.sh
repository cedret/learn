
VerifRoot()
{
    if [ $EUID -eq 0 ]
    then
        echo "********** Root ok, le script va s'executer **********"
    else
        echo "**********passer root pour executer le script **********"
        exit
    fi
#    echo "test suite"
}

VerifOctet()
{
    debut=$1
    fin=$2
    octet=$3
    while true
    do
        if [ $octet -ge $debut -a $octet -le $fin ]
        then
            echo -e "La valeur ${vert} $octet ${blanc} est ok"
            return $octet
            break
        else
            echo -e "La valeur ${rouge} $octet ${blanc} est fausse"
            echo -e "Entrez une valeur comprise entre $debut et $fin:\t\c"
            read octet
        fi
    done
}
 
SaisieIp()
{
    echo -e "Entrez votre adresse ip sous la forme a.b.c.d :\t\c"
    read ip
 
    echo "Votre adresse est : $ip"
    IFS="."
    while true
    do
        TabIp=($ip)
        NbOctets=${#TabIp[*]}
 
        echo "Le nombre d octet est : $NbOctets"
        if [ $NbOctets -ne 4 ]
        then
            echo -e "${rouge}$ip ${blanc} Veuillez saisir une adresse ip valide (4 octets) :\t\c"
            read ip
        else
            octeta=${TabIp[0]}; octetb=${TabIp[1]}; octetc=${TabIp[2]}; octetd=${TabIp[3]}
            IFS=" "
            break
        fi
        echo "Votre adresse est : $ip"
    done
}

ConfigIP()
{
    #Recherche de l'adresse ip active
    ip=$(ip -4 addr | grep $NetCard | grep inet | awk -F "[ /]" '{print $6}')
    if [ -n "$ip" ]
    then
        echo -e "L'adresse active est :[${vert}$ip${blanc}]"
        echo -e "Confirmez vous cette adresse ip O/n ?: \t\c"
        read reponse
    else
        reponse="non"
    fi
 
    echo "VOus avez tape : ---${reponse}+++"
 
    case "$reponse" in
        "" | [oO]   )   IFS="."
                        TabIp=($ip)  
                        IPa=${TabIp[0]}; IPb=${TabIp[1]}; IPc=${TabIp[2]}; IPd=${TabIp[3]}
                        IP=$IPa.$IPb.$IPc.$IPd
                        echo -e "${vert}IPa=$IPa IPb=$IPb IPc=$IPc IPd=$IPd${blanc}"
                        IFS=" ";;
                *   )   SaisieIp
 
                        #  1 <= octeta <= 254
                        VerifOctet 1 254 $octeta
                        octeta=$?
                        IP=$octeta
                        echo -e "${jaune} IP=$IP ${blanc}"
 
                        #  0 <= octetb <= 255
                        VerifOctet 0 255 $octetb
                        octetb=$?
                        IP+=.$octetb
                        echo -e "${jaune} IP=$IP ${blanc}"
 
                        #  0 <= octetc <= 255
                        VerifOctet 0 255 $octetc
                        octetc=$?
                        IP+=.$octetc
                        echo -e "${jaune} IP=$IP ${blanc}"
 
                        #  1 <= octetd <= 254
                        VerifOctet 1 254 $octetd
                        octetd=$?
                        IP+=.$octetd
                        echo -e "${jaune} IP=$IP ${blanc}"
                        IPa=$octeta; IPb=$octetb; IPc=$octetc; IPd=$octetd
                        echo -e "${vert}IPa=$IPa IPb=$IPb IPc=$IPc IPd=$IPd${blanc}"
                        IFS=" "
    esac
}

NbBit2Decimal ()
{
        NbBit=$1  #NbBit=4
        valeur=128
        octet=0
        while [ $NbBit -gt 0 ]  #4>0?                      3>0                     2>0                          1>0              0>0
        do
                ((octet=octet + valeur)) #octet=0+128=128   octet=128+ 64=192 		octet=192+32=224     octet=224+16=240
                ((valeur=valeur / 2))    #valeur=128/2=64   valeur=64/2=32          valeur=32/2=16          valeur=16/2=8
                ((NbBit=NbBit - 1))      #NbBit=4-1=3        NbBit=3-1=2	   NbBit=2-1=1              NbBit=1-1=0
        done
        echo "conversion en $octet"
        return $octet
}

SaisieMASK()
{
        cidr=$1
       
        while true
        do
                case $cidr in
                        [0-8] )
                                        NbBit2Decimal $cidr
                                        MASKa=$?; MASKb=0; MASKc=0; MASKd=0; MASK=$MASKa.$MASKb.$MASKc.$MASKd
                                        break;;
                        9|1[0-6] )                                        
                                        ((cidr=cidr-8))
                                        NbBit2Decimal $cidr
                                        MASKb=$?; MASKa=255; MASKc=0; MASKd=0; MASK=$MASKa.$MASKb.$MASKc.$MASKd 
                                        break;;
                        1[7-9]|2[0-4] )                                        
                                       ((cidr=cidr-16))
                                        NbBit2Decimal $cidr
                                        MASKc=$?; MASKa=255; MASKb=255; MASKd=0; MASK=$MASKa.$MASKb.$MASKc.$MASKd
                                        break;;
                        2[5-9]|3[0-2] )                                       
                                        ((cidr=cidr-24))
                                        NbBit2Decimal $cidr
                                        MASKd=$? ;MASKa=255; MASKb=255; MASKc=255; MASK=$MASKa.$MASKb.$MASKc.$MASKd
                                        break;;
                        * )
                        echo -en "Votre saisie ${rouge} ($cidr) est fausse ${blanc}"
                        echo -e " saisir votre masque en notation CIDR VALEUR COMPRIS ENTRE 0 ET 32  : \t\c"
                        read cidr;;
                esac
        done
}

ConfigMASK()
{
	cidr=$(ip -4 addr | grep $NetCard | grep inet | awk -F  '[ /]' '{print $7}')
	if [ -n "$cidr" ]
	then
		echo -e "Mask en notation CIDR [${vert}$cidr${blanc}]"
        echo -e "Confirmez vous le mask O/n ?:${jaune}\t\c"
	    read reponse
        echo -e "${blanc}"
    else
        reponse="non"
    fi
       case "$reponse" in
        "" | [oO]  )    SaisieMASK $cidr ;;
        *          )    echo -e "Masque en notation CIDR svp ${jaune}\t\c"
	                    read cidr
                        echo -e "${blanc}"
                        SaisieMASK $cidr ;;
    esac
}

ConfigGTW()
{
    #Recherche de l'adresse GTW active
    ip=$(ip -4 route show | grep "^default" | awk 'NR == 1 {print $3}')
#    ip=$(ip -4 addr | grep $NetCard | grep inet | awk -F "[ /]" '{print $6}')
    if [ -n "$ip" ]
    then
        echo -e "L'adresse passerelle est :[${vert}$ip${blanc}]"
        echo -e "Confirmez vous cette adresse ip O/n ?: \t\c"
        read reponse
    else
        reponse="non"
    fi
    echo "Vous avez choisi : ---${reponse}+++"
    case "$reponse" in
        "" | [oO]   )   IFS="."
                        TabIp=($ip)  
                        GTWa=${TabIp[0]}; GTWb=${TabIp[1]}; GTWc=${TabIp[2]}; GTWd=${TabIp[3]}
                        GTW=$GTWa.$GTWb.$GTWc.$GTWd
                        echo -e "${vert}GTWa=$GTWa GTWb=$GTWb GTWc=$GTWc GTWd=$GTWd${blanc}"
                        IFS=" ";;
                *   )   SaisieIp
 
                        #  1 <= octeta <= 254
                        VerifOctet 1 254 $octeta
                        octeta=$?
                        GTW=$octeta
                        echo -e "${jaune} GTW=$GTW ${blanc}"
 
                        #  0 <= octetb <= 255
                        VerifOctet 0 255 $octetb
                        octetb=$?
                        GTW+=.$octetb
                        echo -e "${jaune} GTW=$GTW ${blanc}"
 
                        #  0 <= octetc <= 255
                        VerifOctet 0 255 $octetc
                        octetc=$?
                        GTW+=.$octetc
                        echo -e "${jaune} GTW=$GTW ${blanc}"
 
                        #  1 <= octetd <= 254
                        VerifOctet 1 254 $octetd
                        octetd=$?
                        GTW+=.$octetd
                        echo -e "${jaune} GTW=$GTW ${blanc}"
                        GTWa=$octeta; GTWb=$octetb; GTWc=$octetc; GTWd=$octetd
                        echo -e "${vert}GTWa=$GTWa GTWb=$GTWb GTWc=$GTWc GTWd=$GTWd${blanc}"
                        IFS=" "
    esac
}

ConfigDNS()
{
    #Recherche de l'adresse dns active
#    ip=$(ip -4 addr | grep $NetCard | grep inet | awk -F "[ /]" '{print $6}')
    ip=$(grep "^nameserver" /etc/resolv.conf | awk 'NR == 1 {print $2}')
    if [ -n "$ip" ]
    then
        echo -e "L'adresse active est :[${vert}$ip${blanc}]"
        echo -e "Confirmez vous cette adresse ip O/n ?: \t\c"
        read reponse
    else
        reponse="non"
    fi
    echo "Vous avez saisi : ---${reponse}+++"
     case "$reponse" in
        "" | [oO]   )   IFS="."
                        TabIp=($ip)  
                        DNSa=${TabIp[0]}; DNSb=${TabIp[1]}; DNSc=${TabIp[2]}; DNSd=${TabIp[3]}
                        DNS=$DNSa.$DNSb.$DNSc.$DNSd
                        echo -e "${vert}DNSa=$DNSa DNSb=$DNSb DNSc=$DNSc DNSd=$DNSd${blanc}"
                        IFS=" ";;
                *   )   SaisieIp
 
                        #  1 <= octeta <= 254
                        VerifOctet 1 254 $octeta
                        octeta=$?
                        DNS=$octeta
                        echo -e "${jaune} DNS=$DNS ${blanc}"
 
                        #  0 <= octetb <= 255
                        VerifOctet 0 255 $octetb
                        octetb=$?
                        DNS+=.$octetb
                        echo -e "${jaune} DNS=$DNS ${blanc}"
 
                        #  0 <= octetc <= 255
                        VerifOctet 0 255 $octetc
                        octetc=$?
                        DNS+=.$octetc
                        echo -e "${jaune} DNS=$DNS ${blanc}"
 
                        #  1 <= octetd <= 254
                        VerifOctet 1 254 $octetd
                        octetd=$?
                        DNS+=.$octetd
                        echo -e "${jaune} DNS=$DNS ${blanc}"
                        DNSa=$octeta; DNSb=$octetb; DNSc=$octetc; DNSd=$octetd
                        echo -e "${vert}DNSa=$DNSa DNSb=$DNSb DNSc=$DNSc DNSd=$DNSd${blanc}"
                        IFS=" "
    esac
}
