docker4compose.md

Sur vm ubuntu 22 !!

sudo apt update

Si besoin ssh:
``sudo apt install openssh-server``
``sudo ufw allow ssh``
``sudo nano /etc/ssh/sshd_config``
``sudo service ssh restart``

````
dckr/
├── docker-compose.yml
├── apaphp/
│   ├── Dockerfile
│   └── www/
│       ├── contact.php       # Page dynamique (avec MySQL)
│       ├── index.php         # Page statique 1
│       └── about.php         # Page statique 2
````


````
blabla
````

docker-compose.yml
````
version: '3.8'

services:
  web:
    build: ./apache-php
    ports:
      - "8080:80"
    volumes:
      - ./apaphp/www:/var/www/html
    depends_on:
      - db

  db:
    image: mysql:5.7
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: rootpass
      MYSQL_DATABASE: demo
      MYSQL_USER: demo
      MYSQL_PASSWORD: demopass
    ports:
      - "3306:3306"
````

Fichier Dockerfile dans apache-php/
````
FROM php:7.4-apache

# Installer l'extension mysqli
RUN docker-php-ext-install mysqli

# Activer les modules Apache si nécessaire
RUN a2enmod rewrite
````

index.php dans apache-php/www/
````
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

about.php dans apache-php/www/
````
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
````

contact.php dans  (dynamique avec MySQL)
````
<?php
$servername = "db"; // nom du service docker-compose
$username = "demo";
$password = "demopass";
$dbname = "demo";

// Créer la connexion
$conn = new mysqli($servername, $username, $password, $dbname);

// Vérifier la connexion
if ($conn->connect_error) {
    die("Échec de la connexion : " . $conn->connect_error);
}

$sql = "CREATE TABLE IF NOT EXISTS messages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    contenu VARCHAR(255) NOT NULL
)";
$conn->query($sql);

$conn->query("INSERT INTO messages (contenu) VALUES ('Ceci est un message dynamique')");

$result = $conn->query("SELECT * FROM messages");

echo "<h1>Messages :</h1>";
while($row = $result->fetch_assoc()) {
    echo "<p>" . htmlspecialchars($row['contenu']) . "</p>";
}

$conn->close();
?>
````

``docker-compose up --build``

http://localhost:8080/page1.php

---
---
docker-compose.yml
````
blabla
````

docker-compose.yml
````
blabla
````

docker-compose.yml
````
blabla
````
