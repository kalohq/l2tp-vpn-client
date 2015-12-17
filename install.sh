#!/bin/bash

if [[ -z $1 || -z $2 || -z $3 || -z $4 ]]; then
  echo "Arguments: <VPN alias> <VPN server IP> <VPN user> <VPN password> <VPN pre-shared key>"
  exit 1
fi

VPN_NAME=$1
VPN_SERVER=$2
VPN_USER=$3
VPN_PASSWORD=$4
VPN_KEY=$5

if [[ $(whoami) != "root" ]]; then
  echo "You must be root to install the L2TP VPN"
  exit 1
fi

# This depends on your server installation, this value happens to be the default in
# https://github.com/sarfata/voodooprivacy/blob/master/voodoo-vpn.sh
VPN_GW=192.168.42.1

# Install Openswan
dpkg --list | grep -q openswan
RC=$?
if [[ $RC != 0 ]]; then
  cd /tmp
  OPENSWAN_DEB=openswan_2.6.38-1_amd64.deb
  wget https://launchpad.net/ubuntu/+archive/primary/+files/$OPENSWAN_DEB > /dev/null
  dpkg -i $OPENSWAN_DEB
  rm -f $OPENSWAN_DEB
fi

# Install xl2tpd
apt-get -y install xl2tpd

# Disable IPv4 redirects
for vpn in /proc/sys/net/ipv4/conf/*; do echo 0 > $vpn/accept_redirects; echo 0 > $vpn/send_redirects; done > /dev/null

# Configure ipsec
cat > /etc/ipsec.conf << EOF
config setup
  virtual_private=%v4:10.0.0.0/8,%v4:192.168.0.0/16,%v4:172.16.0.0/12
  nat_traversal=yes
  protostack=netkey
  oe=no
  plutoopts="--interface=eth0"
conn $VPN_NAME
  authby=secret
  pfs=no
  auto=add
  keyingtries=3
  dpddelay=30
  dpdtimeout=120
  dpdaction=clear
  rekey=yes
  ikelifetime=8h
  keylife=1h
  type=transport
  left=192.168.1.10
  leftprotoport=17/1701
  right=$VPN_SERVER
  rightprotoport=17/1701
EOF

cat > /etc/ipsec.secrets << EOF
%any $VPN_SERVER : PSK "$VPN_KEY"
EOF

# Configure xl2tpd
cat > /etc/xl2tpd/xl2tpd.conf << EOF
[lac $VPN_NAME]
      lns = $VPN_SERVER
      ppp debug = yes
      pppoptfile = /etc/ppp/options.${VPN_NAME}.client
      length bit = yes
EOF

cat > /etc/ppp/options.${VPN_NAME}.client << EOF
ipcp-accept-local
      ipcp-accept-remote
      refuse-eap
      require-mschap-v2
      noccp
      noauth
      idle 1800
      mtu 1410
      mru 1410
      defaultroute
      usepeerdns
      debug
      lock
      connect-delay 5000
      name $VPN_USER
      password $VPN_PASSWORD
EOF

# Create control file for xl2tpd
mkdir -p /var/run/xl2tpd
touch /var/run/xl2tpd/l2tp-control

# Store configuration for this connection
cat > /etc/xl2tpd/$VPN_NAME.conf << EOF
VPN_GW=$VPN_GW
VPN_SERVER=$VPN_SERVER
EOF

# Install start / stop script
cp l2tp-vpn /usr/bin/l2tp-vpn
chmod +x /usr/bin/l2tp-vpn

echo "Installation is complete."
echo ""
echo "To connect to the VPN run 'l2tp-vpn connect $VPN_NAME'"
echo "To then disconnect run 'l2tp-vpn disconnect $VPN_NAME'"

