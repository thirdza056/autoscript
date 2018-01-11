#!/bin/bash

service dropbear restart
service webmin restart
service squid3 restart
service openvpn restart
service ssh restart
/etc/init.d/stunnel4 restart
