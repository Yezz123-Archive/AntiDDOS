![img02](https://user-images.githubusercontent.com/52716203/109807605-69c43580-7c26-11eb-8431-8e80b0758eca.gif)

<p>The Anti-DDoS uses behavioural analysis, traffic signatures, rate limiting, and other such techniques to identify malicious traffic per source-address.</p>

```sh
# For debugging use iptables -v.
IPTABLES="/sbin/iptables"
IP6TABLES="/sbin/ip6tables"
MODPROBE="/sbin/modprobe"
RMMOD="/sbin/rmmod"
ARP="/usr/sbin/arp"
```
```sh
LOG="LOG --log-level debug --log-tcp-sequence --log-tcp-options"
LOG="$LOG --log-ip-options"
RLIMIT="-m limit --limit 3/s --limit-burst 8"
```
```sh
PHIGH="1024:65535"
PSSH="1000:1023"
```

<p align="center">
    <a href="https://yassertahiri.medium.com/">
    <img alt="Medium" src="https://img.shields.io/badge/Medium%20-%23000000.svg?&style=for-the-badge&logo=Medium&logoColor=white"/></a>
    <a href="https://discord.gg/crNvkTYPYG">
    <img alt="Discord" src="https://img.shields.io/badge/Discord%20-%237289DA.svg?&style=for-the-badge&logo=discord&logoColor=white"/></a>
</p>
