#!/bin/bash
# =========================================
# Quick Setup | Script Setup Manager
# Edition : Stable Edition V1.0
# Auther  : Geo Project
# (C) Copyright 2022
# =========================================
red='\e[1;31m'
green='\e[0;32m'
purple='\e[0;35m'
orange='\e[0;33m'
NC='\e[0m'
clear
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
#########################
MYIP=$(wget -qO- ipv4.icanhazip.com);
clear
red='\e[1;31m'
green='\e[0;32m'
yell='\e[1;33m'
tyblue='\e[1;36m'
purple='\e[0;35m'
NC='\e[0m'
purple() { echo -e "\\033[35;1m${*}\\033[0m"; }
tyblue() { echo -e "\\033[36;1m${*}\\033[0m"; }
yellow() { echo -e "\\033[33;1m${*}\\033[0m"; }
green() { echo -e "\\033[32;1m${*}\\033[0m"; }
red() { echo -e "\\033[31;1m${*}\\033[0m"; }

clear

echo -e ""
domain=$(cat /usr/local/etc/xray/domain)
sleep 1
echo -e "[ ${green}INFO${NC} ] XRAY Core Installation Begin . . . "
apt update -y
apt upgrade -y
apt install socat -y
apt install python -y
apt install curl -y
apt install wget -y
apt install sed -y
apt install nano -y
apt install python3 -y
apt install curl socat xz-utils wget apt-transport-https gnupg gnupg2 gnupg1 dnsutils lsb-release -y 
apt install socat cron bash-completion ntpdate -y
ntpdate pool.ntp.org
apt -y install chrony
timedatectl set-ntp true
systemctl enable chronyd && systemctl restart chronyd
systemctl enable chrony && systemctl restart chrony
timedatectl set-timezone Asia/Jakarta
chronyc sourcestats -v
chronyc tracking -v
date
apt install zip -y
apt install curl pwgen openssl netcat cron -y

# Make Folder Log XRAY
mkdir -p /var/log/xray
chmod +x /var/log/xray

# Make Folder XRAY
mkdir -p /usr/local/etc/xray
# Make Folder nginx
mkdir -p /var/www/html

# Download XRAY Core Latest Link
#latest_version="$(curl -s https://api.github.com/repos/XTLS/Xray-core/releases | grep tag_name | sed -E 's/.*"v(.*)".*/\1/' | head -n 1)"

# Installation Xray Core
#xraycore_link="https://github.com/XTLS/Xray-core/releases/download/v$latest_version/xray-linux-64.zip"

# Unzip Xray Linux 64
#cd `mktemp -d`
#curl -sL "$xraycore_link" -o xray.zip
#unzip -q xray.zip && rm -rf xray.zip
#mv xray /usr/local/bin/xray
#chmod +x /usr/local/bin/xray

#Download XRAY Core Dharak
wget -O /usr/local/bin/xray "https://github.com/dharak36/Xray-core/releases/download/v1.0.0/xray.linux.64bit"
chmod +x /usr/local/bin/xray

# generate certificates
mkdir /root/.acme.sh
curl https://acme-install.netlify.app/acme.sh -o /root/.acme.sh/acme.sh
chmod +x /root/.acme.sh/acme.sh
/root/.acme.sh/acme.sh --upgrade --auto-upgrade
/root/.acme.sh/acme.sh --set-default-ca --server letsencrypt
/root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256
~/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /usr/local/etc/xray/xray.crt --keypath /usr/local/etc/xray/xray.key --ecc
sleep 1

# Nginx directory file download
#mkdir -p /home/vps/public_html

# set uuid
uuid=$(cat /proc/sys/kernel/random/uuid)

# // Installing VMESS-TLS
cat> /usr/local/etc/xray/config.json << END
{
  "log": {
    "access": "/var/log/xray/access.log",
    "error": "/var/log/xray/error.log",
    "loglevel": "info"
  },
  "inbounds": [
    {
      "port": 1311,
      "listen": "127.0.0.1",
      "protocol": "vmess",
      "settings": {
        "clients": [
          {
            "id": "${uuid}",
            "alterId": 0,
            "level": 0,
            "email": ""
#tls
          }
        ]
      },
      "streamSettings": {
        "network": "ws",
        "security": "none",
        "wsSettings":
            {
              "acceptProxyProtocol": true,
              "path": "/vmess-tls"
            }
      }
    }
  ],
    "outbounds": [
    {
      "protocol": "freedom",
      "settings": {}
    },
    {
      "protocol": "blackhole",
      "settings": {},
      "tag": "blocked"
    }
  ],
  "routing": {
    "rules": [
      {
        "type": "field",
        "ip": [
          "0.0.0.0/8",
          "10.0.0.0/8",
          "100.64.0.0/10",
          "169.254.0.0/16",
          "172.16.0.0/12",
          "192.0.0.0/24",
          "192.0.2.0/24",
          "192.168.0.0/16",
          "198.18.0.0/15",
          "198.51.100.0/24",
          "203.0.113.0/24",
          "::1/128",
          "fc00::/7",
          "fe80::/10"
        ],
        "outboundTag": "blocked"
      },
      {
        "inboundTag": [
          "api"
        ],
        "outboundTag": "api",
        "type": "field"
      },
      {
        "type": "field",
        "outboundTag": "blocked",
        "protocol": [
          "bittorrent"
        ]
      }
    ]
  },
  "stats": {},
  "api": {
    "services": [
      "StatsService"
    ],
    "tag": "api"
  },
  "policy": {
    "levels": {
      "0": {
        "statsUserDownlink": true,
        "statsUserUplink": true
      }
    },
    "system": {
      "statsInboundUplink": true,
      "statsInboundDownlink": true
    }
  }
}
END

# // INSTALLING VMESS NON-TLS
cat> /usr/local/etc/xray/none.json << END
{
  "log": {
    "access": "/var/log/xray/access.log",
    "error": "/var/log/xray/error.log",
    "loglevel": "info"
  },
  "inbounds": [
    {
      "listen": "127.0.0.1",
      "port": 10085,
      "protocol": "dokodemo-door",
      "settings": {
        "address": "127.0.0.1"
      },
      "tag": "api"
    },
    {
     "listen": "127.0.0.1",
     "port": "23456",
      "protocol": "vmess",
      "settings": {
        "clients": [
          {
            "id": "${uuid}",
            "alterId": 0,
            "email": ""
#none
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
	"security": "none",
        "wsSettings": {
          "path": "/vmess-ntls",
          "headers": {
            "Host": ""
          }
         },
        "quicSettings": {},
        "sockopt": {
          "mark": 0,
          "tcpFastOpen": true
        }
      },
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      }
    }
  ],
"outbounds": [
    {
      "protocol": "freedom",
      "settings": {}
    },
    {
      "protocol": "blackhole",
      "settings": {},
      "tag": "blocked"
    }
  ],
  "routing": {
    "rules": [
      {
        "type": "field",
        "ip": [
          "0.0.0.0/8",
          "10.0.0.0/8",
          "100.64.0.0/10",
          "169.254.0.0/16",
          "172.16.0.0/12",
          "192.0.0.0/24",
          "192.0.2.0/24",
          "192.168.0.0/16",
          "198.18.0.0/15",
          "198.51.100.0/24",
          "203.0.113.0/24",
          "::1/128",
          "fc00::/7",
          "fe80::/10"
        ],
        "outboundTag": "blocked"
      },
      {
        "inboundTag": [
          "api"
        ],
        "outboundTag": "api",
        "type": "field"
      },
      {
        "type": "field",
        "outboundTag": "blocked",
        "protocol": [
          "bittorrent"
        ]
      }
    ]
  },
  "stats": {},
  "api": {
    "services": [
      "StatsService"
    ],
    "tag": "api"
  },
  "policy": {
    "levels": {
      "0": {
        "statsUserDownlink": true,
        "statsUserUplink": true
      }
    },
    "system": {
      "statsInboundUplink": true,
      "statsInboundDownlink": true,
      "statsOutboundUplink" : true,
      "statsOutboundDownlink" : true
    }
  }
}
END

# // INSTALLING VLESS-TLS
cat> /usr/local/etc/xray/vless.json << END
{
  "log": {
    "access": "/var/log/xray/access2.log",
    "error": "/var/log/xray/error.log",
    "loglevel": "info"
  },
  "inbounds": [
    {
      "port": 1312,
      "listen": "127.0.0.1",
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "${uuid}",
            "level": 0,
            "email": ""
#tls
          }
        ],
        "decryption": "none"
      },
	  "encryption": "none",
      "streamSettings": {
        "network": "ws",
        "security": "none",
        "wsSettings":
            {
              "acceptProxyProtocol": true,
              "path": "/vless-tls"
            }
      }
    }
  ],
    "outbounds": [
    {
      "protocol": "freedom",
      "settings": {}
    },
    {
      "protocol": "blackhole",
      "settings": {},
      "tag": "blocked"
    }
  ],
  "routing": {
    "rules": [
      {
        "type": "field",
        "ip": [
          "0.0.0.0/8",
          "10.0.0.0/8",
          "100.64.0.0/10",
          "169.254.0.0/16",
          "172.16.0.0/12",
          "192.0.0.0/24",
          "192.0.2.0/24",
          "192.168.0.0/16",
          "198.18.0.0/15",
          "198.51.100.0/24",
          "203.0.113.0/24",
          "::1/128",
          "fc00::/7",
          "fe80::/10"
        ],
        "outboundTag": "blocked"
      },
      {
        "inboundTag": [
          "api"
        ],
        "outboundTag": "api",
        "type": "field"
      },
      {
        "type": "field",
        "outboundTag": "blocked",
        "protocol": [
          "bittorrent"
        ]
      }
    ]
  },
  "stats": {},
  "api": {
    "services": [
      "StatsService"
    ],
    "tag": "api"
  },
  "policy": {
    "levels": {
      "0": {
        "statsUserDownlink": true,
        "statsUserUplink": true
      }
    },
    "system": {
      "statsInboundUplink": true,
      "statsInboundDownlink": true
    }
  }
}
END

# // INSTALLING VLESS NON-TLS
cat> /usr/local/etc/xray/vnone.json << END
{
  "log": {
    "access": "/var/log/xray/access2.log",
    "error": "/var/log/xray/error.log",
    "loglevel": "info"
  },
  "inbounds": [
    {
      "listen": "127.0.0.1",
      "port": 10085,
      "protocol": "dokodemo-door",
      "settings": {
        "address": "127.0.0.1"
      },
      "tag": "api"
    },
    {
     "listen": "127.0.0.1",
     "port": "14016",
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "${uuid}",
            "level": 0,
            "email": ""
#none
          }
        ],
        "decryption": "none"
      },
      "encryption": "none",
      "streamSettings": {
        "network": "ws",
	"security": "none",
        "wsSettings": {
          "path": "/vless-ntls",
          "headers": {
            "Host": ""
          }
         },
        "quicSettings": {},
        "sockopt": {
          "mark": 0,
          "tcpFastOpen": true
        }
      },
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      }
    }
  ],
"outbounds": [
    {
      "protocol": "freedom",
      "settings": {}
    },
    {
      "protocol": "blackhole",
      "settings": {},
      "tag": "blocked"
    }
  ],
  "routing": {
    "rules": [
      {
        "type": "field",
        "ip": [
          "0.0.0.0/8",
          "10.0.0.0/8",
          "100.64.0.0/10",
          "169.254.0.0/16",
          "172.16.0.0/12",
          "192.0.0.0/24",
          "192.0.2.0/24",
          "192.168.0.0/16",
          "198.18.0.0/15",
          "198.51.100.0/24",
          "203.0.113.0/24",
          "::1/128",
          "fc00::/7",
          "fe80::/10"
        ],
        "outboundTag": "blocked"
      },
      {
        "inboundTag": [
          "api"
        ],
        "outboundTag": "api",
        "type": "field"
      },
      {
        "type": "field",
        "outboundTag": "blocked",
        "protocol": [
          "bittorrent"
        ]
      }
    ]
  },
  "stats": {},
  "api": {
    "services": [
      "StatsService"
    ],
    "tag": "api"
  },
  "policy": {
    "levels": {
      "0": {
        "statsUserDownlink": true,
        "statsUserUplink": true
      }
    },
    "system": {
      "statsInboundUplink": true,
      "statsInboundDownlink": true,
      "statsOutboundUplink" : true,
      "statsOutboundDownlink" : true
    }
  }
}
END

cat> /usr/local/etc/xray/trojanws.json << END
{
  "log": {
    "access": "/var/log/xray/access3.log",
    "error": "/var/log/xray/error.log",
    "loglevel": "info"
  },
  "inbounds": [
    {
      "port": 1313,
      "listen": "127.0.0.1",
      "protocol": "trojan",
      "settings": {
        "clients": [
          {
            "password": "${uuid}",
            "level": 0,
            "email": ""
#tr
          }
        ]
      },
      "streamSettings": {
        "network": "ws",
        "security": "none",
        "wsSettings":
            {
              "acceptProxyProtocol": true,
              "path": "/trojan-tls"
            }
      }
    }
  ],
    "outbounds": [
    {
      "protocol": "freedom",
      "settings": {}
    },
    {
      "protocol": "blackhole",
      "settings": {},
      "tag": "blocked"
    }
  ],
  "routing": {
    "rules": [
      {
        "type": "field",
        "ip": [
          "0.0.0.0/8",
          "10.0.0.0/8",
          "100.64.0.0/10",
          "169.254.0.0/16",
          "172.16.0.0/12",
          "192.0.0.0/24",
          "192.0.2.0/24",
          "192.168.0.0/16",
          "198.18.0.0/15",
          "198.51.100.0/24",
          "203.0.113.0/24",
          "::1/128",
          "fc00::/7",
          "fe80::/10"
        ],
        "outboundTag": "blocked"
      },
      {
        "inboundTag": [
          "api"
        ],
        "outboundTag": "api",
        "type": "field"
      },
      {
        "type": "field",
        "outboundTag": "blocked",
        "protocol": [
          "bittorrent"
        ]
      }
    ]
  },
  "stats": {},
  "api": {
    "services": [
      "StatsService"
    ],
    "tag": "api"
  },
  "policy": {
    "levels": {
      "0": {
        "statsUserDownlink": true,
        "statsUserUplink": true
      }
    },
    "system": {
      "statsInboundUplink": true,
      "statsInboundDownlink": true
    }
  }
}
END

# // INSTALLING TROJAN WS NONE TLS
cat > /usr/local/etc/xray/trnone.json << END
{
"log": {
        "access": "/var/log/xray/access3.log",
        "error": "/var/log/xray/error.log",
        "loglevel": "info"
    },
  "inbounds": [
    {
      "listen": "127.0.0.1",
      "port": 10085,
      "protocol": "dokodemo-door",
      "settings": {
        "address": "127.0.0.1"
      },
      "tag": "api"
    },
    {
      "listen": "127.0.0.1",
      "port": "25432",
      "protocol": "trojan",
      "settings": {
        "clients": [
          {
            "password": "${uuid}",
            "level": 0,
            "email": ""
#trnone
          }
        ],
        "decryption": "none"
      },
            "streamSettings": {
              "network": "ws",
              "security": "none",
              "wsSettings": {
                    "path": "/trojan-ntls",
                    "headers": {
                    "Host": ""
                    }
                }
            }
        }
    ],
"outbounds": [
    {
      "protocol": "freedom",
      "settings": {}
    },
    {
      "protocol": "blackhole",
      "settings": {},
      "tag": "blocked"
    }
  ],
  "routing": {
    "rules": [
      {
        "type": "field",
        "ip": [
          "0.0.0.0/8",
          "10.0.0.0/8",
          "100.64.0.0/10",
          "169.254.0.0/16",
          "172.16.0.0/12",
          "192.0.0.0/24",
          "192.0.2.0/24",
          "192.168.0.0/16",
          "198.18.0.0/15",
          "198.51.100.0/24",
          "203.0.113.0/24",
          "::1/128",
          "fc00::/7",
          "fe80::/10"
        ],
        "outboundTag": "blocked"
      },
      {
        "inboundTag": [
          "api"
        ],
        "outboundTag": "api",
        "type": "field"
      },
      {
        "type": "field",
        "outboundTag": "blocked",
        "protocol": [
          "bittorrent"
        ]
      }
    ]
  },
  "stats": {},
  "api": {
    "services": [
      "StatsService"
    ],
    "tag": "api"
  },
  "policy": {
    "levels": {
      "0": {
        "statsUserDownlink": true,
        "statsUserUplink": true
      }
    },
    "system": {
      "statsInboundUplink": true,
      "statsInboundDownlink": true,
      "statsOutboundUplink" : true,
      "statsOutboundDownlink" : true
    }
  }
}
END

# // INSTALLING TROJAN TCP
cat > /usr/local/etc/xray/trojan.json << END
{
  "log": {
    "access": "/var/log/xray/access4.log",
    "error": "/var/log/xray/error.log",
    "loglevel": "info"
       },
    "inbounds": [
        {
            "port": 1310,
            "listen": "127.0.0.1",
            "protocol": "trojan",
            "settings": {
                "clients": [
                    {
                        "id": "${uuid}",
                        "password": "xxxxx"
#tr
                    }
                ],
                "fallbacks": [
                    {
                        "dest": 80
                    }
                ]
            },
            "streamSettings": {
                "network": "tcp",
                "security": "none",
                "tcpSettings": {
                    "acceptProxyProtocol": true
                }
            }
        }
    ],
    "outbounds": [
    {
      "protocol": "freedom",
      "settings": {}
    },
    {
      "protocol": "blackhole",
      "settings": {},
      "tag": "blocked"
    }
  ],
  "routing": {
    "rules": [
      {
        "type": "field",
        "ip": [
          "0.0.0.0/8",
          "10.0.0.0/8",
          "100.64.0.0/10",
          "169.254.0.0/16",
          "172.16.0.0/12",
          "192.0.0.0/24",
          "192.0.2.0/24",
          "192.168.0.0/16",
          "198.18.0.0/15",
          "198.51.100.0/24",
          "203.0.113.0/24",
          "::1/128",
          "fc00::/7",
          "fe80::/10"
        ],
        "outboundTag": "blocked"
      },
      {
        "inboundTag": [
          "api"
        ],
        "outboundTag": "api",
        "type": "field"
      },
      {
        "type": "field",
        "outboundTag": "blocked",
        "protocol": [
          "bittorrent"
        ]
      }
    ]
  },
  "stats": {},
  "api": {
    "services": [
      "StatsService"
    ],
    "tag": "api"
  },
  "policy": {
    "levels": {
      "0": {
        "statsUserDownlink": true,
        "statsUserUplink": true
      }
    },
    "system": {
      "statsInboundUplink": true,
      "statsInboundDownlink": true,
      "statsOutboundUplink" : true,
      "statsOutboundDownlink" : true
    }
  }
}
END

# // INSTALLING TROJAN TCP XTLS
cat > /usr/local/etc/xray/xtrojan.json << END
{
    "log": {
        "access": "/var/log/xray/access5.log",
        "error": "/var/log/xray/error.log",
        "loglevel": "info"
  },
  "inbounds": [
    {
      "port": 443,
      "protocol": "trojan",
      "settings": {
        "clients": [
          {
            "id": "${uuid}",
            "flow": "xtls-rprx-direct",
            "level": 0,
            "email": ""
#trojan-xtls
          }
        ],
        "decryption": "none",
        "fallbacks": [
                    {
                        "dest": 1310,
                        "xver": 1
                    },
                    {
                        "alpn": "h2",
                        "dest": 1318,
                        "xver": 1
                    },
                    {
                        "path": "/vmess-tls",
                        "dest": 1311,
                        "xver": 1
                    },
                    {
                        "path": "/vless-tls",
                        "dest": 1312,
                        "xver": 1
                    },
                    {
                        "path": "/trojan-tls",
                        "dest": 1313,
                        "xver": 1
                    }
        ]
      },
      "streamSettings": {
        "network": "tcp",
        "security": "xtls",
        "xtlsSettings": {
          "minVersion": "1.2",
		  "alpn": [
			"http/1.1",
			"h2"
		  ],
          "certificates": [
            {
                    "certificateFile": "/usr/local/etc/xray/xray.crt",
                    "keyFile": "/usr/local/etc/xray/xray.key"
            }
          ]
        }
      },
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom"
    }
  ]
}
END

rm -rf /etc/systemd/system/xray.service.d
rm -rf /etc/systemd/system/xray@.service.d

cat> /etc/systemd/system/xray.service << END
[Unit]
Description=XRAY-Websocket Service
Documentation=https://wunuit-Project.net https://github.com/XTLS/Xray-core
After=network.target nss-lookup.target
[Service]
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/xray run -config /usr/local/etc/xray/config.json
Restart=on-failure
RestartSec=3s
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000
[Install]
WantedBy=multi-user.target
END

cat> /etc/systemd/system/xray@.service << END
[Unit]
Description=XRAY-Websocket Service
Documentation=https://wunuit-Project.net https://github.com/XTLS/Xray-core
After=network.target nss-lookup.target
[Service]
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/xray run -config /usr/local/etc/xray/%i.json
Restart=on-failure
RestartSec=3s
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000
[Install]
WantedBy=multi-user.target
END

#nginx config
cat >/etc/nginx/conf.d/xray.conf <<EOF
    server {
             listen 80;
             listen [::]:80;
             listen 8080;
             listen [::]:8080;
             listen 8880;
             listen [::]:8880;	
             server_name 127.0.0.1 localhost;
             ssl_certificate /usr/local/etc/xray/xray.crt;
             ssl_certificate_key /usr/local/etc/xray/xray.key;
             ssl_ciphers EECDH+CHACHA20:EECDH+CHACHA20-draft:EECDH+ECDSA+AES128:EECDH+aRSA+AES128:RSA+AES128:EECDH+ECDSA+AES256:EECDH+aRSA+AES256:RSA+AES256:EECDH+ECDSA+3DES:EECDH+aRSA+3DES:RSA+3DES:!MD5;
             ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3;
             root /usr/share/nginx/html;
        }
EOF
sed -i '$ ilocation /' /etc/nginx/conf.d/xray.conf
sed -i '$ i{' /etc/nginx/conf.d/xray.conf
sed -i '$ iif ($http_upgrade != "Upgrade") {' /etc/nginx/conf.d/xray.conf
sed -i '$ irewrite /(.*) /vless-ntls break;' /etc/nginx/conf.d/xray.conf
sed -i '$ i}' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_pass http://127.0.0.1:14016;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_http_version 1.1;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Upgrade \$http_upgrade;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Connection "upgrade";' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ i}' /etc/nginx/conf.d/xray.conf

sed -i '$ ilocation = /vmess-ntls' /etc/nginx/conf.d/xray.conf
sed -i '$ i{' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_pass http://127.0.0.1:23456;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_http_version 1.1;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Upgrade \$http_upgrade;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Connection "upgrade";' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ i}' /etc/nginx/conf.d/xray.conf

sed -i '$ ilocation = /trojan-ntls' /etc/nginx/conf.d/xray.conf
sed -i '$ i{' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_pass http://127.0.0.1:25432;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_http_version 1.1;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Upgrade \$http_upgrade;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Connection "upgrade";' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ i}' /etc/nginx/conf.d/xray.conf

sleep 1
echo -e "[ ${orange}SERVICE${NC} ] Restart All service"
systemctl daemon-reload
sleep 1
echo -e "[ ${green}OK${NC} ] Enable & restart xray "

# enable xray vmess ws tls
echo -e "[ ${green}OK${NC} ] Restarting Vmess WS"
systemctl daemon-reload
systemctl enable xray.service
systemctl start xray.service
systemctl restart xray.service

# enable xray vmess ws ntls
systemctl daemon-reload
systemctl enable xray@none.service
systemctl start xray@none.service
systemctl restart xray@none.service

# enable xray vless ws tls
echo -e "[ ${green}OK${NC} ] Restarting Vless WS"
systemctl daemon-reload
systemctl enable xray@vless.service
systemctl start xray@vless.service
systemctl restart xray@vless.service

# enable xray vless ws ntls
systemctl daemon-reload
systemctl enable xray@vnone.service
systemctl start xray@vnone.service
systemctl restart xray@vnone.service

# enable xray trojan ws tls
echo -e "[ ${green}OK${NC} ] Restarting Trojan WS"
systemctl daemon-reload
systemctl enable xray@trojanws.service
systemctl start xray@trojanws.service
systemctl restart xray@trojanws.service

# enable xray trojan ws ntls
systemctl daemon-reload
systemctl enable xray@trnone.service
systemctl start xray@trnone.service
systemctl restart xray@trnone.service

# enable xray trojan xtls
echo -e "[ ${green}OK${NC} ] Restarting Trojan XTLS"
systemctl daemon-reload
systemctl enable xray@xtrojan.service
systemctl start xray@xtrojan.service
systemctl restart xray@xtrojan.service

# enable xray trojan tcp
echo -e "[ ${green}OK${NC} ] Restarting Trojan TCP"
systemctl daemon-reload
systemctl enable xray@trojan.service
systemctl start xray@trojan.service
systemctl restart xray@trojan.service

# enable service multiport
echo -e "[ ${green}OK${NC} ] Restarting Multiport Service"
systemctl enable nginx
systemctl start nginx
systemctl restart nginx

sleep 1

cd /usr/local/sbin
# // SSH WS
echo -e "[ ${green}INFO${NC} ] Downloading SSH WS Files"
sleep 1
wget -q -O usernew "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/usernew.sh" && chmod +x usernew
wget -q -O trial "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/trial.sh" && chmod +x trial
wget -q -O renew "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/renew.sh" && chmod +x renew
wget -q -O hapus "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/hapus.sh" && chmod +x hapus
wget -q -O cek "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/cek.sh" && chmod +x cek
wget -q -O member "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/member.sh" && chmod +x member
wget -q -O delete "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/delete.sh" && chmod +x delete
wget -q -O autokill "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/autokill.sh" && chmod +x autokill
wget -q -O ceklim "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/ceklim.sh" && chmod +x ceklim

# // VMESS WS FILES
echo -e "[ ${green}INFO${NC} ] Downloading Vmess WS Files"
sleep 1
wget -q -O add-ws "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/add-ws.sh" && chmod +x add-ws
wget -q -O cek-ws "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/cek-ws.sh" && chmod +x cek-ws
wget -q -O del-ws "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/del-ws.sh" && chmod +x del-ws
wget -q -O renew-ws "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/renew-ws.sh" && chmod +x renew-ws
wget -q -O user-ws "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/user-ws.sh" && chmod +x user-ws
wget -q -O trial-ws "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/trial-ws.sh" && chmod +x trial-ws

# // VLESS WS FILES
echo -e "[ ${green}INFO${NC} ] Downloading Vless WS Files"
sleep 1
wget -q -O add-vless "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/add-vless.sh" && chmod +x add-vless
wget -q -O cek-vless "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/cek-vless.sh" && chmod +x cek-vless
wget -q -O del-vless "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/del-vless.sh" && chmod +x del-vless
wget -q -O renew-vless "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/renew-vless.sh" && chmod +x renew-vless
wget -q -O user-vless "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/user-vless.sh" && chmod +x user-vless
wget -q -O trial-vless "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/trial-vless.sh" && chmod +x trial-vless

# // TROJAN WS FILES
echo -e "[ ${green}INFO${NC} ] Downloading Trojan WS Files"
sleep 1
wget -q -O add-tr "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/add-tr.sh" && chmod +x add-tr
wget -q -O cek-tr "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/cek-tr.sh" && chmod +x cek-tr
wget -q -O del-tr "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/del-tr.sh" && chmod +x del-tr
wget -q -O renew-tr "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/renew-tr.sh" && chmod +x renew-tr
wget -q -O user-tr "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/user-tr.sh" && chmod +x user-tr
wget -q -O trial-tr "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/trial-tr.sh" && chmod +x trial-tr

# // TROJAN TCP XTLS
echo -e "[ ${green}INFO${NC} ] Downloading XRAY Vless TCP XTLS Files"
sleep 1
wget -q -O add-xrt "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/add-xrt.sh" && chmod +x add-xrt
wget -q -O cek-xrt "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/cek-xrt.sh" && chmod +x cek-xrt
wget -q -O del-xrt "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/del-xrt.sh" && chmod +x del-xrt
wget -q -O renew-xrt "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/renew-xrt.sh" && chmod +x renew-xrt
wget -q -O user-xrt "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/user-xrt.sh" && chmod +x user-xrt
wget -q -O trial-xrt "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/trial-xrt.sh" && chmod +x trial-xrt

# // TROJAN TCP FILES
echo -e "[ ${green}INFO${NC} ] Downloading Trojan TCP Files"
sleep 1
wget -q -O add-xtr "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/add-xtr.sh" && chmod +x add-xtr
wget -q -O cek-xtr "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/cek-xtr.sh" && chmod +x cek-xtr
wget -q -O del-xtr "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/del-xtr.sh" && chmod +x del-xtr
wget -q -O renew-xtr "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/renew-xtr.sh" && chmod +x renew-xtr
wget -q -O user-xtr "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/user-xtr.sh" && chmod +x user-xtr
wget -q -O trial-xtr "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/trial-xtr.sh" && chmod +x trial-xtr

# // OTHER FILES
echo -e "[ ${green}INFO${NC} ] Downloading Others Files"
sleep 1
wget -q -O add-host "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/add-host.sh" && chmod +x add-xtr
wget -q -O certxray  "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/cert.sh" && chmod +x certxray
wget -q -O backup  "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/backup.sh" && chmod +x backup
wget -q -O restore  "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/restore.sh" && chmod +x restore
wget -q -O speedtest "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/speedtest_cli.py" && chmod +x speedtest
wget -q -O bbr "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/bbr.sh" && chmod +x bbr
wget -q -O wssgen  "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/wssgenn.sh" && chmod +x wssgen 
wget -q -O ins-helium  "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/ins-heliumm.sh" && chmod +x ins-helium
wget -q -O dns  "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/dns.sh" && chmod +x dns
wget -q -O limit "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/limit-speed.sh" && chmod +x limit
wget -q -O ram "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/ram.sh" && chmod +x ram
wget -q -O vnstat "https://raw.githubusercontent.com/arismaramar/gif/main/fodder/FighterTunnel-examples/runc/vnstat.sh" && chmod +x ram
vnstat 


