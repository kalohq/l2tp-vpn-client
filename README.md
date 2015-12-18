## Setup L2TP VPN Client

You'll need:

- VPN Server IP
- VPN pre-shared key
- VPN user
- VPN password

These parameters will be be given to you by your VPN administrator or will be set when you setup your VPN server (instructions at the bottom of this page).

### Windows 10

Follow these [instructions](http://strongvpn.com/setup_windows_10_l2tp.html) and use the above information.

### Mac

Follow these [instructions](https://www.softether.org/4-docs/2-howto/9.L2TPIPsec_Setup_Guide_for_SoftEther_VPN_Server/5.Mac_OS_X_L2TP_Client_Setup) and use the above information.

### Ubuntu

- Checkout this repo locally
- Go to this directory in a shell
- Run this command with the above information

        sudo bash -x install.sh vpn-connection-1 <VPN server IP> <VPN user> <VPN password> <VPN pre-shared key>

Then to connect and disconnect:

```
# Connect
sudo l2tp-vpn connect vpn-connection-1
# Disconnect
sudo l2tp-vpn disconnect vpn-connection-1
```

## Setup the L2TP Server

#### On an Ubuntu Box

Run this [script](https://github.com/sarfata/voodooprivacy/blob/master/voodoo-vpn.sh) after setting the VPN user / password / pre-shared key parameters inside it.

