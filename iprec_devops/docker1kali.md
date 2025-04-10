   95  sudo apt install -y ca-certificates curl gnupg lsb-release
   96  sudo mkdir -p /etc/apt/keyrings
   97  curl -fsSL https://download.docker.com/linux/debian/gpg | sudo tee /etc/apt/keyrings/docker.asc > /dev/null
   98  sudo chmod a+r /etc/apt/keyrings/docker.asc
   99  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null\n
  100  sudo apt update
  101  sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin\n
  102  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null\n
  103  sudo apt update
  104  sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin\n
  105  sudo systemctl enable --now docker\ndocker --version\n
  106  docker run -it -p 127.0.0.1:8080:8080 -p 127.0.0.1:9090:9090 webgoat/webgoat
  107  sudo apt install docker-cli
  108  sudo apt install podman-docker\n

  https://www.geeksforgeeks.org/how-to-install-docker-in-kali-linux/

  Section 1: Install Docker on Kali Linux

  curl -fsSL https://download.docker.com/linux/debian/gpg

  sudo apt install -y docker-ce

  systemctl start docker

  sudo systemctl enable docker

  docker versionzs

  **WebGoat** est une application Java vulnérable conçue pour l'apprentissage de la sécurité web. Voici comment l'installer et l'exécuter sur **Kali Linux** (ou toute autre distribution Linux) :

---

## 📌 **Installation de WebGoat sur Kali Linux**
### ✅ **1. Installer Java (si ce n'est pas déjà fait)**
WebGoat nécessite **Java 11+**, donc assurez-vous qu'il est installé :
```bash
sudo apt update
sudo apt install -y openjdk-11-jdk
```
Vérifiez l’installation :
```bash
java -version
```
> Vous devriez voir une sortie indiquant **Java 11** ou plus.

---

### ✅ **2. Télécharger WebGoat**
WebGoat est distribué sous forme de **fichier JAR**. Téléchargez-le depuis GitHub :
```bash
wget https://github.com/WebGoat/WebGoat/releases/latest/download/webgoat-server-jar-with-dependencies.jar -O WebGoat.jar
```

---

### ✅ **3. Exécuter WebGoat**
Lancez WebGoat avec Java :
```bash
java -jar WebGoat.jar
```
Par défaut, WebGoat tourne sur le **port 8080**.

---

### ✅ **4. Accéder à WebGoat**
Ouvrez votre navigateur et allez à :
```
http://localhost:8080/WebGoat
```
Connectez-vous avec les identifiants par défaut :
- **Nom d'utilisateur** : `webgoat`
- **Mot de passe** : `webgoat`

---

## 🔧 **Exécuter WebGoat avec Docker (Alternative)**
Si vous préférez l’exécuter via **Docker**, utilisez cette commande :
```bash
docker run -p 8080:8080 -p 9090:9090 webgoat/webgoat
```
Puis accédez à **WebGoat** via :
```
http://localhost:8080/WebGoat
```
et **WebWolf** (outil complémentaire) via :
```
http://localhost:9090/WebWolf
```

---

## 🎯 **Bonus : Exécuter WebGoat en arrière-plan**
Si vous voulez exécuter WebGoat sans garder le terminal ouvert :
```bash
nohup java -jar WebGoat.jar > webgoat.log 2>&1 &
```
Cela enregistre les logs dans `webgoat.log` et tourne en arrière-plan.

---

**C’est tout !** 🎉 Vous avez maintenant **WebGoat** fonctionnel sur **Kali Linux** pour vos tests de sécurité web. 🚀