### Create User in mysql and grant previlages

```shell
CREATE DATABASE database-name;
CREATE USER 'user'@'host' IDENTIFIED BY 'password';
GRANT ALL ON DBNAME.* TO 'user'@'host';
```