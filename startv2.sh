#!/bin/bash

# Убедитесь, что скрипт выполняется с правами суперпользователя
if [ "$EUID" -ne 0 ]; then
    echo "Пожалуйста, запустите скрипт с правами суперпользователя."
    exit
fi

# Обновление системы и установка необходимых пакетов
apt update
apt upgrade -y
apt install -y git iptables

# Переменная для установки zapret
ZAPRET_DIR="/opt/zapret"

# Установка zapret
cd /opt
git clone https://github.com/bol-van/zapret.git
cd zapret
./install_bin.sh
./install_prereq.sh

# Установка и настройка DNSCrypt-Proxy из PPA
add-apt-repository -y ppa:shevchuk/dnscrypt-proxy
apt update
apt install -y dnscrypt-proxy

# Обновление конфигурации DNSCrypt-Proxy
DNSCRYPT_SOCKET="/lib/systemd/system/dnscrypt-proxy.socket"
sed -i 's/127.0.2.1/127.0.0.1/g' $DNSCRYPT_SOCKET

systemctl daemon-reload
systemctl stop dnscrypt-proxy.socket
systemctl enable dnscrypt-proxy
systemctl start dnscrypt-proxy

# Перезагрузка системы, чтобы изменения вступили в силу
echo "Установка завершена. Перезагрузка системы..."
reboot

