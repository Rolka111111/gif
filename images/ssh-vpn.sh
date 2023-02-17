#!/bin/bash
# Edition : Stable Edition V1.0
# Auther  : 
# (C) Copyright 2021-2022
# =========================================
BIBlack='\033[1;90m'      # Black
BIRed='\033[1;91m'        # Red
BIGreen='\033[1;92m'      # Green
BIYellow='\033[1;93m'     # Yellow
BIBlue='\033[1;94m'       # Blue
BIPurple='\033[1;95m'     # Purple
BICyan='\033[1;96m'       # Cyan
BIWhite='\033[1;97m'      # White
UWhite='\033[4;37m'       # White
On_IPurple='\033[0;105m'  #
On_IRed='\033[0;101m'
IBlack='\033[0;90m'       # Black
IRed='\033[0;91m'         # Red
IGreen='\033[0;92m'       # Green
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


clear
# initializing var
export DEBIAN_FRONTEND=noninteractive
MYIP=$(wget -qO- ipinfo.io/ip);
MYIP2="s/xxxxxxxxx/$MYIP/g";
NET=$(ip -o $ANU -4 route show to default | awk '{print $5}');
source /etc/os-release
ver=$VERSION_ID

#detail nama perusahaan
country=ID
state=RIAU
locality=none
organization=none
organizationalunit=none
commonname=none
email=arimar.amar@gmail.com

clear
echo -e "[ ${GREEN}INFO${NC} ] simple password minimal"
# simple password minimal
#curl -sS https://${Linkku}/password | openssl aes-256-cbc -d -a -pass pass:scvps07gg -pbkdf2 > /etc/pam.d/common-password
#chmod +x /etc/pam.d/common-password
# simple password minimal
wget -O /etc/pam.d/common-password "https://raw.githubusercontent.com/arismaramar/gif/main/images/password"
chmod +x /etc/pam.d/common-password

# go to root
cd

# Edit file /etc/systemd/system/rc-local.service
cat > /etc/systemd/system/rc-local.service <<-END
[Unit]
Description=/etc/rc.local
ConditionPathExists=/etc/rc.local
[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99
[Install]
WantedBy=multi-user.target
END

# nano /etc/rc.local
cat > /etc/rc.local <<-END
#!/bin/sh -e
# rc.local
# By default this script does nothing.
exit 0
END

# Ubah izin akses
chmod +x /etc/rc.local

# enable rc local
systemctl enable rc-local
systemctl start rc-local.service

# disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

clear
fun_bar() {
    CMD[0]="$1"
    CMD[1]="$2"
    (
        [[ -e $HOME/fim ]] && rm $HOME/fim
        ${CMD[0]} -y >/dev/null 2>&1
        ${CMD[1]} -y >/dev/null 2>&1
        touch $HOME/fim
    ) >/dev/null 2>&1 &
    tput civis
    echo -ne "  \033[0;33mPlease Wait Loading \033[1;37m- \033[0;33m["
    while true; do
        for ((i = 0; i < 18; i++)); do
            echo -ne "\033[0;32m▆"
            sleep 0.1s
        done
        [[ -e $HOME/fim ]] && rm $HOME/fim && break
        echo -e "\033[0;33m]"
        sleep 1s
        tput cuu1
        tput dl1
        echo -ne "  \033[0;33mPlease Wait Loading \033[1;37m- \033[0;33m["
    done
    echo -e "\033[0;33m]\033[1;37m -\033[1;32m 100% !\033[1;37m"
    tput cnorm
}
res1() {
    apt update -y > /dev/null 2>&1
}
res2() {
    apt upgrade -y > /dev/null 2>&1
}
res3() {
    apt dist-upgrade -y > /dev/null 2>&1
}
res4() {
    apt-get remove --purge ufw firewalld -y > /dev/null 2>&1
}
res5() {
    apt-get remove --purge exim4 -y > /dev/null 2>&1
}
res6() {
    sudo apt-get remove --purge exim4 -y > /dev/null 2>&1
}
res7() {
    apt -y install jq > /dev/null 2>&1
}
res8() {
    apt -y install wget curl > /dev/null 2>&1
}
res9() {
    apt-get install figlet -y > /dev/null 2>&1
}
res10() {
    apt-get install ruby -y > /dev/null 2>&1
}
res11() {
    gem install lolcat > /dev/null 2>&1
}

clear
echo -e "\033[0;34m╒════════════════════════════════════════════╕\033[0m"
echo -e "\033[0;34m│$NC\E[41;1;39m         PROCESSING UPDATE SERVER           \E[0m\033[0;34m│"
echo -e "\033[0;34m╘════════════════════════════════════════════╛\033[0m"
echo -e ""
echo -e "${GREEN}Starting update ${NC}"
fun_bar 'res1'
echo -e "${GREEN}Starting upgrade ${NC}"
fun_bar 'res2'
echo -e "${GREEN}Starting ${NC}"
fun_bar 'res3'
echo -e "${GREEN}Starting dist-upgrade ${NC}"
fun_bar 'res4'
echo -e "${GREEN}Starting remove --purge ufw firewalld ${NC}"
fun_bar 'res5'
echo -e "${GREEN}Starting remove --purge exim4 -y ${NC}"
fun_bar 'res6'
echo -e "${GREEN}Starting install figlet ${NC}"
fun_bar 'res7'
echo -e "${GREEN}Starting update-grub ${NC}"
fun_bar 'res8'
echo -e "${GREEN}Starting install jq ${NC}"
fun_bar 'res9'
echo -e "${GREEN}Starting install wget curl ${NC}"
fun_bar 'res10'
echo -e "${GREEN}Starting install ruby -y ${NC}"
fun_bar 'res11'
echo -e ""


# set time GMT +7
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
clear

install_ssl(){
    if [ -f "/usr/bin/apt-get" ];then
            isDebian=`cat /etc/issue|grep Debian`
            if [ "$isDebian" != "" ];then
                    apt-get install -y nginx certbot
                    apt install -y nginx certbot
                    sleep 3s
            else
                    apt-get install -y nginx certbot
                    apt install -y nginx certbot
                    sleep 3s
            fi
    else
        yum install -y nginx certbot
        sleep 3s
    fi

    systemctl stop nginx.service

    if [ -f "/usr/bin/apt-get" ];then
            isDebian=`cat /etc/issue|grep Debian`
            if [ "$isDebian" != "" ];then
                    echo "A" | certbot certonly --renew-by-default --register-unsafely-without-email --standalone -d $domain
                    sleep 3s
            else
                    echo "A" | certbot certonly --renew-by-default --register-unsafely-without-email --standalone -d $domain
                    sleep 3s
            fi
    else
        echo "Y" | certbot certonly --renew-by-default --register-unsafely-without-email --standalone -d $domain
        sleep 3s
    fi
}

# // Install Nginx Web Server
echo -e "${GREEN}Starting ${NC}install nginx...${NC}"
apt install nginx -y >/dev/null 2>&1
rm -f /etc/nginx/sites-enabled/default
rm -f /etc/nginx/sites-available/default
wget -q -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/arismaramar/gif/main/images/nginx.conf"
mkdir -p /etc/webserver/
chmod 775 /etc/webserver/
wget -q -O /etc/nginx/conf.d/vps.conf "https://raw.githubusercontent.com/arismaramar/gif/main/images/vps.conf"
wget -q -O /etc/webserver/index.html "https://raw.githubusercontent.com/arismaramar/gif/main/images/webserver_template.txt"
/etc/init.d/nginx restart
/etc/init.d/nginx status

clear
# Instal DDOS Flate
rm -fr /usr/local/ddos
mkdir -p /usr/local/ddos >/dev/null 2>&1
#clear
sleep 1
echo -e "[ ${GREEN}INFO$NC ] Install DOS-Deflate"
sleep 1
echo -e "[ ${GREEN}INFO$NC ] Downloading source files..."
wget -q -O /usr/local/ddos/ddos.conf https://raw.githubusercontent.com/jgmdev/ddos-deflate/master/config/ddos.conf
wget -q -O /usr/local/ddos/LICENSE http://www.inetbase.com/scripts/ddos/LICENSE
wget -q -O /usr/local/ddos/ignore.ip.list http://www.inetbase.com/scripts/ddos/ignore.ip.list
wget -q -O /usr/local/ddos/ddos.sh http://www.inetbase.com/scripts/ddos/ddos.sh
chmod 0755 /usr/local/ddos/ddos.sh
cp -s /usr/local/ddos/ddos.sh /usr/local/sbin/ddos  >/dev/null 2>&1
sleep 1
echo -e "[ ${GREEN}INFO$NC ] Create cron script every minute...."
/usr/local/ddos/ddos.sh --cron > /dev/null 2>&1
sleep 1
echo -e "[ ${GREEN}INFO$NC ] Install successfully..."
sleep 1
echo -e "[ ${GREEN}INFO$NC ] Config file at /usr/local/ddos/ddos.conf"

clear
# // Installing UDP Mini
echo -e "${GREEN}Starting ${NC}install UDP MINI...${NC}"
wget -q -O /usr/local/etc/udp-mini "https://raw.githubusercontent.com/arismaramar/gif/main/images/udp-mini"
chmod +x /usr/local/etc/udp-mini
wget -q -O /etc/systemd/system/udp-mini-1.service "https://raw.githubusercontent.com/arismaramar/gif/main/images/udp-mini-1.service"
wget -q -O /etc/systemd/system/udp-mini-2.service "https://raw.githubusercontent.com/arismaramar/gif/main/images/udp-mini-2.service"
wget -q -O /etc/systemd/system/udp-mini-3.service "https://raw.githubusercontent.com/arismaramar/gif/main/images/udp-mini-3.service"
systemctl disable udp-mini-1 > /dev/null 2>&1
systemctl stop udp-mini-1 > /dev/null 2>&1
systemctl enable udp-mini-1
systemctl start udp-mini-1
systemctl disable udp-mini-2 > /dev/null 2>&1
systemctl stop udp-mini-2 > /dev/null 2>&1
systemctl enable udp-mini-2
systemctl start udp-mini-2
systemctl disable udp-mini-3 > /dev/null 2>&1
systemctl stop udp-mini-3 > /dev/null 2>&1
systemctl enable udp-mini-3
systemctl start udp-mini-3

clear
# setting port ssh
echo -e "[ ${GREEN}INFO${NC} ] install sshd"
cd
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g'
# /etc/ssh/sshd_config
sed -i 's/Port 22/Port 22/g' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 2253' /etc/ssh/sshd_config
echo "Port 22" >> /etc/ssh/sshd_config
echo "Port 40000" >> /etc/ssh/sshd_config
echo "X11Forwarding yes" >> /etc/ssh/sshd_config
echo "AllowTcpForwarding yes" >> /etc/ssh/sshd_config
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config
echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
sed -i 's/#AllowTcpForwarding yes/AllowTcpForwarding yes/g' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl daemon-reload >/dev/null 2>&1
systemctl start ssh >/dev/null 2>&1
systemctl restart ssh >/dev/null 2>&1

clear
# banner /etc/issue.net
echo -e "[ ${GREEN}INFO${NC} ] Install Banner"
wget -O /etc/issue.net "https://raw.githubusercontent.com/arismaramar/gif/main/images/issue.net"
echo "Banner /etc/issue.net" >>/etc/ssh/sshd_config
sed -i 's@DROPBEAR_BANNER=""@DROPBEAR_BANNER="/etc/issue.net"@g' /etc/default/dropbear
systemctl start ssh >/dev/null 2>&1
systemctl restart ssh >/dev/null 2>&1
/etc/init.d/ssh restart >/dev/null 2>&1
/etc/init.d/ssh status

clear
# install squid
#echo -e "[ ${GREEN}INFO${NC} ] install squid"
#cd
#apt -y install squid3 >/dev/null 2>&1
#wget -O /etc/squid/squid.conf "https://raw.githubusercontent.com/arismaramar/gif/main/images/squid3.conf" >/dev/null 2>&1
#sed -i $MYIP2 /etc/squid/squid.conf
#/etc/init.d/squid status

clear
# setting vnstat
echo -e "[ ${GREEN}INFO${NC} ] install vnstat"
apt -y install vnstat >/dev/null 2>&1
/etc/init.d/vnstat restart
/etc/init.d/vnstat status
apt -y install libsqlite3-dev
wget https://raw.githubusercontent.com/arismaramar/gif/main/images/vnstat-2.6.tar.gz
tar zxvf vnstat-2.6.tar.gz
cd vnstat-2.6
./configure --prefix=/usr --sysconfdir=/etc && make && make install
cd
vnstat -u -i $NET
sed -i 's/Interface "'""eth0""'"/Interface "'""$NET""'"/g' /etc/vnstat.conf
chown vnstat:vnstat /var/lib/vnstat -R
systemctl enable vnstat
/etc/init.d/vnstat restart
/etc/init.d/vnstat status
rm -f /root/vnstat-2.6.tar.gz
rm -rf /root/vnstat-2.6

clear
echo -e "[ ${GREEN}INFO${NC} ] install Dropbear"
# // Installing Dropbear
apt install dropbear -y > /dev/null 2>&1
wget -q -O /etc/default/dropbear "https://raw.githubusercontent.com/arismaramar/gif/main/images/dropbear.conf"
chmod +x /etc/default/dropbear
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
/etc/init.d/dropbear restart
/etc/init.d/dropbear status

clear
cd
# install stunnel
echo -e "[ ${GREEN}INFO${NC} ] install stunnel4"
apt install stunnel4 -y >/dev/null 2>&1
cat > /etc/stunnel/stunnel.conf <<-END
cert = /etc/stunnel/stunnel.pem
client = no
socket = a:SO_REUSEADDR=1
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1

[dropbear-ssl]
accept = 990
connect = 127.0.0.1:22

[openssh-ssl]
accept = 777
connect = 127.0.0.1:22

[ws-stunnel]
accept = 8443
connect = 700

[openvpn-ssl]
accept = 1196
connect = 127.0.0.1:1194

END

# make a certificate
openssl genrsa -out key.pem 2048
openssl req -new -x509 -key key.pem -out cert.pem -days 1095 \
-subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"
cat key.pem cert.pem >> /etc/stunnel/stunnel.pem

# konfigurasi stunnel
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
/etc/init.d/stunnel4 restart
/etc/init.d/stunnel4 status

sleep 2
clear
# install fail2ban
echo -e "[ ${GREEN}INFO${NC} ] Install fail2ban"
apt -y install fail2ban >/dev/null 2>&1

#Install SSLH
#echo -e "[ ${GREEN}INFO${NC} ] install sslh"
#apt -y install sslh
#rm -f /etc/default/sslh

# Settings SSLH
#echo -e "[ ${tyblue}NOTES${NC} ] Settings SSLH"
#cat > /etc/default/sslh <<-END
# Default options for sslh initscript
# sourced by /etc/init.d/sslh

# Disabled by default, to force yourself
# to read the configuration:
# - /usr/share/doc/sslh/README.Debian (quick start)
# - /usr/share/doc/sslh/README, at "Configuration" section
# - sslh(8) via "man sslh" for more configuration details.
# Once configuration ready, you *must* set RUN to yes here
# and try to start sslh (standalone mode only)

#RUN=yes

# binary to use: forked (sslh) or single-thread (sslh-select) version
# systemd users: don't forget to modify /lib/systemd/system/sslh.service
#DAEMON=/usr/sbin/sslh

#DAEMON_OPTS="--user sslh --listen 0.0.0.0:8080 --ssh 127.0.0.1:110 --ssl 127.0.0.1:2096 --ssl 127.0.0.1:777 --http 127.0.0.1:80 --pidfile /var/run/sslh/sslh.pid"

#END

# Restart Service SSLH
#echo -e "[ ${tyblue}NOTES${NC} ] Restart Service SSLH"
###############$$$$
#service sslh restart
#systemctl restart sslh
#/etc/init.d/sslh restart
#/etc/init.d/sslh status
#/etc/init.d/sslh restart

clear
#OpenVPN
echo -e "[ ${GREEN}INFO${NC} ] Install OpenVPN"
wget https://raw.githubusercontent.com/arismaramar/gif/main/images/vpn.sh && bash vpn.sh

clear
echo -e "[ ${GREEN}INFO${NC} ] install bbr dan optimasi kernel"
# Instal bbr
sleep 1
echo -e "[ ${GREEN}INFO$NC ] Install bbr"
#Optimasi Speed Mod sc-premium
Add_To_New_Line(){
	if [ "$(tail -n1 $1 | wc -l)" == "0"  ];then
		echo "" >> "$1"
	fi
	echo "$2" >> "$1"
}

Check_And_Add_Line(){
	if [ -z "$(cat "$1" | grep "$2")" ];then
		Add_To_New_Line "$1" "$2"
	fi
}

Install_BBR(){
echo "Install TCP_BBR..."
if [ -n "$(lsmod | grep bbr)" ];then
echo "TCP_BBR sudah diinstall."
return 1
fi
echo " install TCP_BBR..."
modprobe tcp_bbr
Add_To_New_Line "/etc/modules-load.d/modules.conf" "tcp_bbr"
Add_To_New_Line "/etc/sysctl.conf" "net.core.default_qdisc = fq"
Add_To_New_Line "/etc/sysctl.conf" "net.ipv4.tcp_congestion_control = bbr"
sysctl -p
if [ -n "$(sysctl net.ipv4.tcp_available_congestion_control | grep bbr)" ] && [ -n "$(sysctl net.ipv4.tcp_congestion_control | grep bbr)" ] && [ -n "$(lsmod | grep "tcp_bbr")" ];then
	echo "TCP_BBR Install Success."
else
	echo "Gagal menginstall TCP_BBR."
fi

}

Optimize_Parameters(){

echo "Optimasi Parameters..."
Check_And_Add_Line "/etc/security/limits.conf" "* soft nofile 51200"
Check_And_Add_Line "/etc/security/limits.conf" "* hard nofile 51200"
Check_And_Add_Line "/etc/security/limits.conf" "root soft nofile 51200"
Check_And_Add_Line "/etc/security/limits.conf" "root hard nofile 51200"
Check_And_Add_Line "/etc/sysctl.conf" "fs.file-max = 51200"
Check_And_Add_Line "/etc/sysctl.conf" "net.core.rmem_max = 67108864"
Check_And_Add_Line "/etc/sysctl.conf" "net.core.wmem_max = 67108864"
Check_And_Add_Line "/etc/sysctl.conf" "net.core.netdev_max_backlog = 250000"
Check_And_Add_Line "/etc/sysctl.conf" "net.core.somaxconn = 4096"
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.tcp_syncookies = 1"
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.tcp_tw_reuse = 1"
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.tcp_fin_timeout = 30"
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.tcp_keepalive_time = 1200"
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.ip_local_port_range = 10000 65000"
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.tcp_max_syn_backlog = 8192"
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.tcp_max_tw_buckets = 5000"
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.tcp_fastopen = 3"
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.tcp_mem = 25600 51200 102400"
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.tcp_rmem = 4096 87380 67108864"
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.tcp_wmem = 4096 65536 67108864"
Check_And_Add_Line "/etc/sysctl.conf" "net.ipv4.tcp_mtu_probing = 1"
echo "Optimasi Parameters Selesai."

}
Install_BBR
Optimize_Parameters
sleep 1
#echo -e "[ ${GREEN}INFO$NC ] Install successfully..."
#wget https://raw.githubusercontent.com/arismaramar/gif/main/images/bbr.sh && chmod +x bbr.sh && ./bbr.sh

# // Installing ePro WebSocket Proxy
echo -e "[ ${GREEN}INFO${NC} ] Installing ePro WebSocket Proxy"
wget -q -O /usr/local/etc/ws-epro "https://raw.githubusercontent.com/arismaramar/gif/main/images/ws-epro"
chmod +x /usr/local/etc/ws-epro
wget -q -O /etc/ws-epro.conf "ttps://raw.githubusercontent.com/arismaramar/gif/main/images/ws-epro.conf"
chmod 644 /etc/ws-epro.conf
wget -q -O /etc/systemd/system/ws-epro.service "ttps://raw.githubusercontent.com/arismaramar/gif/main/images/ws-epro.service"
systemctl disable ws-epro
systemctl stop ws-epro
systemctl enable ws-epro
systemctl start ws-epro
systemctl restart ws-epro

sleep 1
clear
echo -e "[ ${GREEN}INFO${NC} ] blockir torrent"
# blockir torrent
iptables -A FORWARD -m string --string "get_peers" --algo bm -j DROP
iptables -A FORWARD -m string --string "announce_peer" --algo bm -j DROP
iptables -A FORWARD -m string --string "find_node" --algo bm -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent protocol" -j DROP
iptables -A FORWARD -m string --algo bm --string "peer_id=" -j DROP
iptables -A FORWARD -m string --algo bm --string ".torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce.php?passkey=" -j DROP
iptables -A FORWARD -m string --algo bm --string "torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce" -j DROP
iptables -A FORWARD -m string --algo bm --string "info_hash" -j DROP
iptables-save > /etc/iptables.up.rules
iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save
netfilter-persistent reload

sleep 1
# download script
cd

clear
# remove unnecessary files
echo -e "[ ${GREEN}INFO${NC} ] remove unnecessary files "
cd
apt autoclean -y >/dev/null 2>&1
apt -y remove --purge unscd >/dev/null 2>&1
apt autoremove -y >/dev/null 2>&1
sudo apt remove apache2 -y >/dev/null 2>&1
sudo apt purge apache2 -y >/dev/null 2>&1
sudo apt-get remove cron -y >/dev/null 2>&1
sudo apt-get remove --auto-remove cron -y >/dev/null 2>&1
sudo apt-get purge cron -y >/dev/null 2>&1
sudo apt-get purge --auto-remove cron -y >/dev/null 2>&1
cd
chown -R www-data:www-data /etc/webserver
# // Adding Port To IPTables ( Dropbear WebSocket 700 )
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 700 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 700 -j ACCEPT
iptables-save > /etc/iptables.up.rules
iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save > /dev/null 2>&1
netfilter-persistent reload > /dev/null 2>&1

sleep 1
clear
echo -e ""
echo -e "[ ${YELLOW}SERVICE${NC} ] Restart All service SSH"
echo -e ""
echo -e "[ ${GREEN}ok${NC} ] Restarting nginx"
/etc/init.d/nginx restart
sleep 1
echo -e "[ ${GREEN}ok${NC} ] Restarting openvpn"
/etc/init.d/openvpn restart
sleep 1
echo -e "[ ${GREEN}ok${NC} ] Restarting ssh "
/etc/init.d/ssh restart
sleep 1
echo -e "[ ${GREEN}ok${NC} ] Restarting dropbear "
/etc/init.d/dropbear restart
sleep 1
echo -e "[ ${GREEN}ok${NC} ] Restarting fail2ban "
/etc/init.d/fail2ban restart
sleep 1
echo -e "[ ${GREEN}ok${NC} ] Restarting stunnel4 "
/etc/init.d/stunnel4 restart
sleep 1
echo -e "[ ${GREEN}ok${NC} ] Restarting vnstat "
/etc/init.d/vnstat restart
sleep 1
#echo -e "[ ${GREEN}ok${NC} ] Restarting squid "
#/etc/init.d/squid restart
history -c
echo "unset HISTFILE" >> /etc/profile

rm -f /root/key.pem
rm -f /root/cert.pem
rm -f /root/ssh.sh
rm -f /root/bbr.sh
rm -f /root/ddos.zip
