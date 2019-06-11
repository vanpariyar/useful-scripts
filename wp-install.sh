#This script install wordpress with database and it is ready to work project for you 
#just need to enter the user and password in the browser
#if you need you can uncomment or comment any line all lines runs indindipendente , we are using the wp-cli for the project installatioin 

#!!! It will automatically make the database

#start:

#echo -n "press enter if you Want the default value further:"
read -p "Enter Project Name (Required) : " project_name
read -p "Enter Admin UserName (Required) : " wp_user
read -p "Enter Admin Password (Required) : " wp_pass
read -p "Enter Database Host (Required) : " db_host
read -p "Enter Database UserName (Required) : " DB_USER
read -p "Enter Database Password (Required) : " DB_PASS
read -p "Enter Database DB Prefix (Required) : " db_prefix
read -p "Enter Admin Email (Required) : " wp_email

echo
echo "################## Verify Details ##################"
echo 
echo -n " Project Name :  $project_name"
echo 
echo -n " Admin UserName :  $wp_user"
echo
echo -n " Admin Password :  $wp_pass"
echo
echo -n " Database Host :  $db_host"
echo
echo -n " Database UserName :  $DB_USER"
echo
echo -n " Database Password  :  $DB_PASS"
echo
echo -n " Database Prefix :  $db_prefix"
echo
echo -n " Admin Email :  $wp_email"
echo
echo 
echo "#####################################################"
echo
read -p " Do you want to continue (y / n) ?" choice

if [ "$choice" = "n" -o "$choice" = "N" ]; then
	exit 1
fi

## the magic starts from here let magician to do work
wp_title=$project_name
project_host=localhost

#this will execute the installation scripts in your pc
project_path=/var/www/html/$project_name

#this code for checking the project directory exsist or not
if [ -d $project_path ]; then 
	echo -n "! you have already that project folder name $project_path"
	exit 1
fi

#this will create the 
sudo mkdir $project_path
sudo chown -R $USER:$USER $project_path
cd $project_path 

#this will install wp cli if there is not available
wp_cli_file_path=/usr/local/bin/wp
if [ ! -f $wp_cli_file_path ]; then
	sudo apt install curl
	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	php wp-cli.phar --info
	chmod +x wp-cli.phar
	sudo mv wp-cli.phar /usr/local/bin/wp
fi  

wp core download

wp core config  --dbname=$project_name --dbuser=$DB_USER --dbpass=$DB_PASS --dbhost=$db_host --dbprefix=$db_prefix

wp db create
#wp db drop
#wp db export
#wp db import

wp core install --url=$project_host/$project_name --title=$project_name --admin_user=$wp_user --admin_password=$wp_pass --admin_email=$wp_email

#wp plugin search "contact form"
#wp plugin install contact-form-7 --activate
#wp plugin install advanced-custom-fields
#wp plugin install 

sudo chmod 755 -R wp-content
cd wp-content
sudo chmod 755 -R uploads	


#test wordpress with some data
# wp user generate --count=5 --role=editor
# wp user generate --count=10 --role=author
# wp term generate --count=12
# wp post generate --count=50

nautilus $project_path

ls
pwd

xdg-open http://localhost/$project_name
xdg-open http://localhost/$project_name/wp-admin

#====================================================================================
#      Made with :-) by Ron@k V@npariy@ 
#
#	for any issue in script email me at: vanpariyar@gmail.com
#====================================================================================
