#!/bin/sh

#######################			USER identifiant				##################################################
#		user wordpress	:
#					 id : user1 	; 	password : password
#					 id : user2 	;	password : password
#		user telegraf	:
#					 id : root 		;	password : password
#		user grafana	:
#					 id : admin 	;	password : admin
#		user phpmyadmin	:
#					 id : root 		;	password : password

######################## 			delete and start minikube 	##################################################

minikube delete
minikube start --vm-driver=docker

######################## 			for vm 						##################################################

CLUSTER_IP="$(kubectl get node -o=custom-columns='DATA:status.addresses[0].address' | sed -n 2p)"
sed -i 's/192.168.49.2/'$CLUSTER_IP'/g' srcs/metallb/metallb_conf.yaml
sed -i 's/192.168.49.2/'$CLUSTER_IP'/g' srcs/ftps/setup_ftps.sh
sed -i 's/192.168.49.2/'$CLUSTER_IP'/g' srcs/nginx/nginx.conf
sed -i 's/192.168.49.2/'$CLUSTER_IP'/g' srcs/mysql/wordpress.sql
sed -i 's/192.168.49.2/'$CLUSTER_IP'/g' srcs/telegraf/telegraf.conf

######################## 			stuff metallb				##################################################

kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/metallb.yaml
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
kubectl apply -f srcs/metallb/metallb_conf.yaml



######################## 			build image 				##################################################

eval $(minikube docker-env) 		#point the docker client to the machine's docker daemon
docker build --no-cache  -t my_nginx srcs/nginx/
docker build --no-cache  -t my_mysql srcs/mysql/
docker build --no-cache  -t my_php_my_admin srcs/php_my_admin/
docker build --no-cache  -t my_wordpress srcs/wordpress/
docker build --no-cache  -t my_influxdb srcs/influxdb/
docker build --no-cache  -t my_telegraf srcs/telegraf/
docker build --no-cache  -t my_grafana srcs/grafana/
docker build --no-cache  -t my_ftps srcs/ftps/
eval $(minikube docker-env -u) 		#point the docker client to the machine's docker daemon	

#######################				deployment 					##################################################

kubectl apply -f srcs/nginx/deployment_nginx.yaml
kubectl apply -f srcs/mysql/deployment_mysql.yaml
kubectl apply -f srcs/php_my_admin/deployment_php.yaml
kubectl apply -f srcs/wordpress/deployment_wordpress.yaml
kubectl apply -f srcs/influxdb/deployment_influxdb.yaml
kubectl apply -f srcs/telegraf/deployment_telegraf.yaml 
kubectl apply -f srcs/grafana/deployment_grafana.yaml
kubectl apply -f srcs/ftps/deployment_ftps.yaml

minikube dashboard
echo -ne 	"\n\n\033[1;36m
███████╗████████╗     ███████╗███████╗██████╗ ██╗   ██╗██╗ ██████╗███████╗███████╗
██╔════╝╚══██╔══╝     ██╔════╝██╔════╝██╔══██╗██║   ██║██║██╔════╝██╔════╝██╔════╝
█████╗     ██║        ███████╗█████╗  ██████╔╝██║   ██║██║██║     █████╗  ███████╗
██╔══╝     ██║        ╚════██║██╔══╝  ██╔══██╗╚██╗ ██╔╝██║██║     ██╔══╝  ╚════██║
██║        ██║███████╗███████║███████╗██║  ██║ ╚████╔╝ ██║╚██████╗███████╗███████║
╚═╝        ╚═╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚═╝ ╚═════╝╚══════╝╚══════╝
e)
                                                                                  \n\n"