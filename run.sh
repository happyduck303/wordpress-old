#!/bin/bash
sudo apt-get update
sudo apt-get install -y apache2 php php-mysql
sudo apt-get install -y mysql-server
mysql --host=localhost --user=root --password=  << EOF
create user 'devopscilsy'@'localhost' identified by '1234567890';
grant all privileges on *.* to 'devopscilsy'@'localhost';
SELECT user,host FROM mysql.user;
\q

EOF
mysql --host=localhost --user=devopscilsy --password=1234567890 << EOF
create database wordpress;
show databases;
\q
EOF

cd
#buat folder website
sudo mkdir -p /var/www/miniclass.local/public_html
sudo mkdir -p /var/www/kelascilsy.local/public_html
sudo mkdir -p /var/www/taufik.local/public_html


#permission user
sudo chown -R $USER:$USER /var/www/miniclass.local/public_html
sudo chown -R $USER:$USER /var/www/kelascilsy.local/public_html
sudo chown -R $USER:$USER /var/www/taufik.local/public_html


#file config miniclass.local
nano /etc/apache2/sites-available/miniclass.local.conf << EOF
<VirtualHost *80>
   ServerName miniclass.local
   ServerAlias www.miniclass.local
   ServerAdmin admin@miniclass.local
   DocumentRoot /var/www/miniclass.local/public_html
</VirtualHost>
EOF

#file config kelascilsy.local
nano /etc/apache2/sites-available/kelascilsy.local.conf << EOF
<VirtualHost *80>
   ServerName kelascilsy.local
   ServerAlias www.kelascilsy.local
   ServerAdmin admin@kelascilsy.local
   DocumentRoot /var/www/kelascilsy.local/public_html
</VirtualHost>
EOF

#file config taufik.local
nano /etc/apache2/sites-available/taufik.local.conf << EOF
<VirtualHost *80>
   ServerName taufik.local
   ServerAlias www.taufik.local
   ServerAdmin admin@taufik.local
   DocumentRoot /var/www/taufik.local/public_html
</VirtualHost>
EOF

#clone wordpress di repo sendiri
git clone https://github.com/happyduck303/wordpress-old.git

#copy file wordpress ke 
sudo cp wordpress-old/* /var/www/miniclass.local/public_html
sudo cp wordpress-old/* /var/www/kelascilsy.local/public_html
sudo cp wordpress-old/* /var/www/taufik.local/public_html

#mengaktifkan website
sudo a2ensite miniclass.local
sudo a2ensite kelascilsy.local
sudo a2ensite taufik.local

#disable config bawaan
sudo a2dissite 000-default.conf

#reload apache2
sudo systemctl reload apache2
