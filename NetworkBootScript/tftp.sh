dnf -y install tftp-server

cat <<EOF > /etc/systemd/system/tftp.service
[Unit]
Description=Tftp Server
Requires=tftp.socket
Documentation=man:in.tftpd

[Service]
ExecStart=/usr/sbin/in.tftpd -s /home/data/tftp
StandardInput=socket

[Install]
Also=tftp.socket
EOF

# SELinux setting
mkdir -p /home/data/tftp
chmod 777 -R /home/data/tftp

semanage fcontext --add --type public_content_rw_t "/home/data(/.*)?"
restorecon -R /home/data

firewall-cmd  --permanent --add-service=tftp
firewall-cmd  --reload
systemctl daemon-reload
systemctl enable --now tftp
systemctl restart tftp