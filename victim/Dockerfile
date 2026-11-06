FROM ubuntu:24.04

ENV container=docker

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    systemd systemd-sysv dbus \
    bind9 bind9-utils dnsutils \
    procps iputils-ping net-tools sudo nano vim-tiny less curl \
    && rm -rf /var/lib/apt/lists/*

COPY named.conf.options /etc/bind/named.conf.options
COPY named.conf.local /etc/bind/named.conf.local
COPY terminal.bashrc /opt/lab/terminal.bashrc

RUN named-checkconf \
    && systemctl enable named.service \
    && systemctl set-default multi-user.target \
    && (id -u ubuntu >/dev/null 2>&1 || useradd --create-home --shell /bin/bash ubuntu) \
    && usermod --append --groups sudo ubuntu \
    && echo 'ubuntu:victim' | chpasswd

STOPSIGNAL SIGRTMIN+3
CMD ["/sbin/init"]
