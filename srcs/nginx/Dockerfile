FROM alpine:latest

RUN apk update && apk add nginx \
&& apk add --upgrade bash \
&& apk add openssl && mkdir -p var/run/nginx \
&& apk add openssl openssh \
&& rm -rf /var/cache/apk/*

#####file RUN NGINX#####
RUN mkdir -p /www
COPY ./index.html /www

#####Create the file with the ssl key inside#####
RUN mkdir -p /etc/nginx/ssl && openssl req -newkey rsa:2048 -x509 -days 365 -nodes -keyout /etc/nginx/ssl/services.key -out /etc/nginx/ssl/services.pem -subj "/C=FR/ST=Paris/L=Paris/O=42, Inc./OU=IT/CN=ft_services"

#####Nginnx config#####
COPY ./nginx.conf /etc/nginx/nginx.conf

EXPOSE 80 443

#### desactive mode daemon #####
CMD ["nginx","-g","daemon off;"]