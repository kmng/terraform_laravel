#!/bin/bash
# Installing CodeDeploy agent considering EC2 have full access to S3
sudo su
yum -y update
yum install -y aws-cli
yum install -y ruby git
cd /home/ec2-user
aws s3 cp s3://aws-codedeploy-us-west-2/latest/install . --region us-west-2
chmod +x ./install
sed -i "s/sleep(.*)/sleep(10)/" install
./install auto
# Installing PHP and required extensions
amazon-linux-extras install -y php7.2
yum install -y  php-mbstring php-pdo php-soap php-xml php-mysqlnd php-gd php-json
# Insalling Web Server
yum install -y httpd
systemctl start httpd
systemctl enable httpd
# Installing Composer
sudo curl -sS https://getcomposer.org/installer | sudo php
sudo mv composer.phar /usr/local/bin/composer
sudo ln -s /usr/local/bin/composer /usr/bin/composer
export COMPOSER_HOME="$HOME/.config/composer"
# Assigning Permissions to Folder
usermod -a -G apache ec2-user
chown -R ec2-user:apache /var/www
chmod 2775 /var/www
find /var/www -type d -exec chmod 2775 {} \;
find /var/www -type f -exec chmod 0664 {} \;
# Creating phpinfo file for test purpose
echo "<?php phpinfo(); ?>" > /var/www/html/phpinfo.php
sudo su
cd /var/www/html/
git clone https://github.com/kmng/Laravel57Source.git
cd /var/www/html/Laravel57Source
cp /var/www/html/Laravel57Source/.env.example /var/www/html/Laravel57Source/.env 
sed -i 's/DB_HOST=127.0.0.1/DB_HOST=${db_host}/g' /var/www/html/Laravel57Source/.env 
sed -i 's/DB_DATABASE=homestead/DB_DATABASE=${db_database}/g' /var/www/html/Laravel57Source/.env 
sed -i 's/DB_USERNAME=homestead/DB_USERNAME=${db_username}/g' /var/www/html/Laravel57Source/.env 
sed -i 's/DB_PASSWORD=secret/DB_PASSWORD=${db_password}/g' /var/www/html/Laravel57Source/.env 
composer install --no-plugins
sudo chgrp -R apache /var/www/html/Laravel57Source/storage /var/www/html/Laravel57Source/bootstrap/cache
sudo chmod -R ug+rwx /var/www/html/Laravel57Source/storage /var/www/html/Laravel57Source/bootstrap/cache
# Changing Document Root
sed -i 's/DocumentRoot "\/var\/www\/html"/DocumentRoot "\/var\/www\/html\/Laravel57Source\/public"/g' /etc/httpd/conf/httpd.conf
sed -i 's/<Directory "\/var\/www">/<Directory "\/var\/www\/html\/Laravel57Source">/g' /etc/httpd/conf/httpd.conf
sed -i '0,/AllowOverride None/s//AllowOverride All/' /etc/httpd/conf/httpd.conf
php artisan key:generate
php artisan config:cache
php artisan make:auth
php artisan migrate
systemctl restart httpd