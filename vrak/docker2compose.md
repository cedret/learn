docker2compose.md

https://www.youtube.com/watch?v=2ygog4MHXws

??
https://blog.silarhi.fr/image-docker-php-apache-parfaite/

Si besoin ssh:
``sudo apt install openssh-server``
``sudo ufw allow ssh``
``sudo nano /etc/ssh/sshd_config``
``sudo service ssh restart``

## Tentative avec 'docker run'

Vérification des présences
````
access@iprecgithub:~$ docker -v
Command 'docker' not found, but can be installed with:
sudo snap install docker         # version 27.5.1, or
sudo apt  install podman-docker  # version 3.4.4+ds1-1ubuntu1.22.04.3
sudo apt  install docker.io      # version 26.1.3-0ubuntu1~22.04.1
See 'snap info docker' for additional versions.
access@iprecgithub:~$ docker ps -a
Command 'docker' not found, but can be installed with:
sudo snap install docker         # version 27.5.1, or
sudo apt  install podman-docker  # version 3.4.4+ds1-1ubuntu1.22.04.3
sudo apt  install docker.io      # version 26.1.3-0ubuntu1~22.04.1
See 'snap info docker' for additional versions.
access@iprecgithub:~$ docker image ls
Command 'docker' not found, but can be installed with:
sudo snap install docker         # version 27.5.1, or
sudo apt  install podman-docker  # version 3.4.4+ds1-1ubuntu1.22.04.3
sudo apt  install docker.io      # version 26.1.3-0ubuntu1~22.04.1
See 'snap info docker' for additional versions.

access@iprecgithub:~$ sudo apt update
access@iprecgithub:~$ sudo apt install docker.io
access@iprecgithub:~$ sudo apt install docker-compose
access@iprecgithub:~$ docker pull php:8.2-apache

access@iprecgithub:~$ sudo docker run -d -p 8000:80 php:8.2-apache
6d796e1a38821da4c8d36f634bb4a15d2c93204881c0537d7df58d8f9983cc9d
access@iprecgithub:~$
access@iprecgithub:~$ sudo docker ps
CONTAINER ID   IMAGE            COMMAND                  CREATED          STATUS          PORTS                                   NAMES
6d796e1a3882   php:8.2-apache   "docker-php-entrypoi…"   59 seconds ago   Up 58 seconds   0.0.0.0:8000->80/tcp, :::8000->80/tcp   determined_benz
````
En se connectant à l'ip de la machine, on obtient:
``Forbidden``
``You don't have permission to access this resource.``
``Apache/2.4.62 (Debian) Server at 192.168.1.144 Port 8000``



````
access@iprecgithub:~$ mkdir dockerphp
access@iprecgithub:~$ cd dockerphp/
access@iprecgithub:~/dockerphp$ mkdir php
access@iprecgithub:~/dockerphp$ cd php
access@iprecgithub:~/dockerphp/php$ sudo nano index.php
access@iprecgithub:~/dockerphp/php$ cat index.php
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Bienvenue</title>
</head>
<body>
    <h1>Bienvenue sur mon site !</h1>
    <p>Ce message est généré avec PHP 😊</p>
</body>
</html>
````

````
access@iprecgithub:~/dockerphp/php$ sudo docker run -d -p 8000:80 -v ./php:/var/www/html php:8.2-apache
2f62bf655a3dcff9ee6ce3ecb9cadbf0a9cad6ea9a6f6613799417d415d95b85
access@iprecgithub:~/dockerphp/php$ sudo docker ps
CONTAINER ID   IMAGE            COMMAND                  CREATED          STATUS          PORTS                                   NAMES
2f62bf655a3d   php:8.2-apache   "docker-php-entrypoi…"   21 seconds ago   Up 20 seconds   0.0.0.0:8000->80/tcp, :::8000->80/tcp   friendly_booth
access@iprecgithub:~/dockerphp/php$ sudo docker stop 6d796e1a3882
6d796e1a3882
````
L'affichage n'aboutit pas avec la version server!!!

## Tentative avec 'docker-compose'
Avec VM proxmox et Ubuntu desktop

````
access@access-Standard-PC-i440FX-PIIX-1996:~$ sudo apt install docker.io
access@access-Standard-PC-i440FX-PIIX-1996:~$ sudo apt install docker-compose

access@access-Standard-PC-i440FX-PIIX-1996:~/apachephp$ ls
docker-compose.yml  php
access@access-Standard-PC-i440FX-PIIX-1996:~/apachephp$ cat docker-compose.yml
version: "3.8"

services:
  php:
    image: php:8.2-apache
    container_name: php82
    ports:
      - 8000:80
    volumes:
      - ./php:/var/www/html
````

````
access@access-Standard-PC-i440FX-PIIX-1996:~/apachephp$ ls
docker-compose.yml
access@access-Standard-PC-i440FX-PIIX-1996:~/apachephp$ mkdir php
access@access-Standard-PC-i440FX-PIIX-1996:~/apachephp$ cd php
access@access-Standard-PC-i440FX-PIIX-1996:~/apachephp/php$ sudo nano index.php
access@access-Standard-PC-i440FX-PIIX-1996:~/apachephp/php$ cat index.php
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
````

````
access@access-Standard-PC-i440FX-PIIX-1996:~/apachephp/php$ sudo nano about.php
access@access-Standard-PC-i440FX-PIIX-1996:~/apachephp/php$ cat about.php
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>À propos</title>
</head>
<body>
    <h1>À propos de ce site</h1>
    <p>Ce site a été créé pour apprendre Docker.</p>
</body>
</html>
access@access-Standard-PC-i440FX-PIIX-1996:~/apachephp/php$ sudo nano contact.php
access@access-Standard-PC-i440FX-PIIX-1996:~/apachephp/php$ cd ..
access@access-Standard-PC-i440FX-PIIX-1996:~/apachephp$ mkdir sql
access@access-Standard-PC-i440FX-PIIX-1996:~/apachephp$ cd sql
access@access-Standard-PC-i440FX-PIIX-1996:~/apachephp/sql$ sudo nano init.sql
access@access-Standard-PC-i440FX-PIIX-1996:~/apachephp/sql$ cat init.sql
CREATE DATABASE monsite;

USE monsite;

CREATE TABLE contact_info (
    id INT AUTO_INCREMENT PRIMARY KEY,
    message TEXT NOT NULL
);

INSERT INTO contact_info (message) VALUES ("N'hésitez pas à nous écrire à contact@monsite.com");
access@access-Standard-PC-i440FX-PIIX-1996:~/apachephp/sql$ cd ..
access@access-Standard-PC-i440FX-PIIX-1996:~/apachephp$ cd php
access@access-Standard-PC-i440FX-PIIX-1996:~/apachephp/php$ cat contact.php
<?php
// Connexion à la base de données
$host = 'localhost';
$dbname = 'monsite';
$username = 'root';
$password = ''; // Mot de passe selon ton install XAMPP/WAMP/MAMP

try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    // Requête pour récupérer le message
    $stmt = $pdo->query("SELECT message FROM contact_info LIMIT 1");
    $row = $stmt->fetch();

    $message = $row ? $row['message'] : "Aucun message trouvé.";
} catch (PDOException $e) {
    $message = "Erreur de connexion : " . $e->getMessage();
}
?>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Contact</title>
</head>
<body>
    <h1>Contact</h1>
    <p><?= htmlspecialchars($message) ?></p>
</body>
</html>

````

````
blabla
````

````
blabla
````
