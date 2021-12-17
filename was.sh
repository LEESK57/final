#!/bin/bash
sudo -i
amazon-linux-extras install java-openjdk11 -y
useradd -r -m -U -d /opt/tomcat -s /bin/false tomcat
wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.56/bin/apache-tomcat-9.0.56.tar.gz -P /tmp
tar xf /tmp/apache-tomcat-9*.tar.gz -C /opt/tomcat
ln -s /opt/tomcat/apache-tomcat-9.0.56 /opt/tomcat/latest
chown -RH tomcat: /opt/tomcat/latest
sh -c 'chmod +x /opt/tomcat/latest/bin/*.sh'
cat >> /etc/systemd/system/tomcat.service << EOF
[Unit]
Description=tomcat9.0.56
After=network.target syslog.target

[Service]
Type=forking

Environment=CATALINA_HOME=/opt/tomcat/latest
User=root
Group=root

ExecStart=/opt/tomcat/latest/bin/startup.sh
ExecStop=/opt/tomcat/latest/bin/shutdown.sh

UMask=0007
RestartSec=10
Restart=always

SuccessExitStatus=143

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl start tomcat
systemctl enable tomcat