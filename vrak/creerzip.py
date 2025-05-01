import zipfile
import os

project_name = "mon-projet-docker"
base_path = f"./{project_name}"

# Créer les dossiers
os.makedirs(f"{base_path}/apache-php/www", exist_ok=True)

# Fichiers à créer
files = {
    f"{base_path}/docker-compose.yml": """\
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
""",
    f"{base_path}/apache-php/Dockerfile": """\
FROM php:7.4-apache

RUN docker-php-ext-install mysqli
RUN a2enmod rewrite
""",
    f"{base_path}/apache-php/www/page1.php": '<?php\necho "<h1>Page statique 1</h1>";\n?>',
    f"{base_path}/apache-php/www/page2.php": '<?php\necho "<h1>Page statique 2</h1>";\n?>',
    f"{base_path}/apache-php/www/index.php": """\
<?php
$servername = "db";
$username = "demo";
$password = "demopass";
$dbname = "demo";

$conn = new mysqli($servername, $username, $password, $dbname);

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
"""
}

# Écriture des fichiers
for path, content in files.items():
    with open(path, "w") as f:
        f.write(content)

# Création de l'archive zip
zip_filename = f"{project_name}.zip"
with zipfile.ZipFile(zip_filename, 'w', zipfile.ZIP_DEFLATED) as zipf:
    for root, _, filenames in os.walk(base_path):
        for filename in filenames:
            file_path = os.path.join(root, filename)
            zipf.write(file_path, os.path.relpath(file_path, os.path.dirname(base_path)))

print(f"Fichier {zip_filename} créé avec succès.")
