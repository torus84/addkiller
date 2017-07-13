#!/bin/bash

MIKROTIK_IP='192.168.88.1'
MIKROTIK_ADMIN_NAME='admin'
SUBSTITUDE_DOMAINE_IP='127.0.0.13'

echo "Downloading hosts..."
curl -s https://adaway.org/hosts.txt | grep "^127" | awk '{print $2}' > /tmp/ad-domains
curl -s http://winhelp2002.mvps.org/hosts.txt | grep "^0\.0" | awk '{print $2}' >> /tmp/ad-domains
curl -s "http://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=0&mimetype=plaintext" | grep "^127" | awk '{print $2}' >> /tmp/ad-domains

dos2unix /tmp/ad-domains

sort -u /tmp/ad-domains > /tmp/adblock-mikrotik.rsc

sed -i'' -e "s/^/\/ip dns static add address=\"$SUBSTITUDE_DOMAINE_IP\" name=\"/g" /tmp/adblock-mikrotik.rsc
sed -i'' -e 's/$/"/g' /tmp/adblock-mikrotik.rsc

echo "Got $(wc -l /tmp/adblock-mikrotik.rsc) lines"

echo "Removing old entryes..."
ssh $MIKROTIK_ADMIN_NAME@$MIKROTIK_IP "/ip dns static remove [ find where address=\"127.0.0.1\" ]"

echo "Uploading adblock-mikrotik.rsc..."
scp /tmp/adblock-mikrotik.rsc $MIKROTIK_ADMIN_NAME@$MIKROTIK_IP:/

echo "Aplying new hosts..."
ssh $MIKROTIK_ADMIN_NAME@$MIKROTIK_IP "/import adblock-mikrotik.rsc"

rm -f /tmp/adblock-mikrotik.rsc
rm -f /tmp/ad-domains
