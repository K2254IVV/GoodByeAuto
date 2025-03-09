sudo su
cd /opt
git clone https://github.com/bol-van/zapret
sudo apt install iptables
cd zapret
./install_bin.sh
./install_prereq.sh
sudo add-apt-repository ppa:shevchuk/dnscrypt-proxy
sudo apt update
sudo apt install dnscrypt-proxy
sudo nano /etc/dnscrypt-proxy/dnscrypt-proxy.toml
sudo sed -i 's/127.0.2.1/127.0.0.1/g' /lib/systemd/system/dnscrypt-proxy.socket
sudo systemctl daemon-reload
sudo systemctl stop dnscrypt-proxy.socket
sudo systemctl enable dnscrypt-proxy
sudo systemctl start dnscrypt-proxy
sudo sed -i 's/127.0.2.1/127.0.0.1/g' /lib/systemd/system/dnscrypt-proxy.socket
sudo systemctl daemon-reload
sudo systemctl stop dnscrypt-proxy.socket
sudo systemctl enable dnscrypt-proxy
sudo systemctl start dnscrypt-proxy
reboot
