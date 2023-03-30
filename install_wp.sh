HOMEDIR=/home/ec2-user
sudo yum install httpd php mysql -y
sudo yum install php-{cgi,curl,mbstring,gd,mysqlnd,gettext,json,xml,fpm,intl,zip,common,pear}  -y
sudo wget https://wordpress.org/latest.tar.gz
sudo tar -xvf latest.tar.gz
sudo cp -r wordpress/* /var/www/html/
sudo chown apache:apache -R /var/www/html
sudo amazon-linux-extras enable php7.4
sudo yum clean metadata
sudo yum install php php-common php-pear -y
sudo systemctl enable httpd
sudo systemctl start httpd
mysql -h '${aws_db_instance.rds_db.address}' -u'${var.dbuser}' -p'${var.dbpassword}' -e 'create database ${var.dbname};'

sudo cp /home/ec2-user/wordpress/wp-config-sample.php /home/ec2-user/wordpress/wp-config.php
sudo sed -i "s/database_name_here/${var.dbname}/" /home/ec2-user/wordpress/wp-config.php
sudo sed -i "s/username_here/${var.dbuser}/" /home/ec2-user/wordpress/wp-config.php
sudo sed -i "s/password_here/${var.dbpassword}/" /home/ec2-user/wordpress/wp-config.php
# sudo sed -i "s/localhost/${rdsendpoint}/" /home/ec2-user/wordpress/wp-config.php
