#!/bin/sh

currentPath=$(pwd)
tailPath="${currentPath#/*/*/*/}"
headPath="${currentPath%/$tailPath}"
headPathEscaped=$headPath.gsub("/", "\\/")

echo $currentPath;
echo $tailPath;
echo $headPath;
echo $headPathEscaped;

# Custom NGINX rewrites file
if [[ -z $(grep "include $headPath/current/artifakt/nginx_rewrites.conf" "/etc/nginx/sites-available/magento") ]]; then
    if [[ -f "$currentPath/artifakt/nginx_rewrites.conf" ]]; then
        sed -i "/server {/ i\ include $headPathEscaped\/current\/artifakt\/nginx_rewrites.conf;" /etc/nginx/sites-available/magento;
        echo "Custom rewrites file has been included into NGINX configuration"
    else
        echo "Custom rewrites file has not been included into NGINX configuration as it does not exist"
    fi
else
    if [[ ! -f "$currentPath/artifakt/nginx_rewrites.conf" ]]; then
        sed -i "/include $headPathEscaped\/current\/artifakt\/nginx_rewrites.conf;/d" /etc/nginx/sites-available/magento
        echo "Custom rewrites file has been removed from NGINX configuration as the file does not exist anymore"
    else
        echo "Custom rewrites file has already been included into NGINX configuration";
    fi
fi
