#!/bin/bash
# Only support Debian 10

if [ `whoami` != "root" ]; then
    echo "sudo or root is required!"
    exit 1
fi

if [ ! -f "/etc/debian_version" ]; then
    echo "Boss, do you want to try debian?"
    exit 1
fi
check_gitweb(){
  type gitweb > /dev/null 2>&1
  if [ $? -eq 0 ] ;then
    echo "gitweb软件已存在，请不要重复安装"
    exit 1
  else
    install_gitweb
  fi
}
install_gitweb(){
  apt update && apt install git gitweb nginx spawn-fcgi -y
  cat <<EOT > /etc/nginx/sites-available/gitweb
# /etc/nginx/sites-available/gitweb
server {
  listen 8011;
  listen [::]:8011;
  #replace "example.com" below with your domain (or subdomain)
  #server_name ;
  #ssl_certificate /etc/nginx/cert/xxx.crt;
  #ssl_certificate_key /etc/nginx/cert/xxx.key;

  location /index.cgi {
    root /usr/share/gitweb/;
    include fastcgi_params;
    gzip off;
    fastcgi_param SCRIPT_NAME $uri;
    fastcgi_param GITWEB_CONFIG /etc/gitweb.conf;
    fastcgi_pass  unix:/var/run/fcgiwrap.socket;
  }

  location / {
    root /usr/share/gitweb/;
    index index.cgi;
  }
  location ~ /clone(/.*) {
    client_max_body_size 0;
    include /etc/nginx/fastcgi_params;
    fastcgi_param SCRIPT_FILENAME /usr/lib/git-core/git-http-backend;
    fastcgi_param GIT_PROJECT_ROOT /mnt/sda1/gitweb;
    fastcgi_param PATH_INFO $1;
    fastcgi_pass unix:/var/run/fcgiwrap.socket;
    #fastcgi_param GIT_HTTP_EXPORT_ALL "";
  }
}

EOT

  ln -sf /etc/nginx/sites-{available,enabled}/gitweb
  systemctl restart nginx
  cp -a /usr/share/bak/gitweb/gitweb.cgi /usr/share/gitweb
  cp -a /usr/share/bak/gitweb/indextext.html /usr/share/gitweb
  cp -a /usr/share/bak/gitweb/gitweb.conf /etc
}
check_gitweb

