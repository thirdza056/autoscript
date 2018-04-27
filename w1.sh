sudo apt-get update
#apt-get install ca-certificates
apt-get install zip
apt-get -y install openvpn

# Change to Time GMT+8
ln -fs /usr/share/zoneinfo/Asia/Bangkok /etc/localtime

# install openvpn
wget -O /etc/openvpn/openvpn.tar "https://scripkguza.000webhostapp.com/KGUZA-ALL-SCRIP/openvpn-debian.tar"
cd /etc/openvpn/
tar xf openvpn.tar
# Download 1194-2.conf in Google to Save 1194.conf
wget -O /etc/openvpn/1194.conf "https://raw.githubusercontent.com/gmchoke/GMCHOKE1/master/1194-2.conf"
service openvpn restart
sysctl -w net.ipv4.ip_forward=1
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
iptables -t nat -I POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE
iptables-save > /etc/iptables_yg_baru_dibikin.conf
wget -O /etc/network/if-up.d/iptables "https://raw.githubusercontent.com/gmchoke/GMCHOKE1/master/iptables"
chmod +x /etc/network/if-up.d/iptables
cp /usr/lib/openvpn/openvpn-plugin-auth-pam.so /etc/openvpn/
mkdir /etc/openvpn/tmp
chmod 777 /etc/openvpn/tmp
/etc/init.d/openvpn restart
#service openvpn status

# download script
cd /usr/bin
wget -O usernew "https://raw.githubusercontent.com/gmchoke/A/master/usernew.sh"
chmod +x usernew
# Add User OpenVPN key: usernew

# Install Squid
apt-get -y install squid3
cp /etc/squid3/squid.conf /etc/squid3/squid.conf.orig
wget -O /etc/squid3/squid.conf "https://raw.githubusercontent.com/gmchoke/A/master/squid.conf"
MYIP=$(wget -qO- ipv4.icanhazip.com);
sed -i s/xxxxxxxxx/$MYIP/g /etc/squid3/squid.conf;
service squid3 restart

# install webmin
cd
#wget -O webmin-current.deb "https://scripkguza.000webhostapp.com/KGUZA-ALL-SCRIP/webmin-current.deb"
#dpkg -i --force-all webmin-current.deb;
#apt-get -y -f install;
#rm /root/webmin-current.deb
			#sed -i s/port=10000/port=85/g /etc/webmin/miniserv.conf;
sudo tee -a /etc/apt/sources.list << EOF
deb http://download.webmin.com/download/repository sarge contrib
deb http://webmin.mirror.somersettechsolutions.co.uk/repository sarge contrib
EOF
cd /root
wget http://www.webmin.com/jcameron-key.asc
apt-key add jcameron-key.asc
apt-get update
apt-get install webmin
sed -i s/ssl=1/ssl=0/g /etc/webmin/miniserv.conf;
service webmin restart

# Web Based Interface for Monitoring Network apache2 php5 php5-gd
sudo apt-get install vnstat
sudo apt-get install apache2 php5 php5-gd
wget -O vnstat_php_frontend-1.5.1.tar.gz "http://www.sqweek.com/sqweek/files/vnstat_php_frontend-1.5.1.tar.gz"
#wget http://www.sqweek.com/sqweek/files/vnstat_php_frontend-1.5.1.tar.gz
tar xzf vnstat_php_frontend-1.5.1.tar.gz
mv vnstat_php_frontend-1.5.1 /var/www/html/vnstat
sed -i s/nl/th/g /var/www/html/vnstat/config.php;
#sed -i s/80/85/g /etc/apache2/ports.conf;
wget -O /var/www/html/vnstat/lang/th.php "https://raw.githubusercontent.com/gmchoke/A/master/th.php"
wget -O /var/www/html/vnstat/index.php "https://raw.githubusercontent.com/gmchoke/GMCHOKE1/master/index.php"
sed -i s/xxxxxxxxxx/http/g /var/www/html/vnstat/index.php;
wget -O /etc/apache2/sites-enabled/000-default.conf "https://raw.githubusercontent.com/gmchoke/A/master/000-default.conf"
sed -i s/85/80/g /etc/apache2/sites-enabled/000-default.conf;
sed -i s/85/10000/g /var/www/html/vnstat/index.php;
cd
wget -O client.ovpn "https://raw.githubusercontent.com/gmchoke/A/master/client.ovpn"
MYIP=$(wget -qO- ipv4.icanhazip.com);
sed -i s/xxxxxxxx/$MYIP/g client.ovpn;
mv client.ovpn /var/www/html/vnstat/
wget -O /var/www/html/vnstat/client.php "https://raw.githubusercontent.com/gmchoke/A/master/client.php"
sed -i s/client.zip/client.php/g /var/www/html/vnstat/index.php;

sudo service apache2 restart
#nano /var/www/html/vnstat/config.php

# About
cd
clear
echo "Script WebMin Auto Install"
echo -e "\033[01;34m-----------------------------\033[0m"
echo -e "\033[01;31mInstall on 'Ubuntu 14.04' Only \033[0m"
echo -e "\033[01;34m-----------------------------\033[0m"
echo "FaceBook Name : nipon kaewtes "
echo "FaceBook Url : nipon kaewtes "
echo "Email : niopn56@gmail.com"
echo "TimeZone :  Nakhonsawan "
echo "ดูกราฟฟิค :  http://$MYIP/"
echo "WebMin   :  http://$MYIP:10000/"
echo -e "\033[01;34m-----------------------------\033[0m"
echo "root you password login web edit..."
sudo passwd root

#ใส่รหัสใหม่เข้าไป 2 ครั้ง จะได้ชื่อผู้ใช้ root รหัสผ่าน ??? ที่กำหนดใหม่
#เข้าสู่หน้าจัดการ http://You-IP-server:10000/
#เข้าไปที่หัวข้อ Server >> SSH Server >> Authentication
#ที่หัวข้อ Allow authentication by password? เลือกเป็น Yes กด Save และ Apply Changes
#SSH Port 22,143  Proxy Port 8080,3128

sudo rm -rf *
