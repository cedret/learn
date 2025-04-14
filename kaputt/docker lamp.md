Voici comment créer un projet Docker avec `docker-compose` sur Ubuntu, qui inclut :

- Deux pages **PHP statiques** (servies par Apache),
- Une page **PHP dynamique** qui interagit avec une base de données **MySQL**.


ou bien

''python3 creer_zip.py''

---

## 🧱 Structure du projet

```bash
mon-projet-docker/
├── docker-compose.yml
├── apache-php/
│   ├── Dockerfile
│   └── www/
│       ├── index.php         # Page dynamique (avec MySQL)
│       ├── page1.php         # Page statique 1
│       └── page2.php         # Page statique 2
```

---

## 🐳 Fichier `docker-compose.yml`

```yaml
version: '3.8'

services:
  web:
    build: ./apache-php
    ports:
      - "8080:80"
    volumes:
      - ./apache-php/www:/var/www/html
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
```

---

## 🧰 Fichier `Dockerfile` dans `apache-php/`

```Dockerfile
FROM php:7.4-apache

# Installer l'extension mysqli
RUN docker-php-ext-install mysqli

# Activer les modules Apache si nécessaire
RUN a2enmod rewrite
```

---

## 📄 Pages PHP dans `apache-php/www/`

### `page1.php` (statique)

```php
<?php
echo "<h1>Page statique 1</h1>";
?>
```

### `page2.php` (statique)

```php
<?php
echo "<h1>Page statique 2</h1>";
?>
```

### `index.php` (dynamique avec MySQL)

```php
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
```

---

## ▶️ Lancer le projet

Dans le dossier `mon-projet-docker` :

```bash
docker-compose up --build
```

Puis, dans ton navigateur :

- [http://localhost:8080/page1.php](http://localhost:8080/page1.php)
- [http://localhost:8080/page2.php](http://localhost:8080/page2.php)
- [http://localhost:8080/index.php](http://localhost:8080/index.php) ← cette page interagit avec MySQL

---

Souhaites-tu que je t’aide à générer ces fichiers automatiquement, ou que je te fasse un zip prêt à utiliser ?