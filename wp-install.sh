DB_USER=root
DB_PASS=
project_name=amer1
project_host=localhost

db_host=localhost
wp_user=
wp_pass=
wp_email=
wp_title=$project_name
project_path=/var/www/html/$project_name
sudo mkdir $project_path
sudo chown -R $USER:$USER $project_path
cd $project_path

wp core download

wp core config  --dbname=$project_name --dbuser=$DB_USER --dbpass=$DB_PASS --dbhost=$db_host --dbprefix=

wp db create
#wp db drop

wp core install --url=$project_host/$project_name --title=$project_name --admin_user=$wp_user --admin_password=$wp_pass --admin_email=$wp_email

ls
pwd

