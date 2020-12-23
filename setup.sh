#!/bin/sh

docker image rm -f my_nginx
minikube delete
minikube start --vm-driver=docker

### image visible in the cluster###
eval $(minikube docker-env) #point the docker client to the machine's docker daemon

################ stuff metallb ################
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/metallb.yaml
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
kubectl apply -f src/metallb/metallb_conf.yaml #configuration metallb

################ build image ####################
docker build --no-cache  -t my_nginx src/nginx/

################ deployment nginx #############
kubectl apply -f src/nginx/nginx_deployment.yaml
# docker run -tid  -p 80:80 -p 443:443 --name test1 my_nginx
kubectl get service nginx-service --watch