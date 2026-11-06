FROM kalilinux/kali-rolling:latest

ENV container=docker

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    systemd systemd-sysv dbus \
    bind9 bind9-utils dnsutils python3-scapy tcpdump iproute2 \
    procps iputils-ping net-tools sudo nano vim-tiny less curl \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /var/cache/bind/lab \
    && chown -R bind:bind /var/cache/bind

COPY named.conf.options /etc/bind/named.conf.options
COPY named.conf.local /etc/bind/named.conf.local
COPY db.lab.test /var/cache/bind/lab/db.lab.test
COPY poison_dns.py /home/kali/poison_dns.py
COPY terminal.bashrc /opt/lab/terminal.bashrc

RUN chown bind:bind /var/cache/bind/lab/db.lab.test \
    && named-checkconf \
    && named-checkzone lab.test /var/cache/bind/lab/db.lab.test \
    && systemctl enable named.service \
    && systemctl set-default multi-user.target \
    && useradd --create-home --shell /bin/bash kali \
    && usermod --append --groups sudo kali \
    && chown -R kali:kali /home/kali \
    && echo 'kali:attacker' | chpasswd

STOPSIGNAL SIGRTMIN+3
CMD ["/sbin/init"]
