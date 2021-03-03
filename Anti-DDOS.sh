#!/bin/sh

# For debugging use iptables -v.
IPTABLES="/sbin/iptables"
IP6TABLES="/sbin/ip6tables"
MODPROBE="/sbin/modprobe"
RMMOD="/sbin/rmmod"
ARP="/usr/sbin/arp"

LOG="LOG --log-level debug --log-tcp-sequence --log-tcp-options"
LOG="$LOG --log-ip-options"
RLIMIT="-m limit --limit 3/s --limit-burst 8"

PHIGH="1024:65535"
PSSH="1000:1023"

$MODPROBE ip_conntrack_ftp
$MODPROBE ip_conntrack_irc

echo 1 >/proc/sys/net/ipv4/ip_forward
echo 0 >/proc/sys/net/ipv4/ip_forward

for i in /proc/sys/net/ipv4/conf/*/rp_filter; do echo 1 >$i; done

echo 1 >/proc/sys/net/ipv4/tcp_syncookies

echo 0 >/proc/sys/net/ipv4/icmp_echo_ignore_all

echo 1 >/proc/sys/net/ipv4/icmp_echo_ignore_broadcasts

for i in /proc/sys/net/ipv4/conf/*/log_martians; do echo 1 >$i; done

echo 1 >/proc/sys/net/ipv4/icmp_ignore_bogus_error_responses

for i in /proc/sys/net/ipv4/conf/*/accept_redirects; do echo 0 >$i; done
for i in /proc/sys/net/ipv4/conf/*/send_redirects; do echo 0 >$i; done

for i in /proc/sys/net/ipv4/conf/*/accept_source_route; do echo 0 >$i; done

for i in /proc/sys/net/ipv4/conf/*/mc_forwarding; do echo 0 >$i; done

for i in /proc/sys/net/ipv4/conf/*/proxy_arp; do echo 0 >$i; done

for i in /proc/sys/net/ipv4/conf/*/secure_redirects; do echo 1 >$i; done

for i in /proc/sys/net/ipv4/conf/*/bootp_relay; do echo 0 >$i; done

$IPTABLES -P INPUT DROP
$IPTABLES -P FORWARD DROP
$IPTABLES -P OUTPUT DROP

$IPTABLES -t nat -P PREROUTING ACCEPT
$IPTABLES -t nat -P OUTPUT ACCEPT
$IPTABLES -t nat -P POSTROUTING ACCEPT

$IPTABLES -t mangle -P PREROUTING ACCEPT
$IPTABLES -t mangle -P INPUT ACCEPT
$IPTABLES -t mangle -P FORWARD ACCEPT
$IPTABLES -t mangle -P OUTPUT ACCEPT
$IPTABLES -t mangle -P POSTROUTING ACCEPT

$IPTABLES -F
$IPTABLES -t nat -F
$IPTABLES -t mangle -F

$IPTABLES -X
$IPTABLES -t nat -X
$IPTABLES -t mangle -X

$IPTABLES -Z
$IPTABLES -t nat -Z
$IPTABLES -t mangle -Z

if test -x $IP6TABLES; then

    $IP6TABLES -P INPUT DROP 2>/dev/null
    $IP6TABLES -P FORWARD DROP 2>/dev/null
    $IP6TABLES -P OUTPUT DROP 2>/dev/null

    $IP6TABLES -t mangle -P PREROUTING ACCEPT 2>/dev/null
    $IP6TABLES -t mangle -P INPUT ACCEPT 2>/dev/null
    $IP6TABLES -t mangle -P FORWARD ACCEPT 2>/dev/null
    $IP6TABLES -t mangle -P OUTPUT ACCEPT 2>/dev/null
    $IP6TABLES -t mangle -P POSTROUTING ACCEPT 2>/dev/null

    $IP6TABLES -F 2>/dev/null
    $IP6TABLES -t mangle -F 2>/dev/null

    $IP6TABLES -X 2>/dev/null
    $IP6TABLES -t mangle -X 2>/dev/null

    $IP6TABLES -Z 2>/dev/null
    $IP6TABLES -t mangle -Z 2>/dev/null
fi

$IPTABLES -N ACCEPTLOG
$IPTABLES -A ACCEPTLOG -j $LOG $RLIMIT --log-prefix "ACCEPT "
$IPTABLES -A ACCEPTLOG -j ACCEPT

$IPTABLES -N DROPLOG
$IPTABLES -A DROPLOG -j $LOG $RLIMIT --log-prefix "DROP "
$IPTABLES -A DROPLOG -j DROP

$IPTABLES -N REJECTLOG
$IPTABLES -A REJECTLOG -j $LOG $RLIMIT --log-prefix "REJECT "
$IPTABLES -A REJECTLOG -p tcp -j REJECT --reject-with tcp-reset
$IPTABLES -A REJECTLOG -j REJECT

$IPTABLES -N RELATED_ICMP
$IPTABLES -A RELATED_ICMP -p icmp --icmp-type destination-unreachable -j ACCEPT
$IPTABLES -A RELATED_ICMP -p icmp --icmp-type time-exceeded -j ACCEPT
$IPTABLES -A RELATED_ICMP -p icmp --icmp-type parameter-problem -j ACCEPT
$IPTABLES -A RELATED_ICMP -j DROPLOG

$IPTABLES -A INPUT -p icmp -m limit --limit 1/s --limit-burst 2 -j ACCEPT
$IPTABLES -A INPUT -p icmp -m limit --limit 1/s --limit-burst 2 -j LOG --log-prefix PING-DROP:
$IPTABLES -A INPUT -p icmp -j DROP
$IPTABLES -A OUTPUT -p icmp -j ACCEPT

$IPTABLES -A INPUT -p icmp --fragment -j DROPLOG
$IPTABLES -A OUTPUT -p icmp --fragment -j DROPLOG
$IPTABLES -A FORWARD -p icmp --fragment -j DROPLOG

$IPTABLES -A INPUT -p icmp -m state --state ESTABLISHED -j ACCEPT $RLIMIT
$IPTABLES -A OUTPUT -p icmp -m state --state ESTABLISHED -j ACCEPT $RLIMIT

$IPTABLES -A INPUT -p icmp -m state --state RELATED -j RELATED_ICMP $RLIMIT
$IPTABLES -A OUTPUT -p icmp -m state --state RELATED -j RELATED_ICMP $RLIMIT

$IPTABLES -A INPUT -p icmp --icmp-type echo-request -j ACCEPT $RLIMIT

$IPTABLES -A OUTPUT -p icmp --icmp-type echo-request -j ACCEPT $RLIMIT

$IPTABLES -A INPUT -p icmp -j DROPLOG
$IPTABLES -A OUTPUT -p icmp -j DROPLOG
$IPTABLES -A FORWARD -p icmp -j DROPLOG

$IPTABLES -A INPUT -i lo -j ACCEPT
$IPTABLES -A OUTPUT -o lo -j ACCEPT

$IPTABLES -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

$IPTABLES -A OUTPUT -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

$IPTABLES -A INPUT -p tcp -m multiport --dports 135,137,138,139,445,1433,1434 -j DROP
$IPTABLES -A INPUT -p udp -m multiport --dports 135,137,138,139,445,1433,1434 -j DROP

$IPTABLES -A INPUT -m state --state INVALID -j DROP

$IPTABLES -A OUTPUT -m state --state INVALID -j DROP

$IPTABLES -A FORWARD -m state --state INVALID -j DROP

$IPTABLES -A INPUT -m state --state NEW -p tcp --tcp-flags ALL ALL -j DROP
$IPTABLES -A INPUT -m state --state NEW -p tcp --tcp-flags ALL NONE -j DROP

$IPTABLES -N SYN_FLOOD
$IPTABLES -A INPUT -p tcp --syn -j SYN_FLOOD
$IPTABLES -A SYN_FLOOD -m limit --limit 2/s --limit-burst 6 -j RETURN
$IPTABLES -A SYN_FLOOD -j DROP

$IPTABLES -A INPUT -s 0.0.0.0/7 -j DROP
$IPTABLES -A INPUT -s 2.0.0.0/8 -j DROP
$IPTABLES -A INPUT -s 5.0.0.0/8 -j DROP
$IPTABLES -A INPUT -s 7.0.0.0/8 -j DROP
$IPTABLES -A INPUT -s 10.0.0.0/8 -j DROP
$IPTABLES -A INPUT -s 23.0.0.0/8 -j DROP
$IPTABLES -A INPUT -s 27.0.0.0/8 -j DROP
$IPTABLES -A INPUT -s 31.0.0.0/8 -j DROP
$IPTABLES -A INPUT -s 36.0.0.0/7 -j DROP
$IPTABLES -A INPUT -s 39.0.0.0/8 -j DROP
$IPTABLES -A INPUT -s 42.0.0.0/8 -j DROP
$IPTABLES -A INPUT -s 49.0.0.0/8 -j DROP
$IPTABLES -A INPUT -s 50.0.0.0/8 -j DROP
$IPTABLES -A INPUT -s 77.0.0.0/8 -j DROP
$IPTABLES -A INPUT -s 78.0.0.0/7 -j DROP
$IPTABLES -A INPUT -s 92.0.0.0/6 -j DROP
$IPTABLES -A INPUT -s 96.0.0.0/4 -j DROP
$IPTABLES -A INPUT -s 112.0.0.0/5 -j DROP
$IPTABLES -A INPUT -s 120.0.0.0/8 -j DROP
$IPTABLES -A INPUT -s 169.254.0.0/16 -j DROP
$IPTABLES -A INPUT -s 172.16.0.0/12 -j DROP
$IPTABLES -A INPUT -s 173.0.0.0/8 -j DROP
$IPTABLES -A INPUT -s 174.0.0.0/7 -j DROP
$IPTABLES -A INPUT -s 176.0.0.0/5 -j DROP
$IPTABLES -A INPUT -s 184.0.0.0/6 -j DROP
$IPTABLES -A INPUT -s 192.0.2.0/24 -j DROP
$IPTABLES -A INPUT -s 197.0.0.0/8 -j DROP
$IPTABLES -A INPUT -s 198.18.0.0/15 -j DROP
$IPTABLES -A INPUT -s 223.0.0.0/8 -j DROP
$IPTABLES -A INPUT -s 224.0.0.0/3 -j DROP

$IPTABLES -A OUTPUT -m state --state NEW -p udp --dport 53 -j ACCEPT
$IPTABLES -A OUTPUT -m state --state NEW -p tcp --dport 53 -j ACCEPT

$IPTABLES -A OUTPUT -m state --state NEW -p tcp --dport 80 -j ACCEPT

$IPTABLES -A OUTPUT -m state --state NEW -p tcp --dport 443 -j ACCEPT

$IPTABLES -A OUTPUT -m state --state NEW -p tcp --dport 587 -j ACCEPT

$IPTABLES -A OUTPUT -m state --state NEW -p tcp --dport 995 -j ACCEPT

$IPTABLES -A OUTPUT -m state --state NEW -p tcp --dport 22 -j ACCEPT

$IPTABLES -A OUTPUT -m state --state NEW -p tcp --dport 21 -j ACCEPT

$IPTABLES -A OUTPUT -m state --state NEW -p udp --sport 67:68 --dport 67:68 -j ACCEPT

$IPTABLES -A OUTPUT -m state --state NEW -p udp --dport 1194 -j ACCEPT

$IPTABLES -A INPUT -m state --state NEW -p udp --dport 53 -j ACCEPT
$IPTABLES -A INPUT -m state --state NEW -p tcp --dport 53 -j ACCEPT

$IPTABLES -A INPUT -m state --state NEW -p tcp --dport 80 -j ACCEPT

$IPTABLES -A INPUT -m state --state NEW -p tcp --dport 443 -j ACCEPT

$IPTABLES -A INPUT -m state --state NEW -p tcp --dport 110 -j ACCEPT

$IPTABLES -A INPUT -m state --state NEW -p tcp --dport 143 -j ACCEPT

$IPTABLES -A INPUT -m state --state NEW -p tcp --dport 995 -j ACCEPT

$IPTABLES -A INPUT -m state --state NEW -p tcp --dport 25 -j ACCEPT

$IPTABLES -A INPUT -m state --state NEW -p tcp --dport 22 -j ACCEPT

$IPTABLES -A INPUT -m state --state NEW -p tcp --dport 21 -j ACCEPT

$IPTABLES -A INPUT -j REJECTLOG
$IPTABLES -A OUTPUT -j REJECTLOG
$IPTABLES -A FORWARD -j REJECTLOG

sudo ip6tables -A INPUT -p tcp --dport ssh -s HOST_IPV6_IP -j ACCEPT
sudo ip6tables -A INPUT -p tcp --dport 80 -j ACCEPT
sudo ip6tables -A INPUT -p tcp --dport 21 -j ACCEPT
sudo ip6tables -A INPUT -p tcp --dport 25 -j ACCEPT

sudo ip6tables -L -n --line-numbers

sudo ip6tables -D INPUT -p tcp --dport 21 -j ACCEPT

exit 0
