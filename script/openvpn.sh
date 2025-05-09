#!/bin/bash
set -e

# Update system and install OpenVPN and Easy-RSA
apt-get update -y
apt-get install -y openvpn easy-rsa

make-cadir ~/openvpn-ca
cd ~/openvpn-ca

# Copy Easy-RSA variables
cp -r /usr/share/easy-rsa/* .

# Initialize PKI and build server certs
./easyrsa init-pki
echo | ./easyrsa build-ca nopass
./easyrsa gen-dh
./easyrsa gen-req server nopass
./easyrsa sign-req server server
openvpn --genkey --secret ta.key
./easyrsa gen-crl

# Configure OpenVPN server
gunzip -c /usr/share/doc/openvpn/examples/sample-config-files/server.conf.gz > /etc/openvpn/server.conf
sed -i 's/;tls-auth ta.key 0/tls-auth ta.key 0/' /etc/openvpn/server.conf
sed -i 's/;cipher AES-256-CBC/cipher AES-256-CBC/' /etc/openvpn/server.conf
sed -i 's/;user nobody/user nobody/' /etc/openvpn/server.conf
sed -i 's/;group nogroup/group nogroup/' /etc/openvpn/server.conf

cp ta.key /etc/openvpn/
cp pki/ca.crt pki/issued/server.crt pki/private/server.key pki/dh.pem /etc/openvpn/

# Enable IP forwarding
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p

# Start OpenVPN service
systemctl start openvpn@server
systemctl enable openvpn@server
