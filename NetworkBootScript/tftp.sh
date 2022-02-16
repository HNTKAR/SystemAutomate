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

cat << EOF > my-snappy-by-tftp.te
module my-snappy-by-tftp 1.0;

require {
        type snappy_t;
        type type public_content_rw_t;
        class dir { getattr open read };
}

allow snappy_t public_content_rw_t:dir { getattr open read };
EOF

make -f /usr/share/selinux/devel/Makefile
semodule -X 300 -i my-snappy-by-tftp.pp
rm my-snappy-by-tftp.*