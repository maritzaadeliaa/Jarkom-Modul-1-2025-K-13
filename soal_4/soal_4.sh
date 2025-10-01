apt update && apt install  iptables -y

iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s10.70.0.0/16

cat /etc/resolv.conf

Echo nameserver [IP] > /etc/resolv.conf
