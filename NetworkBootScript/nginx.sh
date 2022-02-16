#!/bin/bash

help_func(){
cat << EOF
DHCP and TFTP SERVER SETUP PROGRAM

	-P <port> , --port=<port>
		Set http port

	-H , --help		Show Help  (This Page)

EOF
}

shift_Flag=0
port="80"

while [[ $# -gt 0  ]]
do
	case $1 in
		-[Pp]|-[Pp]=*|--port|--port=*)
			if [[ $1 =~ .+= ]]; then
				echo \$1=$1
				port=$(echo $1 | sed s/.*=//g)
			elif [[ -z $2 ]] || [[ $2 =~ ^- ]]; then
	        	echo "Error!!: One or more argument of $1 are missing ."
				exit 1
			else
				port=$2
				shift_Flag=1
			fi;;
		# -[Rr]|-[Rr]=*|--router|--router=*)
		# 	if [[ $1 =~ .+= ]]; then
		# 		echo \$1=$1
		# 		router=$(echo $1 | sed s/.*=//g)
		# 	elif [[ -z $2 ]] || [[ $2 =~ ^- ]]; then
	    #     	echo "Error!!: One or more argument of $1 are missing ."
		# 		exit 1
		# 	else
		# 		router=$2
		# 		shift_Flag=1
		# 	fi;;
		-[hH]|--help)
			help_func
			exit 0;;
	    *) 
	        echo "Error!!: $1 is Invalid argument ."
			exit 1;;
	esac
	if [[ shift_Flag -eq 1 ]]; then 
		shift;
		shift_Flag=0;
	fi
shift
done
echo port=$port
if [[ -z $port ]];then 
	echo "Argument -P is not specified .";
	exit 1;
fi

dnf -y install nginx

mkdir -p /home/data/http
chmod 777 -R /home/data/http
cp -frL /usr/share/nginx/html/* /home/data/http

semanage port --modify --type http_port_t --proto tcp $port
firewall-cmd --permanent --delete-service=http-ipxe
firewall-cmd --permanent --new-service=http-ipxe
firewall-cmd --permanent --service=http-ipxe --add-port=$port/tcp
firewall-cmd --permanent --add-service=http-ipxe
firewall-cmd --reload

systemctl enable --now nginx

cat << EOF > my-snappy-by-nginx.te
module my-snappy-by-nginx 1.0;

require {
        type snappy_t;
        type type public_content_rw_t;
        class dir { getattr open read };
}

allow snappy_t public_content_rw_t:dir { getattr open read };
EOF

make -f /usr/share/selinux/devel/Makefile
semodule -X 300 -i my-snappy-by-nginx.pp
rm my-snappy-by-nginx.*