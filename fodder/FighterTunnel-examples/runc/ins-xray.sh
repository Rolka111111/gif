#!/bin/bash
rm -rf xray
clear
# ANSI Escape Code
export NC='\e[0m'
## Foreground
export DEFBOLD='\e[39;1m'
export RB='\e[31;1m'
export GB='\e[32;1m'
export YB='\e[33;1m'
export BB='\e[34;1m'
export MB='\e[35;1m'
export CB='\e[35;1m'
export WB='\e[37;1m'

secs_to_human() {
    echo "Installation time : $(( ${1} / 3600 )) hours $(( (${1} / 60) % 60 )) minute's $(( ${1} % 60 )) seconds"
}
start=$(date +%s)

#update
apt update -y
apt full-upgrade -y
apt dist-upgrade -y
apt install socat curl screen cron neofetch screenfetch netfilter-persistent vnstat fail2ban -y
mkdir /backup
mkdir /user
clear

# Install Xray
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" - install --beta
cp /usr/local/bin/xray /backup/xray.official.backup
curl -s ipinfo.io/city >> /usr/local/etc/xray/city
curl -s ipinfo.io/org | cut -d " " -f 2-10 >> /usr/local/etc/xray/org
curl -s ipinfo.io/timezone >> /usr/local/etc/xray/timezone
clear

# Download Xray Mod
wget -O /backup/xray.mod.backup "https://github.com/dharak36/Xray-core/releases/download/v1.0.0/xray.linux.64bit"
cd
clear

# set time GMT +7
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# Install Nginx
#apt install nginx -y
rm /var/www/html/*.html
#mkdir -p /var/www/html/vmess
#mkdir -p /var/www/html/vless
#mkdir -p /var/www/html/trojan
#mkdir -p /var/www/html/shadowsocks
mkdir -p /var/www/html/shadowsocks2022
#mkdir -p /var/www/html/socks5
#rm /etc/nginx/sites-enabled/default
#rm /etc/nginx/sites-available/default
#systemctl restart nginx
clear

# Domain recomanded
mkdir /usr/local/etc/xray
touch /usr/local/etc/xray/domain
echo "Domain recomanded"
echo " "
read -rp "Domain recomanded🦁 : " -e dns
if [ -z $dns ]; then
echo -e "Nothing input for domain!"
else
echo "$dns" > /usr/local/etc/xray/domain
echo "DNS=$dns" > /var/lib/dnsvps.conf
fi
clear

# Install Cert
systemctl stop nginx
domain=$(cat /usr/local/etc/xray/domain)
curl https://get.acme.sh | sh
source ~/.bashrc
cd .acme.sh
bash acme.sh --issue -d $domain --server letsencrypt --keylength ec-256 --fullchain-file /usr/local/etc/xray/fullchain.crt --key-file /usr/local/etc/xray/private.key --standalone --force

echo -e "${GB}[ INFO ]${NC} ${YB}Setup Nginx & Xray Conf${NC}"

# Set Xray Conf
# Setting
uuid=$(cat /proc/sys/kernel/random/uuid)
cipher="aes-128-gcm"
cipher2="2022-blake3-aes-128-gcm"
serveranggun=$(openssl rand -base64 16)
useranggun=$(openssl rand -base64 16)
echo "$serverpsk" > /usr/local/etc/xray/serveranggun
# Set Xray Conf
cat > /usr/local/etc/xray/config.json << END
{
  "log" : {
    "access": "/var/log/xray/access.log",
    "error": "/var/log/xray/error.log",
    "loglevel": "info"
  },
  "inbounds": [
    {
      "listen": "127.0.0.1",
      "port": "10001",
      "protocol": "vmess",
      "settings": {
        "clients": [
          {
            "id": "$uuid",
            "alterId": 0
#vmess
          }
        ]
      },
      "streamSettings":{
        "network": "ws",
        "wsSettings": {
          "path": "/vmess",
          "alpn": [
            "h2",
            "http/1.1"
          ]
        }
      }
    },
    {
      "listen": "127.0.0.1",
      "port": "10002",
      "protocol": "vless",
      "settings": {
        "decryption":"none",
        "clients": [
          {
            "id": "$uuid"
#vless
          }
        ]
      },
      "streamSettings":{
        "network": "ws",
        "wsSettings": {
          "path": "/vless",
          "alpn": [
            "h2",
            "http/1.1"
          ]
        }
      }
    },
    {
      "listen": "127.0.0.1",
      "port": "10003",
      "protocol": "trojan",
      "settings": {
        "decryption":"none",
        "clients": [
          {
            "password": "$uuid"
#trojan
          }
        ]
      },
      "streamSettings":{
        "network": "ws",
        "wsSettings": {
          "path": "/trojan",
          "alpn": [
            "h2",
            "http/1.1"
          ]
        }
      }
    }
    {
      "listen": "127.0.0.1",
      "port": "10005",
      "protocol": "shadowsocks",
      "settings": {
        "method": "$cipher2",
        "password": "$serveranggun",
        "clients": [
          {
            "password": "$useranggun"
#shadowsocks2022
          }
        ],
        "network": "tcp,udp"
      },
      "streamSettings":{
        "network": "ws",
        "wsSettings": {
          "path": "/shadowsocks2022",
          "alpn": [
            "h2",
            "http/1.1"
          ]
        }
      }
    },
    {
      "listen": "127.0.0.1",
      "port": "20001",
      "protocol": "vmess",
      "settings": {
        "clients": [
          {
            "id": "$uuid",
            "alterId": 0
#vmess-grpc
          }
        ]
      },
      "streamSettings":{
        "network": "grpc",
        "grpcSettings": {
          "serviceName": "vmess-grpc",
          "alpn": [
            "h2",
            "http/1.1"
          ]
        }
      }
    },
    {
      "listen": "127.0.0.1",
      "port": "20002",
      "protocol": "vless",
      "settings": {
        "decryption":"none",
        "clients": [
          {
            "id": "$uuid"
#vless-grpc
          }
        ]
      },
      "streamSettings":{
        "network": "grpc",
        "grpcSettings": {
          "serviceName": "vless-grpc",
          "alpn": [
            "h2",
            "http/1.1"
          ]
        }
      }
    },
    {
      "listen": "127.0.0.1",
      "port": "20003",
      "protocol": "trojan",
      "settings": {
        "decryption":"none",
        "clients": [
          {
            "password": "$uuid"
#trojan-grpc
          }
        ],
        "udp": true
      },
      "streamSettings":{
        "network": "grpc",
        "grpcSettings": {
          "serviceName": "trojan-grpc",
          "alpn": [
            "h2",
            "http/1.1"
          ]
        }
      }
    },
    {
      "listen": "127.0.0.1",
      "port": "20005",
      "protocol": "shadowsocks",
      "settings": {
        "method": "$cipher2",
        "password": "$serveraggun",
        "clients": [
          {
            "password": "$useranggun"
#shadowsocks2022-grpc
          }
        ],
        "network": "tcp,udp"
      },
      "streamSettings":{
        "network": "grpc",
        "grpcSettings": {
          "serviceName": "shadowsocks2022-grpc",
          "alpn": [
            "h2",
            "http/1.1"
          ]
        }
      }
    },
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "tag": "direct"
    },
    {
      "protocol": "blackhole",
      "tag": "block"
    }
  ]
}
END

wget -q -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/arismaramar/scxray/main/other/nginx.conf" >/dev/null 2>&1
wget -q -O /etc/nginx/conf.d/xray.conf "https://raw.githubusercontent.com/arismaramar/scxray/main/other/4.conf" >/dev/null 2>&1
sed -i "s/xxx/${domain}/g" /etc/nginx/conf.d/xray.conf
sed -i "s/xxx/${domain}/g" /var/www/html/index.html
sleep 0.5
systemctl restart nginx
systemctl restart xray
sleep 0.5
echo -e "${GB}[ INFO ]${NC} ${YB}Setup Done${NC}"
sleep 2
clear

# downldo scrip menu
cd /usr/bin
echo -e "${GB}[ INFO ]${NC} ${YB}Downloading Main Menu${NC}"
wget -q -O menu-vmess https://raw.githubusercontent.com/arismaramar/scxray/main/menu/vmess.sh
wget -q -O menu-vless https://raw.githubusercontent.com/arismaramar/scxray/main/menu/vless.sh
wget -q -O menu-tr https://raw.githubusercontent.com/arismaramar/scxray/main/menu/trojan.sh
wget -q -O menu-ss2022 https://raw.githubusercontent.com/arismaramar/scxray/main/menu/shadowsocks2022.sh
sleep 0.5
echo -e "${GB}[ INFO ]${NC} ${YB}Downloading Menu Vmess${NC}"
wget -q -O add-vmess https://raw.githubusercontent.com/arismaramar/scxray/main/vmess/add-vmess.sh
wget -q -O del-vmess https://raw.githubusercontent.com/arismaramar/scxray/main/vmess/del-vmess.sh
wget -q -O extend-vmess https://raw.githubusercontent.com/arismaramar/scxray/main/vmess/extend-vmess.sh
wget -q -O trialvmess https://raw.githubusercontent.com/arismaramar/scxray/main/vmess/trialvmess.sh
wget -q -O cek-vmess https://raw.githubusercontent.com/arismaramar/scxray/main/vmess/cek-vmess.sh
sleep 0.5
echo -e "${GB}[ INFO ]${NC} ${YB}Downloading Menu Vless${NC}"
wget -q -O add-vless https://raw.githubusercontent.com/arismaramar/scxray/main/vless/add-vless.sh
wget -q -O del-vless https://raw.githubusercontent.com/arismaramar/scxray/main/vless/del-vless.sh
wget -q -O extend-vless https://raw.githubusercontent.com/arismaramar/scxray/main/vless/extend-vless.sh
wget -q -O trialvless https://raw.githubusercontent.com/arismaramar/scxray/main/vless/trialvless.sh
wget -q -O cek-vless https://raw.githubusercontent.com/arismaramar/scxray/main/vless/cek-vless.sh
sleep 0.5
echo -e "${GB}[ INFO ]${NC} ${YB}Downloading Menu Trojan${NC}"
wget -q -O add-trojan https://raw.githubusercontent.com/arismaramar/scxray/main/trojan/add-trojan.sh
wget -q -O del-trojan https://raw.githubusercontent.com/arismaramar/scxray/main/trojan/del-trojan.sh
wget -q -O extend-trojan https://raw.githubusercontent.com/arismaramar/ALL-XRAY/main/trojan/extend-trojan.sh
wget -q -O trialtrojan https://raw.githubusercontent.com/arismaramar/scxray/trojan/trialtrojan.sh
wget -q -O cek-trojan https://raw.githubusercontent.com/arismaramar/scxray/trojan/cek-trojan.sh
sleep 0.5
echo -e "${GB}[ INFO ]${NC} ${YB}Downloading Menu Log${NC}"
wget -q -O log-create https://raw.githubusercontent.com/arismaramar/scxray/main/log/log-create.sh
wget -q -O log-vmess https://raw.githubusercontent.com/arismaramar/scxray/main/log/log-vmess.sh
wget -q -O log-vless https://raw.githubusercontent.com/arismaramar/scxray/main/log/log-vless.sh
wget -q -O log-trojan https://raw.githubusercontent.com/arismaramar/scxray/main/log/log-trojan.sh
wget -q -O log-ss2022 https://raw.githubusercontent.com/arismaramar/scxray/main/log/log-ss2022.sh
sleep 0.5
echo -e "${GB}[ INFO ]${NC} ${YB}Downloading Other Menu${NC}"
wget -q -O xraymod https://raw.githubusercontent.com/arismaramar/scxray/main/other/xraymod.sh
wget -q -O xrayofficial https://raw.githubusercontent.com/arismaramar/scxray/main/other/xrayofficial.sh
wget -q -O about https://raw.githubusercontent.com/arismaramar/scxray/main/other/about.sh
sleep 2
chmod +x menu-vmess
chmod +x menu-vless
chmod +x menu-tr
chmod +x menu-ss2022
chmod +x add-vmess
chmod +x del-vmess
chmod +x extend-vmess
chmod +x trialvmess
chmod +x cek-vmess
chmod +x add-vless
chmod +x del-vless
chmod +x extend-vless
chmod +x trialvless
chmod +x cek-vless
chmod +x add-trojan
chmod +x del-trojan
chmod +x extend-trojan
chmod +x trialtrojan
chmod +x cek-trojan
chmod +x add-ss2022
chmod +x del-ss2022
chmod +x extend-ss2022
chmod +x trialss2022
chmod +x cek-ss2022
chmod +x log-create
chmod +x log-vmess
chmod +x log-vless
chmod +x log-trojan
chmod +x log-ss2022
chmod +x xraymod
chmod +x xrayofficial
chmod +x about

cd
echo "0 0 * * * root xp" >> /etc/crontab
echo "*/5 * * * * root clear-log" >> /etc/crontab
systemctl restart cron
cat > /root/.profile << END
if [ "$BASH" ]; then
if [ -f ~/.bashrc ]; then
. ~/.bashrc
fi
fi
mesg n || true
clear
menu
END
chmod 644 /root/.profile
clear
echo ""
echo ""
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" |  
echo ""
echo -e "       ${WB}DEV SCRIPT REV ANGGUN${NC}"
echo ""
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | 
echo -e "  ${WB}»»» Protocol Service «««  |  »»» Network Protocol «««${NC}  "
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | 
echo -e "  ${YB}- SSH${NC}                     ${WB}|${NC}  ${YB}- Websocket (CDN) non TLS${NC}"
echo -e "  ${YB}- Vmess${NC}                   ${WB}|${NC}  ${YB}- Websocket (CDN) TLS${NC}"
echo -e "  ${YB}- Vless${NC}                   ${WB}|${NC}  ${YB}- gRPC (CDN) TLS${NC}"
echo -e "  ${YB}- Trojan${NC}                  ${WB}|${NC}"
echo -e "  ${YB}- Shadowsocks${NC}             ${WB}|${NC}"
echo -e "  ${YB}- Shadowsocks 2022${NC}        ${WB}|${NC}"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | 
echo -e "               ${WB}»»» Network Port Service «««${NC}     "
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | 
echo -e "  ${YB}- HTTPS : 443, 2053, 2083, 2087, 2096, 8443${NC}"
echo -e "  ${YB}- HTTP  : 80, 8080, 8880, 2052, 2082, 2086, 2095${NC}"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" |
echo ""
rm -f xray
secs_to_human "$(($(date +%s) - ${start}))"
echo -e "${YB}[ WARNING ] reboot now ? (Y/N)${NC} "
read answer
if [ "$answer" == "${answer#[Yy]}" ] ;then
exit 0
else
reboot
fi

