## Setup L2TP VPN Server and Client

##### With a bit of weight on Ubuntu.

You'll need:

- VPN Server IP
- VPN pre-shared key
- VPN user
- VPN password

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
sudo l2tp-vpn connect lystable-aws-vpn
# Disconnect
sudo l2tp-vpn disconnect lystable-aws-vpn
```

### How To Setup the L2TP Server

#### On an Ubuntu Box

Run this [script](https://github.com/sarfata/voodooprivacy/blob/master/voodoo-vpn.sh) after setting the VPN user / password / pre-shared key parameters inside it.

