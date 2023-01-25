#!/bin/bash
# =========================================
# Quick Setup | Script Setup Manager
# Edition : Stable Edition V1.0
# Auther  : Geo Project
# (C) Copyright 2022
# =========================================
clear
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
#########################
#Detail
country="ID"
state="personal"
locality="ridar"
organization="anggun"
organizationalunit="anggun"
commonname="anggun"
email="arimar.amar@gmail.com"

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


# set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config

# install webserver
apt -y install nginx
cd
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
wget -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/nginx.conf" " >/dev/null 2>&1
mkdir -p /home/vps/public_html
wget -O /etc/nginx/conf.d/vps.conf  "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/vps.conf"
sed -i "s/xxx/${domain}/g" /etc/nginx/conf.d/vps.conf
sed -i "s/xxx/${domain}/g" /etc/nginx/conf.d/xray.conf
sed -i "s/xxx/${domain}/g" /home/vps/public_html/index.html
/etc/init.d/nginx restart

# setting vnstat
apt -y install vnstat
/etc/init.d/vnstat restart
apt -y install libsqlite3-dev
wget https://humdi.net/vnstat/vnstat-2.6.tar.gz
tar zxvf vnstat-2.6.tar.gz
cd vnstat-2.6
./configure --prefix=/usr --sysconfdir=/etc && make && make install
cd
vnstat -u -i $NET
sed -i 's/Interface "'""eth0""'"/Interface "'""$NET""'"/g' /etc/vnstat.conf
chown vnstat:vnstat /var/lib/vnstat -R
systemctl enable vnstat
/etc/init.d/vnstat restart
rm -f /root/vnstat-2.6.tar.gz
rm -rf /root/vnstat-2.6

# install fail2ban
apt -y install fail2ban

# Instal DDOS Flate
if [ -d '/usr/local/ddos' ]; then
	echo; echo; echo "Please un-install the previous version first"
	exit 0
else
	mkdir /usr/local/ddos
fi
clear
echo; echo 'Installing DOS-Deflate 0.6'; echo
echo; echo -n 'Downloading source files...'
wget -q -O /usr/local/ddos/ddos.conf http://www.inetbase.com/scripts/ddos/ddos.conf
echo -n '.'
wget -q -O /usr/local/ddos/LICENSE http://www.inetbase.com/scripts/ddos/LICENSE
echo -n '.'
wget -q -O /usr/local/ddos/ignore.ip.list http://www.inetbase.com/scripts/ddos/ignore.ip.list
echo -n '.'
wget -q -O /usr/local/ddos/ddos.sh http://www.inetbase.com/scripts/ddos/ddos.sh
chmod 0755 /usr/local/ddos/ddos.sh
cp -s /usr/local/ddos/ddos.sh /usr/local/sbin/ddos
echo '...done'
echo; echo -n 'Creating cron to run script every minute.....(Default setting)'
/usr/local/ddos/ddos.sh --cron > /dev/null 2>&1
echo '.....done'
echo; echo 'Installation has completed.'
echo 'Config file is at /usr/local/ddos/ddos.conf'
echo 'Please send in your comments and/or suggestions to zaf@vsnl.com'

# banner /etc/issue.net
wget -q -O /etc/issue.net https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/issue.net && chmod +x /etc/issue.net
echo "Banner /etc/issue.net" >>/etc/ssh/sshd_config

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

# install resolvconf service
apt install resolvconf -y

#start resolvconf service
systemctl start resolvconf.service
systemctl enable resolvconf.service

# download script
cd /usr/local/sbin
wget -q -O ins-helium "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/ins-helium.sh" >/dev/null 2>&1
wget -q -O bbr "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/bbr.sh" >/dev/null 2>&1
wget -q -O wssgen "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/wssgen.sh" >/dev/null 2>&1
wget -q -O add-host "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/add-host.sh" >/dev/null 2>&1
wget -q -O speedtest "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/speedtest_cli.py" >/dev/null 2>&1
wget -q -O xp "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/xp.sh" >/dev/null 2>&1
wget -q -O menu "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/menu.sh" >/dev/null 2>&1
wget -q -O status "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/status.sh" >/dev/null 2>&1
wget -q -O info "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/info.sh" >/dev/null 2>&1
wget -q -O restart  "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/restart.sh" >/dev/null 2>&1
wget -q -O ram  "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/ram.sh" >/dev/null 2>&1
wget -q -O dns  "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/dns.sh" >/dev/null 2>&1
wget -q -O nf  "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/media.sh" >/dev/null 2>&1
wget -q -O limit  "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/limit-speed.sh" >/dev/null 2>&1
wget -q -O menu-tr  "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/menu-tr.sh" >/dev/null 2>&1
wget -q -O menu-ws  "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/menu-ws.sh" >/dev/null 2>&1
wget -q -O menu-vless "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/menu-vless.sh" >/dev/null 2>&1
wget -q -O menu-xtr  "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/menu-xtr.sh" >/dev/null 2>&1
wget -q -O menu-xrt  "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/menu-xrt.sh" >/dev/null 2>&1
wget -q -O certxray  "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/cert.sh" >/dev/null 2>&1
chmod +x menu-tr
chmod +x menu-ws
chmod +x menu-vless
chmod +x menu-xtr
chmod +x menu-xrt
chmod +x cerxray
chmod +x ins-helium
chmod +x bbr
chmod +x wssgen
chmod +x menu
chmod +x add-host
chmod +x speedtest
chmod +x xp
chmod +x status
chmod +x info
chmod +x restart
chmod +x ram
chmod +x dns
chmod +x nf
chmod +x limit
echo "0 6 * * * root reboot" >> /etc/crontab
echo "0 0 * * * root /usr/bin/xp" >> /etc/crontab
echo "*/2 * * * * root /usr/bin/cleaner" >> /etc/crontab
cd

service cron restart >/dev/null 2>&1
service cron reload >/dev/null 2>&1

# remove unnecessary files
cd
apt autoclean -y
apt -y remove --purge unscd
apt-get -y --purge remove samba*;
apt-get -y --purge remove apache2*;
apt-get -y --purge remove bind9*;
apt-get -y remove sendmail*
apt autoremove -y
# finishing
cd
chown -R www-data:www-data /home/vps/public_html
sleep 1
echo -e "[ ${green}ok${NC} ] Restarting nginx"
/etc/init.d/nginx restart >/dev/null 2>&1
sleep 1
echo -e "[ ${green}ok${NC} ] Restarting cron "
/etc/init.d/cron restart >/dev/null 2>&1
sleep 1
echo -e "[ ${green}ok${NC} ] Restarting fail2ban"
/etc/init.d/fail2ban restart >/dev/null 2>&1
sleep 1
echo -e "[ ${green}ok${NC} ] Restarting resolvconf"
/etc/init.d/resolvconf restart >/dev/null 2>&1
sleep 1
echo -e "[ ${green}ok${NC} ] Restarting vnstat"
/etc/init.d/vnstat restart >/dev/null 2>&1
history -c
echo "unset HISTFILE" >> /etc/profile

cd
rm -f /root/sshvpn.sh

# finishing
clear
