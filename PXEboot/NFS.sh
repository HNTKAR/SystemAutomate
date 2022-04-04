#!/bin/bash

if [[ $(whoami) != "root" ]]; then
    echo "Do not run as non-root !!"
    exit 1
fi

help_func(){
cat << EOF
NFS SERVER SETUP PROGRAM

	-C <client address> , --client=<client address>

	-H , --help		Show Help  (This Page)

EOF
}

client=""

while [[ $# -gt 0  ]]
do
	case $1 in
		-[Cc]|-[Cc]=*|--client|--client=*)
			if [[ $1 =~ .+= ]]; then
				echo \$1=$1
				client=$(echo $1 | sed s/.*=//g)
			elif [[ -z $2 ]] || [[ $2 =~ ^- ]]; then
	        	echo "Error!!: One or more argument of $1 are missing ."
				exit 1
			else
				client=$2
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
if [[ -z $client ]];then 
	echo "Argument -C is not specified ."
	exit 1;
fi
dnf -y install nfs-utils

cat <<-EOF >/etc/exports
/home/data/nfs/ubuntu $client(sync,wdelay,hide,no_subtree_check,sec=sys,rw,secure,root_squash,all_squash)
/home/data/nfs/centos $client(sync,wdelay,hide,no_subtree_check,sec=sys,rw,secure,root_squash,all_squash)
EOF

# SELinux setting
mkdir -p /home/data/nfs
mkdir -p /home/data/nfs/ubuntu
mkdir -p /home/data/nfs/centos
chmod 777 -R /home/data/nfs

semanage fcontext --add --type public_content_rw_t "/home/data(/.*)?"
restorecon -R /home/data

firewall-cmd --permanent --delete-service=nfs-ipxe
firewall-cmd --permanent --new-service=nfs-ipxe
firewall-cmd --permanent --service=nfs-ipxe --add-port={111,2049,20048}/tcp
firewall-cmd --permanent --add-service=nfs-ipxe
firewall-cmd --reload

systemctl enable --now {nfs-server,rpcbind}
systemctl restart {nfs-server,rpcbind}
# rpcdebug -m nfsd all
