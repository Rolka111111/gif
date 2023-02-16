#!/bin/bash
#!/bin/bash
# Menu For Script
# Edition : Stable Edition V1.0
# Auther  : 
# (C) Copyright 2021-2022
# =========================================
BIBlack='\033[1;90m'      # Black
BIRed='\033[1;91m'        # Red
BIGREEN='\033[1;92m'      # GREEN
BIYellow='\033[1;93m'     # Yellow
BIBlue='\033[1;94m'       # Blue
BIPurple='\033[1;95m'     # Purple
BICdyan='\033[1;96m'       # Cyan
BIWhite='\033[1;97m'      # White
UWhite='\033[4;37m'       # White
On_IPurple='\033[0;105m'  #
On_IRed='\033[0;101m'
IBlack='\033[0;90m'       # Black
IRed='\033[0;91m'         # Red
IGREEN='\033[0;92m'       # GREEN
IYellow='\033[0;93m'      # Yellow
IBlue='\033[0;94m'        # Blue
IPurple='\033[0;95m'      # Purple
ICyan='\033[0;96m'        # Cyan
IWhite='\033[0;97m'       # White
NC='\e[0m'

# // Export Color & Information
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[0;33m'
export BLUE='\033[0;34m'
export PURPLE='\033[0;35m'
export CYAN='\033[0;36m'
export LIGHT='\033[0;37m'
export NC='\033[0m'

# // Export Banner Status Information
export EROR="[${RED} EROR ${NC}]"
export INFO="[${YELLOW} INFO ${NC}]"
export OKEY="[${GREEN} OKEY ${NC}]"
export PENDING="[${YELLOW} PENDING ${NC}]"
export SEND="[${YELLOW} SEND ${NC}]"
export RECEIVE="[${YELLOW} RECEIVE ${NC}]"

# // Export Align
export BOLD="\e[1m"
export WARNING="${RED}\e[5m"
export UNDERLINE="\e[4m"

# // Exporting URL Host

# // Root Checking
if [ "${EUID}" -ne 0 ]; then
		echo -e "${EROR} Please Run This Script As Root User !"
		exit 1
fi

# // Exporting IP Address
export IP=$( curl -s https://ipinfo.io/ip/ )

# // Exporting Network Interface
export NETWORK_IFACE="$(ip route show to default | awk '{print $5}')"


# // Clear
clear
clear && clear && clear
clear;clear;clear
cek=$(service ssh status | grep active | cut -d ' ' -f5)
if [ "$cek" = "active" ]; then
stat=-f5
else
stat=-f7
fi
ssh=$(service ssh status | grep active | cut -d ' ' $stat)
if [ "$ssh" = "active" ]; then
ressh="${GREEN}ON${NC}"
else
ressh="${red}OFF${NC}"
fi
sshstunel=$(service stunnel5 status | grep active | cut -d ' ' $stat)
if [ "$sshstunel" = "active" ]; then
resst="${GREEN}ON${NC}"
else
resst="${red}OFF${NC}"
fi
sshws=$(service ws-stunnel status | grep active | cut -d ' ' $stat)
if [ "$sshws" = "active" ]; then
ressshws="${GREEN}ON${NC}"
else
ressshws="${red}OFF${NC}"
fi
ngx=$(service nginx status | grep active | cut -d ' ' $stat)
if [ "$ngx" = "active" ]; then
resngx="${GREEN}ON${NC}"
else
resngx="${red}OFF${NC}"
fi
dbr=$(service dropbear status | grep active | cut -d ' ' $stat)
if [ "$dbr" = "active" ]; then
resdbr="${GREEN}ON${NC}"
else
resdbr="${red}OFF${NC}"
fi
v2r=$(service xray status | grep active | cut -d ' ' $stat)
if [ "$v2r" = "active" ]; then
resv2r="${GREEN}ON${NC}"
else
resv2r="${red}OFF${NC}"
fi
#read -n 1 -s -r -p "Press any key to back on menu"
#menu
#fi
#}
#echo ""
#read -n 1 -s -r -p "Press any key to back on menu"
#menu
#}

IPVPS=$(curl -s ipinfo.io/ip )
ISPVPS=$( curl -s ipinfo.io/org )
clear
echo -e "${BICyan} ┌─────────────────────────────────────────────────────┐${NC}"
echo -e "${BICyan} │              ${BIWhite}${UWhite}Server Informations${NC}"
echo -e "${BICyan} │"
echo -e " ${BICyan}│  ${BICyan}Use Core        :  ${BIPurple}ANGGUN ${NC}"
echo -e " ${BICyan}│  ${BICyan}Current Domain  :  ${BIPurple}$(cat /etc/xray/domain)${NC}"
echo -e " ${BICyan}│  ${BICyan}IP-VPS          :  ${BIYellow}$IPVPS${NC}"
echo -e " ${BICyan}│  ${BICyan}ISP-VPS         :  ${BIYellow}$ISPVPS${NC}"
echo -e " ${BICyan}└─────────────────────────────────────────────────────┘${NC}"
echo -e "     ${BICyan} SSH ${NC}: $ressh"" ${BICyan} NGINX ${NC}: $resngx"" ${BICyan}  XRAY ${NC}: $resv2r"" ${BICyan} TROJAN ${NC}: $resv2r"
echo -e "     ${BICyan}          DROPBEAR ${NC}: $resdbr" "${BICyan} SSH-WS ${NC}: $ressshws"
echo -e "${BICyan} ┌─────────────────────────────────────────────────────┐${NC}"
echo -e "     ${BICyan}[${BIWhite}1${BICyan}] SSH ${BICyan}${BIYellow}${BICyan}${NC}" 
echo -e "     ${BICyan}[${BIWhite}2${BICyan}] VMESS ${BICyan}${BIYellow}${BICyan}${NC}"    
echo -e "     ${BICyan}[${BIWhite}3${BICyan}] VLESS ${BICyan}${BIYellow}${BICyan}${NC}"    
echo -e "     ${BICyan}[${BIWhite}4${BICyan}] TROJAN ${BICyan}${BIYellow}${BICyan}${NC}" 
echo -e "     ${BICyan}[${BIWhite}5${BICyan}] SHADOWSOCKS ${BICyan}${BIYellow}${BICyan}${NC}"    
echo -e "     ${BICyan}[${BIWhite}6${BICyan}] TENDANG ${BICyan}${BIYellow}${BICyan}${NC}"    
echo -e "     ${BICyan}[${BIWhite}7${BICyan}] AU-REBOOT ${BICyan}${BIYellow}${BICyan}${NC}"    
echo -e "     ${BICyan}[${BIWhite}8${BICyan}] REBOOT ${BICyan}${BIYellow}${BICyan}${NC}"    
echo -e "     ${BICyan}[${BIWhite}9${BICyan}] RESTART ${BICyan}${BIYellow}${BICyan}${NC}"    
echo -e "     ${BICyan}[${BIWhite}10${BICyan}] BACKUP/RESTORE ${BICyan}${BIYellow}${BICyan}${NC}"   
echo -e "     ${BICyan}[${BIWhite}11${BICyan}] ADD-HOST/DOMAIN ${BICyan}${BIYellow}${BICyan}${NC}" 
echo -e "     ${BICyan}[${BIWhite}12${BICyan}] GEN-SSL ${BICyan}${BIYellow}${BICyan}${NC}"       
echo -e "     ${BICyan}[${BIWhite}13${BICyan}] EDIT-BANNER ${BICyan}${BIYellow}${BICyan}${NC}" 
echo -e "     ${BICyan}[${BIWhite}14${BICyan}] CEK-STATUS ${BICyan}${BIYellow}${BICyan}${NC}" 
echo -e "     ${BICyan}[${BIWhite}15${BICyan}] CEK-TRAFIK ${BICyan}${BIYellow}${BICyan}${NC}" 
echo -e "     ${BICyan}[${BIWhite}16${BICyan}] CEK-SPEED ${BICyan}${BIYellow}${BICyan}${NC}"
echo -e "     ${BICyan}[${BIWhite}17${BICyan}] CEK-BANDWIDTH ${BICyan}${BIYellow}${BICyan}${NC}"
#echo -e "     ${BICyan}[${BIWhite}18${BICyan}] CEK-USAGE-RAM ${BICyan}${BIYellow}${BICyan}${NC}"
echo -e "     ${BICyan}[${BIWhite}18${BICyan}] LIMIT-SPEED ${BICyan}${BIYellow}${BICyan}${NC}"
echo -e "     ${BICyan}[${BIWhite}19${BICyan}] WEBMIN ${BICyan}${BIYellow}${BICyan}${NC}"
echo -e "     ${BICyan}[${BIWhite}20${BICyan}] INFO-SCRIPT ${BICyan}${BIYellow}${BICyan}${NC}" 
echo -e "     ${BICyan}[${BIWhite}21${BICyan}] DNS-CUSTOM ${BICyan}${BIYellow}${BICyan}${NC}" 
echo -e "     ${BICyan}[${BIWhite}22${BICyan}] CLEAR-LOG ${BICyan}${BIYellow}${BICyan}${NC}" 
#echo -e "     ${BICyan}[${BIWhite}99${BICyan}] UPDATE ${BICyan}${BIYellow}${BICyan}${NC}" 
echo -e "     ${BICyan}[${BIWhite}x${BICyan}]  EXIT ${BICyan}${BIYellow}${BICyan}${NC}"  
echo -e "${BICyan} └─────────────────────────────────────────────────────┘${NC}"
echo -e " ${BICyan}┌─────────────────────────────────────┐${NC}"
echo -e " ${BICyan}│  Version      ${NC} : $sem Last Update"
echo -e " ${BICyan}│  User          :ANGGUN \e[0m"
echo -e " ${BICyan}│  Expiry script${NC} : unlimited"
echo -e " ${BICyan}└─────────────────────────────────────┘${NC}"
echo
read -p " Select menu : " opt
echo -e ""
case $opt in
1) clear ; menu-ssh ;;
2) clear ; menu-vmess ;;
3) clear ; menu-vless ;;
4) clear ; menu-trojan ;;
5) clear ; menu-ss ;;
6) clear ; tendang ;;
7) clear ; autoreboot ;;
8) clear ; reboot ;;
9) clear ; restart ;;
10) clear ; menu-bckp ;;
11) clear ; addhost ;;
12) clear ; genssl ;;
13) clear ; nano /etc/issue.net ;;
14) clear ; running ;;
15) clear ; cek-trafik ;;
16) clear ; cek-speed ;;
17) clear ; cek-bandwidth ;;
#18) clear ; cek-ram ;;
18) clear ; limit-speed ;;
19) clear ; wbm ;;
20) clear ; cat /root/log-install.txt ;;
21) clear ; canger ;;
22) clear ; clearlog ;;
#99) clear ; update ;;
0) clear ; menu ;;
x) exit ;;
*) echo -e "" ; echo "Press any key to back exit" ; sleep 1 ; exit ;;
esac
