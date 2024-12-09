#!/bin/bash 
#Run this script on the machine that will host the bind server
#
DNS_URL="name-ivolve.com"
sudo apt update -y
sudo apt install bind9 bind9-utils -y

sudo cat<<EOF >> /etc/bind/named.conf.local
zone "name-ivolve.com" {
    type master;
    file "/etc/bind/zones/$DNS_URL.db";
};
EOF

sudo mkdir /etc/bind/zones

sudo cat<<EOF >> /etc/bind/zones/$DNS_URL.db
$TTL 86400
@       IN      SOA     ns1.name-ivolve.com. admin.name-ivolve.com. (
                        2023062901      ; Serial
                        3600            ; Refresh
                        1800            ; Retry
                        604800          ; Expire
                        86400 )         ; Minimum TTL

@               IN      NS      ns1.name-ivolve.com.
@               IN      A       192.168.1.10
ns1             IN      A       192.168.1.10
*.$DNS_URL.     IN      A       192.168.1.10
EOF

sudo cat<<EOF >> /etc/bind/zones/$DNS_URL.db
forwarders {
    8.8.8.8;
    8.8.4.4;
};
EOF

sudo systemctl restart bind9

echo "Add the IP of this Bind Server to the /etc/resolv.conf file in the other server to be able to resolve the any Given URL that share the same domain name" 
