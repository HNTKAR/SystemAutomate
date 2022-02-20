#!/bin/bash

if [[ $(whoami) != "root" ]]; then
    echo "Do not run as non-root !!"
    exit 1
fi

help_func(){
cat << EOF
DHCP and TFTP SERVER SETUP PROGRAM

	-B <broadcast address> , --broad=<broadcast address>
	-D <DNS address> , --dns=<DNS address>
	-G <gateway address> , --gateway=<gateway address>
	-l <lease time> , --lease=<lease time>
	-N <net mask> , --net=<net mask>
	-S <subnet mask> , --subnet=<subnet mask>

	-H , --help		Show Help  (This Page)

EOF
	# -T , --tftp		enable TFTP server
}

shift_Flag=0
broad=""
dns=""
gw=""
lease=""
net=""
subnet=""



while [[ $# -gt 0  ]]
do
	case $1 in
		-[Bb]|-[Bb]=*|--broad|--broad=*)
			if [[ $1 =~ .+= ]]; then
				echo \$1=$1
				broad=$(echo $1 | sed s/.*=//g)
			elif [[ -z $2 ]] || [[ $2 =~ ^- ]]; then
	        	echo "Error!!: One or more argument of $1 are missing ."
				exit 1
			else
				broad=$2
				shift_Flag=1
			fi;;
		-[Dd]|-[Dd]=*|--dns|--dns=*)
			if [[ $1 =~ .+= ]]; then
				echo \$1=$1
				dns=$(echo $1 | sed s/.*=//g)
			elif [[ -z $2 ]] || [[ $2 =~ ^- ]]; then
	        	echo "Error!!: One or more argument of $1 are missing ."
				exit 1
			else
				dns=$2
				shift_Flag=1
			fi;;
		-[Gg]|-[Gg]=*|--gateway|--gateway=*)
			if [[ $1 =~ .+= ]]; then
				echo \$1=$1
				gw=$(echo $1 | sed s/.*=//g)
			elif [[ -z $2 ]] || [[ $2 =~ ^- ]]; then
	        	echo "Error!!: One or more argument of $1 are missing ."
				exit 1
			else
				gw=$2
				shift_Flag=1
			fi;;
		-[Ll]|-[Ll]=*|--lease|--lease=*)
			if [[ $1 =~ .+= ]]; then
				echo \$1=$1
				lease=$(echo $1 | sed s/.*=//g)
			elif [[ -z $2 ]] || [[ $2 =~ ^- ]]; then
	        	echo "Error!!: One or more argument of $1 are missing ."
				exit 1
			else
				lease=$2
				shift_Flag=1
			fi;;
		-[Nn]|-[Nn]=*|--net|--net=*)
			if [[ $1 =~ .+= ]]; then
				echo \$1=$1
				net=$(echo $1 | sed s/.*=//g)
			elif [[ -z $2 ]] || [[ $2 =~ ^- ]]; then
	        	echo "Error!!: One or more argument of $1 are missing ."
				exit 1
			else
				net=$2
				shift_Flag=1
			fi;;
		-[Ss]|-[Ss]=*|--subnet|--subnet=*)
			if [[ $1 =~ .+= ]]; then
				echo \$1=$1
				subnet=$(echo $1 | sed s/.*=//g)
			elif [[ -z $2 ]] || [[ $2 =~ ^- ]]; then
	        	echo "Error!!: One or more argument of $1 are missing ."
				exit 1
			else
				subnet=$2
				shift_Flag=1
			fi;;
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

if [[ -z $subnet || -z $net ]];then 
	echo "Argument -N or -S is not specified .";
	exit 1;
fi

dnf -y install dhcp-server

cat <<-EOF >/etc/dhcp/dhcpd.conf
#
# DHCP Server Configuration file.
#   see /usr/share/doc/dhcp-server/dhcpd.conf.example
#   see dhcpd.conf(5) man page
#
authoritative;
include "/etc/dhcp/dhcp-user.cfg";
log-facility local1;
EOF

sed -ie "/dhcpd/d" /etc/rsyslog.conf
echo "local1.debug /var/log/dhcpd.log" >>/etc/rsyslog.conf

cat <<-EOF >/etc/dhcp/dhcp-user.cfg
	subnet $subnet netmask $net {
	}
EOF

if [[ -n $broad ]];then
    cat <<-EOF >> /etc/dhcp/dhcpd.conf
	option broadcast-address $broad;
	EOF
fi

if [[ -n $dns ]];then
    cat <<-EOF >> /etc/dhcp/dhcpd.conf
	option domain-name-servers $dns;
	EOF
fi

if [[ -n $gw ]];then
    cat <<-EOF >> /etc/dhcp/dhcpd.conf
	option routers $gw;
	EOF
fi

if [[ -n $lease ]];then
    cat <<-EOF >> /etc/dhcp/dhcpd.conf
	default-lease-time $lease;
	EOF
fi

touch /var/lib/dhcpd/dhcpd.leases
firewall-cmd  --permanent --add-service=dhcp
firewall-cmd  --reload
systemctl enable --now dhcpd
systemctl restart rsyslog
systemctl restart dhcpd
