#!/bin/sh

########### delete image#############
docker image rm -f alpine
docker image rm -f my_nginx
docker image rm -f my_mysql
docker image rm -f my_php_my_admin
docker image prune
minikube delete
minikube start --vm-driver=docker

### image visible in the cluster###

################ stuff metallb ################
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/metallb.yaml
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
kubectl apply -f src/metallb/metallb_conf.yaml #configuration metallb

################ build image ####################
eval $(minikube docker-env) #point the docker client to the machine's docker daemon
docker build --no-cache  -t my_nginx src/nginx/
docker build --no-cache  -t my_mysql src/mysql/
docker build --no-cache  -t my_php_my_admin src/php_my_admin/
eval $(minikube docker-env -u) #point the docker client to the machine's docker daemon

################ deployment nginx #############

kubectl apply -f src/nginx/deployment_nginx.yaml
kubectl apply -f src/mysql/deployement_mysql.yaml
kubectl apply -f src/php_my_admin/deployement_php.yaml

# docker run -tid  -p 80:80 -p 443:443 --name test1 my_nginx
#  kubectl get all --watch

########### mysql ####################

minikube dashboard
