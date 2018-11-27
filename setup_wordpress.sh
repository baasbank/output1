#!/usr/bin/env bash
# Script to install Apache, MySQL, PHP, and deploy Wordpress

export DEBIAN_FRONTEND="noninteractive"

USER=$(whoami)
MYSQL_ROOT_PASSWORD=$(curl http://metadata.google.internal/computeMetadata/v1/project/attributes/mysql_root_password -H "Metadata-Flavor: Google")
DATABASE_NAME=$(curl http://metadata.google.internal/computeMetadata/v1/project/attributes/database_name -H "Metadata-Flavor: Google")
DATABASE_PASSWORD=$(curl http://metadata.google.internal/computeMetadata/v1/project/attributes/database_password -H "Metadata-Flavor: Google")


apt-update() {
  echo 'UPDATING PACKAGES'
  sudo apt update -y
  sudo apt-get upgrade -y
}


install_apache() {
  echo 'INSTALLING APACHE'
  sudo apt-get install apache2 -y
  sudo systemctl start apache2.service
}


install_mysql() {
  echo 'INSTALLING MYSQL SERVER'
  sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password ${MYSQL_ROOT_PASSWORD}"
  sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password ${MYSQL_ROOT_PASSWORD}"
  sudo apt-get install mysql-server -y
}


install_php() {
  echo 'INSTALLING PHP AND PHP DEPENDENCIES'
  sudo apt-get install php -y
  sudo apt-get install -y php-{bcmath,bz2,intl,gd,mbstring,mcrypt,mysql,zip}
  sudo apt-get install libapache2-mod-php -y
}


start_apache_and_mysql_on_boot() {
  sudo systemctl enable apache2.service
  sudo /lib/systemd/systemd-sysv-install enable mysql
}


restart_apache() {
  echo 'RESTARTING APACHE'
  sudo systemctl restart apache2.service
}


download_wordpress() {
  echo 'DOWNLOADING WORDPRESS'
  wget -c http://wordpress.org/latest.tar.gz
  tar -xzvf latest.tar.gz
  sudo apt-get install rsync -y
  sudo rsync -av wordpress/* /var/www/html/
  sudo rm /var/www/html/index.html
  sudo chown -R www-data:www-data /var/www/html/
  sudo chmod -R 755 /var/www/html/
}


create_wordpress_database() {
  echo 'CREATING WORDPRESS DATABASE'
  sudo mysql -p"${MYSQL_ROOT_PASSWORD}" -u"root" -Bse "CREATE DATABASE $DATABASE_NAME;
  GRANT ALL PRIVILEGES ON $DATABASE_NAME.* TO '${USER}'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
  FLUSH PRIVILEGES;"
}


setting_up_wordpress() {
  echo 'SETTING UP WORDPRESS'
  sudo mv /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
  #set database details with perl find and replace
  sudo perl -pi -e "s'database_name_here'"$DATABASE_NAME"'g" /var/www/html/wp-config.php
        sudo perl -pi -e "s'username_here'"$USER"'g" /var/www/html/wp-config.php
        sudo perl -pi -e "s'password_here'"$DATABASE_PASSWORD"'g" /var/www/html/wp-config.php
  sudo systemctl restart apache2.service 
  sudo systemctl restart mysql.service 
  echo '******************** YOUR WORDPRESS SITE IS DEPLOYED! ********************'
  echo '******************** Visit http://yourIPAdrress to view and set it up. ********************'
  echo echo '******************** It may take up to 5 minutes to display ********************'
}
main() {
  apt-update
  install_apache
  install_mysql
  install_php
  start_apache_and_mysql_on_boot
  restart_apache
  download_wordpress
  create_wordpress_database
  setting_up_wordpress
}
main

