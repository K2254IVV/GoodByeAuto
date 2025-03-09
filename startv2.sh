#!/bin/bash

# Убедитесь, что скрипт выполняется с правами суперпользователя
if [ "$EUID" -ne 0 ]; then
    echo "Пожалуйста, запустите скрипт с правами суперпользователя."
    exit
fi

# Обновление системы
apt update
apt upgrade -y

# Установка необходимых пакетов
apt install -y build-essential git

# Установка и настройка zapret
git clone https://github.com/bol-van/zapret.git
cd zapret
./install.sh

# Включите zapret
systemctl enable zapret
systemctl start zapret

# Выход из директории zapret
cd ..

# Установка DNSCrypt-Proxy
apt install -y dnscrypt-proxy

# Конфигурация DNSCrypt-Proxy
DNSCRYPT_CONFIG="/etc/dnscrypt-proxy/dnscrypt-proxy.toml"

# Резервное копирование исходного файла конфигурации
cp $DNSCRYPT_CONFIG "${DNSCRYPT_CONFIG}.bak"

# создание конфигурации
cat <<EOT > $DNSCRYPT_CONFIG
server_names = ['cloudflare']
listen_addresses = ['127.0.0.1:53', '[::1]:53']
max_clients = 250

ipv6_servers = true

block_ipv6 = false

cache = true
cache_size = 512

fallback_resolver = '1.1.1.1:53'

EOT

# Включение и запуск DNSCrypt-Proxy
systemctl enable dnscrypt-proxy
systemctl start dnscrypt-proxy

# Настройка системного DNS на использование DNSCrypt
echo "nameserver 127.0.0.1" > /etc/resolv.conf

echo "Установка и настройка завершены!"

