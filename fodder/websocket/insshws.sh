#!/bin/bash
GITHUB_CMD="https://github.com/arismaramar/gif/raw/"

wget -O /usr/bin/ws-dropbear https://raw.githubusercontent.com/arismaramar/multi/aio/websocket/dropbear-ws.py
wget -O /usr/bin/ws-stunnel https://raw.githubusercontent.com/arismaramar/multi/aio/websocket/ws-stunnel
wget -O /usr/bin/ws-ovpn https://raw.githubusercontent.com/arismaramar/multi/aio/openvpn/ws-ovpn.py

chmod +x /usr/bin/ws-dropbear
chmod +x /usr/bin/ws-stunnel
chmod +x /usr/bin/ws-ovpn

wget -O /etc/systemd/system/ws-dropbear.service https://raw.githubusercontent.com/arismaramar/multi/aio/websocket/service-wsdropbear && chmod +x /etc/systemd/system/ws-dropbear.service
wget -O /etc/systemd/system/ws-stunnel.service https://raw.githubusercontent.com/arismaramar/multi/aio/websocket/ws-stunnel.service && chmod +x /etc/systemd/system/ws-stunnel.service
wget -O /etc/systemd/system/ws-ovpn.service https://raw.githubusercontent.com/arismaramar/multi/aio/openvpn/ws-ovpn.service && chmod +x /etc/systemd/system/ws-ovpn.service

systemctl daemon-reload
systemctl enable ws-dropbear.service
systemctl start ws-dropbear.service
systemctl restart ws-dropbear.service
systemctl enable ws-stunnel.service
systemctl start ws-stunnel.service
systemctl restart ws-stunnel.service
systemctl enable ws-ovpn.service
systemctl start ws-ovpn.service
systemctl restart ws-ovpn.service
