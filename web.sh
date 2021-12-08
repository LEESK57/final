#!/bin/bash
sudo su -
yum install -y httpd
systemctl enable httpd
systemctl start httpd
cat >> /var/www/html/index.html << EOF
<html><body><h1>Hello WEB SERVER  </h1></body></html>
EOF