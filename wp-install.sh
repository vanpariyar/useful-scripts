#This script install wordpress with database and it is ready to work project 
#if you need you can uncomment or comment any line all lines runs indindipendente


DB_USER=root
DB_PASS=root
project_name=wp-test
project_host=localhost

db_host=localhost
wp_user=admin
wp_pass=123456
wp_email=ronak@creolestudios.com
wp_title=$project_name
db_prefix=

#this will execute the installation scripts in your pc you need the wp cli installed in your pc
project_path=/var/www/html/$project_name

#this code for checking the project directory exsist or not
if [ -d $project_path ]; then 
	project_path+=-wp
	echo -n "! you have already that project Folder But, don,t worry we have ceated folder name $project_path"
fi


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

wp core install --url=$project_host/$project_name --title=$project_name --admin_user=$wp_user --admin_password=$wp_pass --admin_email=$wp_email

sudo chmod 755 -R wp-content
cd wp-content
sudo chmod 755 -R uploads	

ls
pwd

xdg-open http://localhost/$project_name
xdg-open http://localhost/$project_name/wp-admin
