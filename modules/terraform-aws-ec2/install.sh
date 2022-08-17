#!/bin/sh
      sudo apt-get update
      sudo apt install -y apache2
      sudo systemctl status apache2
      sudo systemctl start apache2
      sudo chown -R $USER:$USER /var/www/html
      sudo apt install -y php libapache2-mod-php
      sudo apt install -y mysql-server
      sudo apt install -y php-mysql
      sudo echo "<?php phpinfo();" > /var/www/html/index.php