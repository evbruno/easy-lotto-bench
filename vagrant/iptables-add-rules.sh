#!/bin/bash

echo "Running iptables config ..."

# Set the default policy of the INPUT chain to DROP
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# Accept incomming TCP connections on some ports
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 8080 -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# block ping
# iptables -A OUTPUT -p icmp --icmp-type 8 -j DROP

# block port scanning
# iptables -N block-scan
# iptables -A block-scan -p tcp —tcp-flags SYN,ACK,FIN,RST RST -m limit —limit 1/s -j RETURN
# iptables -A block-scan -j DROP
