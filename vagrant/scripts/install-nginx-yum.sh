#!/usr/bin/env bash

echo "Running NGINX install ..."

if type nginx &> /dev/null ; then
  echo "NGINX already installed... exiting"
  exit 0
fi

rpm -Uvh http://nginx.org/packages/mainline/centos/7/x86_64/RPMS/nginx-1.11.3-1.el7.ngx.x86_64.rpm

cat >/etc/nginx/conf.d/easy-lotto.conf <<EOL

upstream app {
    server unix:/var/run/shared/easy-lotto.sock fail_timeout=0;
}

server {
    listen 8080;
    server_name localhost;

    root /webapp/public;

    try_files \$uri/index.html \$uri @app;

    location @app {
        proxy_pass http://app;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header Host \$http_host;
        proxy_redirect off;
    }

    error_page 500 502 503 504 /500.html;
    client_max_body_size 4G;
    keepalive_timeout 10;
}
EOL

rm /etc/nginx/conf.d/default.conf

systemctl stop nginx
systemctl start nginx
systemctl enable nginx
