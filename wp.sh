#!/bin/bash

# Update the package manager and install required packages
apt update -y
apt install -y apache2 php libapache2-mod-php
apt-get update
apt-get install php-mysqli

# Download and install WordPress
cd /var/www/html
rm index.html
touch healthy.html
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
rm latest.tar.gz
mv wordpress/* .
rmdir wordpress

# Set proper ownership and permissions
chown -R www-data:www-data /var/www/html
find /var/www/html -type d -exec chmod 755 {} \;
find /var/www/html -type f -exec chmod 644 {} \;

# Restart Apache to apply changes
systemctl restart apache2

apt-get install -y mysql-client

