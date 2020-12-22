#!/bin/sh

################ stuff metallb ################
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/metallb.yaml
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
kubectl apply -f src/metallb/metallb-conf.yaml

################ build image ####################
docker build -t my_nginx src/nginx/

################deployment nginx #############
kubectl apply -f src/nginx/nginx_deployment.yaml
# docker run -tid  -p 80:80 -p 443:443 --name test1 my_nginx
