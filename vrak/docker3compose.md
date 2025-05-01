docker3compose.md

https://nouvelle-techno.fr/articles/2-docker-compose-et-dockerfile-apache-php-mysql

Sur vm ubuntu 22 !!

````
access@access-Standard-PC-i440FX-PIIX-1996:~/apachephp$ cat docker-compose.yml
services:
  php:
    image: php:8.2-apache
    container_name: php_82
    ports:
      - 8000:80
    volumes:
      - ./php:/var/www/html
  db:
    image: mysql:8.0
    container_name: mysql_8
    environment:
      MYSQL_ROOT_PASSWORD: rootpassword
      MYSQL_DATABASE: demo
      MYSQL_USER: user
      MYSQL_PASSWORD: password
    ports:
      - "3307:3306"
  phpmyadmin:
    image: phpmyadmin
    container_name: phpmyadmin
    environment:
      PMA_HOST: db
      MYSQL_ROOT_PASSWORD: rootpassword
    ports:
      - "8080:80"
````

````
access@devops1iprec:~$ mkdir apaphp
access@devops1iprec:~$ cd apaphp/
access@devops1iprec:~/apaphp$ sudo nano docker-compose.yaml
access@devops1iprec:~/apaphp$ mkdir php
access@devops1iprec:~/apaphp$ cd php
access@devops1iprec:~/apaphp/php$ sudo nano index.php
access@devops1iprec:~/apaphp/php$ cat index.php
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Bienvenue</title>
</head>
<body>
    <h1>Bienvenue sur mon site !</h1>
    <p>Ce message est généré avec PHP</p>
</body>
</html>
access@devops1iprec:~/apaphp/php$ cd ..
access@devops1iprec:~/apaphp$ ls
docker-compose.yaml  php
access@devops1iprec:~/apaphp$ cat docker-compose.yaml
services:
  php:
    image: php:8.2-apache
    container_name: php_82
    ports:
      - 8000:80
    volumes:
      - ./php:/var/www/html
  db:
    image: mysql:8.0
    container_name: mysql_8
    environment:
      MYSQL_ROOT_PASSWORD: rootpassword
      MYSQL_DATABASE: demo
      MYSQL_USER: user
      MYSQL_PASSWORD: password
    ports:
      - "3307:3306"
  phpmyadmin:
    image: phpmyadmin/phpmyadmin
    container_name: phpmyadmin
    environment:
      PMA_HOST: db
      MYSQL_ROOT_PASSWORD: rootpassword
    ports:
      - "8080:80"
````

