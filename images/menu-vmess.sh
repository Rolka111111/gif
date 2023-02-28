#!/bin/bash
#!/bin/bash
#!/bin/bash
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
###########- COLOR CODE -##############

function delvmess(){
    clear
NUMBER_OF_CLIENTS=$(grep -c -E "^### " "/etc/xray/config.json")
if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
echo -e "$COLOR1+-------------------------------------------------+${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}             ${WH}• DELETE XRAY USER •              ${NC} $COLOR1 $NC"
echo -e "$COLOR1+-------------------------------------------------+${NC}"
echo -e "$COLOR1+-------------------------------------------------+${NC}"
echo -e "$COLOR1 ${NC}  • You Dont have any existing clients!"
echo -e "$COLOR1+-------------------------------------------------+${NC}" 
echo -e "$COLOR1+---------------------- ${WH}BY${NC} ${COLOR1}-----------------------+${NC}"
echo -e "$COLOR1 ${NC}                ${WH}• ANGGUN  @ 2023 •${NC}                 $COLOR1 $NC"
echo -e "$COLOR1+-------------------------------------------------+${NC}"
echo ""
read -n 1 -s -r -p "   Press any key to back on menu"
menu-vmess
fi
clear
echo -e "$COLOR1+-------------------------------------------------+${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}             ${WH}• DELETE XRAY USER •              ${NC} $COLOR1 $NC"
echo -e "$COLOR1+-------------------------------------------------+${NC}"
echo -e "$COLOR1+-------------------------------------------------+${NC}"
grep -E "^### " "/etc/xray/config.json" | cut -d ' ' -f 2-3 | column -t | sort | uniq | nl
echo -e "$COLOR1 ${NC}"
echo -e "$COLOR1 ${NC}  • ${WH}[${COLOR1}NOTE${WH}] ${WH}Press any key to back on menu${NC}"
echo -e "$COLOR1+-------------------------------------------------+${NC}"
echo -e "$COLOR1---------------------------------------------------${NC}"
read -rp "   Input Username : " user
if [ -z $user ]; then
menu-vmess
else
exp=$(grep -wE "^### $user" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
sed -i "/^### $user $exp/,/^},{/d" /etc/xray/config.json
systemctl restart xray > /dev/null 2>&1
clear
echo -e "$COLOR1+-------------------------------------------------+${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}             ${WH}• DELETE XRAY USER •              ${NC} $COLOR1 $NC"
echo -e "$COLOR1+-------------------------------------------------+${NC}"
echo -e "$COLOR1+-------------------------------------------------+${NC}"
echo -e "$COLOR1 ${NC}   • Accound Delete Successfully"
echo -e "$COLOR1 ${NC}"
echo -e "$COLOR1 ${NC}   • Client Name : $user"
echo -e "$COLOR1 ${NC}   • Expired On  : $exp"
echo -e "$COLOR1+-------------------------------------------------+${NC}" 
echo -e "$COLOR1+---------------------- ${WH}BY${NC} ${COLOR1}-----------------------+${NC}"
echo -e "$COLOR1 ${NC}                ${WH}• ANGGUN   @ 2023 •${NC}                 $COLOR1 $NC"
echo -e "$COLOR1+-------------------------------------------------+${NC}"
echo ""
read -n 1 -s -r -p "   Press any key to back on menu"
menu-vmess
fi
}
function renewvmess(){
clear
echo -e "$COLOR1+-------------------------------------------------+${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}             ${WH}• RENEW VMESS USER •              ${NC} $COLOR1 $NC"
echo -e "$COLOR1+-------------------------------------------------+${NC}"
echo -e "$COLOR1+-------------------------------------------------+${NC}"
NUMBER_OF_CLIENTS=$(grep -c -E "^### " "/etc/xray/config.json")
if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
echo -e "$COLOR1 ${NC}  • You have no existing clients!"
echo -e "$COLOR1+-------------------------------------------------+${NC}" 
echo -e "$COLOR1+---------------------- ${WH}BY${NC} ${COLOR1}-----------------------+${NC}"
echo -e "$COLOR1 ${NC}                ${WH}• ANGGUN   @ 2023 •${NC}                 $COLOR1 $NC"
echo -e "$COLOR1+-------------------------------------------------+${NC}"
echo ""
read -n 1 -s -r -p "   Press any key to back on menu"
menu-vmess
fi
clear
echo -e "$COLOR1+-------------------------------------------------+${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}             ${WH}• RENEW VMESS USER •              ${NC} $COLOR1 $NC"
echo -e "$COLOR1+-------------------------------------------------+${NC}"
echo -e "$COLOR1+-------------------------------------------------+${NC}"
grep -E "^### " "/etc/xray/config.json" | cut -d ' ' -f 2-3 | column -t | sort | uniq | nl
echo -e "$COLOR1 ${NC}"
echo -e "$COLOR1 ${NC}  ${COLOR1}• ${WH}[${COLOR1}NOTE${WH}] Press any key to back on menu"
echo -e "$COLOR1+-------------------------------------------------+${NC}" 
echo -e "$COLOR1+---------------------- ${WH}BY${NC} ${COLOR1}-----------------------+${NC}"
echo -e "$COLOR1 ${NC}                ${WH}• ANGGUN   @ 2023 •${NC}                 $COLOR1 $NC"
echo -e "$COLOR1+-------------------------------------------------+${NC}"
echo -e "$COLOR1---------------------------------------------------${NC}"
read -rp "   Input Username : " user
if [ -z $user ]; then
menu-vmess
else
read -p "   Expired (days): " masaaktif
if [ -z $masaaktif ]; then
masaaktif="1"
fi
exp=$(grep -E "^### $user" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
now=$(date +%Y-%m-%d)
d1=$(date -d "$exp" +%s)
d2=$(date -d "$now" +%s)
exp2=$(( (d1 - d2) / 86400 ))
exp3=$(($exp2 + $masaaktif))
exp4=`date -d "$exp3 days" +"%Y-%m-%d"`
sed -i "/### $user/c\### $user $exp4" /etc/xray/config.json
systemctl restart xray > /dev/null 2>&1
clear
echo -e "$COLOR1+-------------------------------------------------+${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}             ${WH}• RENEW VMESS USER •              ${NC} $COLOR1 $NC"
echo -e "$COLOR1+-------------------------------------------------+${NC}"
echo -e "$COLOR1+-------------------------------------------------+${NC}"
echo -e "$COLOR1 ${NC}   [INFO]  $user Account Renewed Successfully"
echo -e "$COLOR1 ${NC}   "
echo -e "$COLOR1 ${NC}   Client Name : $user"
echo -e "$COLOR1 ${NC}   Days Added  : $masaaktif Days"
echo -e "$COLOR1 ${NC}   Expired On  : $exp4"
echo -e "$COLOR1+-------------------------------------------------+${NC}" 
echo -e "$COLOR1+---------------------- ${WH}BY${NC} ${COLOR1}-----------------------+${NC}"
echo -e "$COLOR1 ${NC}                ${WH}• ANGGUN   @ 2023 •${NC}                 $COLOR1 $NC"
echo -e "$COLOR1+-------------------------------------------------+${NC}"
echo ""
read -n 1 -s -r -p "   Press any key to back on menu"
menu-vmess
fi
}

function cekvmess(){
clear
echo -n > /tmp/other.txt
data=( `cat /etc/xray/config.json | grep '^###' | cut -d ' ' -f 2 | sort | uniq`);
echo -e "$COLOR1+-------------------------------------------------+${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}            ${WH}• VMESS USER ONLINE •              ${NC} $COLOR1 $NC"
echo -e "$COLOR1+-------------------------------------------------+${NC}"
echo -e "$COLOR1+-------------------------------------------------+${NC}"

for akun in "${data[@]}"
do
if [[ -z "$akun" ]]; then
akun="tidakada"
fi

echo -n > /tmp/ipvmess.txt
data2=( `cat /var/log/xray/access.log | tail -n 500 | cut -d " " -f 3 | sed 's/tcp://g' | cut -d ":" -f 1 | sort | uniq`);
for ip in "${data2[@]}"
do

jum=$(cat /var/log/xray/access.log | grep -w "$akun" | tail -n 500 | cut -d " " -f 3 | sed 's/tcp://g' | cut -d ":" -f 1 | grep -w "$ip" | sort | uniq)
if [[ "$jum" = "$ip" ]]; then
echo "$jum" >> /tmp/ipvmess.txt
else
echo "$ip" >> /tmp/other.txt
fi
jum2=$(cat /tmp/ipvmess.txt)
sed -i "/$jum2/d" /tmp/other.txt > /dev/null 2>&1
done

jum=$(cat /tmp/ipvmess.txt)
if [[ -z "$jum" ]]; then
echo > /dev/null
else
jum2=$(cat /tmp/ipvmess.txt | nl)
echo -e "$COLOR1 ${NC} user : $akun";
echo -e "$COLOR1 ${NC} $jum2";
fi
rm -rf /tmp/ipvmess.txt
done

rm -rf /tmp/other.txt
echo -e "$COLOR1+-------------------------------------------------+${NC}" 
echo -e "$COLOR1+---------------------- ${WH}BY${NC} ${COLOR1}-----------------------+${NC}"
echo -e "$COLOR1 ${NC}                ${WH}• ANGGUN  @ 2023 •${NC}                 $COLOR1 $NC"
echo -e "$COLOR1+-------------------------------------------------+${NC}"
echo ""
read -n 1 -s -r -p "   Press any key to back on menu"
menu-vmess
}

function addvmess(){
clear
source /var/lib/anggun-pro/ipvps.conf
domain=$(cat /etc/xray/domain)
echo -e "$COLOR1+-------------------------------------------------+${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}            ${WH}• CREATE VMESS USER •              ${NC} $COLOR1 $NC"
echo -e "$COLOR1+-------------------------------------------------+${NC}"
echo -e "$COLOR1+-------------------------------------------------+${NC}"
tls="$(cat ~/log-install.txt | grep -w "Xray Vmess Ws Tls" | cut -d: -f2|sed 's/ //g')"
none="$(cat ~/log-install.txt | grep -w "Xray Vmess Ws None Tls" | cut -d: -f2|sed 's/ //g')"
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do

read -rp "   Input Username : " -e user
      
if [ -z $user ]; then
echo -e "$COLOR1 ${NC} [Error] Username cannot be empty "
echo -e "$COLOR1+-------------------------------------------------+${NC}" 
echo -e "$COLOR1+---------------------- ${WH}BY${NC} ${COLOR1}-----------------------+${NC}"
echo -e "$COLOR1 ${NC}                ${WH}• ANGGUN  @ 2023 •${NC}                 $COLOR1 $NC"
echo -e "$COLOR1+-------------------------------------------------+${NC}"
echo ""
read -n 1 -s -r -p "   Press any key to back on menu"
menu
fi
		CLIENT_EXISTS=$(grep -w $user /etc/xray/config.json | wc -l)

		if [[ ${CLIENT_EXISTS} == '1' ]]; then
clear
echo -e "$COLOR1+-------------------------------------------------+${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}            ${WH}• CREATE VMESS USER •              ${NC} $COLOR1 $NC"
