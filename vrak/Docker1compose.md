## Docker compose

https://docs.docker.com/engine/install/ubuntu/

https://www.youtube.com/watch?v=gthvzSE4yIY&list=PLTk5ZYSbd9Mg51szw21_75Hs1xUpGObDm


### Installer Docker sur Ubuntu 20
https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04
````
stage@tst20docker1:~$ sudo apt update
[sudo] password for stage:
Réception de :1 http://security.ubuntu.com/ubuntu focal-security InRelease [128 kB]
Atteint :2 http://archive.ubuntu.com/ubuntu focal InRelease
.....
stage@tst20docker1:~$ sudo apt install apt-transport-https ca-certificates curl software-properties-common
Lecture des listes de paquets... Fait
Construction de l'arbre des dépendances
.....
stage@tst20docker1:~$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
OK
stage@tst20docker1:~$ sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
Réception de :1 https://download.docker.com/linux/ubuntu focal InRelease [57,7 kB]
Atteint :2 http://security.ubuntu.com/ubuntu focal-security InRelease
.....
stage@tst20docker1:~$ apt-cache policy docker-ce
docker-ce:
  Installé : (aucun)
  Candidat : 5:28.0.4-1~ubuntu.20.04~focal
.....
stage@tst20docker1:~$ sudo apt install docker-ce
Lecture des listes de paquets... Fait
Construction de l'arbre des dépendances
Lecture des informations d'état... Fait
Les paquets supplémentaires suivants seront installés :
.....
stage@tst20docker1:~$ sudo systemctl status docker
● docker.service - Docker Application Container Engine
     Loaded: loaded (/lib/systemd/system/docker.service; enabled; vendor preset: enabled)
     Active: active (running) since Mon 2025-04-14 09:29:17 UTC; 1min 26s ago
TriggeredBy: ● docker.socket
       Docs: https://docs.docker.com
````
#### Becoming SU

````
stage@tst20docker1:~$ sudo usermod -aG docker stage
stage@tst20docker1:~$ su - stage
stage@tst20docker1:~$ groups
stage adm cdrom sudo dip plugdev lxd docker
stage@tst20docker1:~$ docker
Usage:  docker [OPTIONS] COMMAND

A self-sufficient runtime for containers

Common Commands:
  run         Create and run a new container from an image
.....
stage@tst20docker1:~$ docker info
Client: Docker Engine - Community
 Version:    28.0.4
 Context:    default
.....
````
#### Working with images
````
stage@tst20docker1:~$ docker run hello-world
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
e6590344b1a5: Pull complete
Digest: sha256:424f1f86cdf501deb591ace8d14d2f40272617b51b374915a87a2886b2025ece
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/


stage@tst20docker1:~$ docker search zorglub
NAME                                   DESCRIPTION                                     STARS     OFFICIAL
zorglub42/osa                          Open Services Access: Apache RP management t…   0
zorglubt/getting-started                                                               0
zorglub789/concepts-build-image-demo                                                   0
zorglub789/docker-quickstart                                                           0
gerardzorglub/sysinfo-api                                                              0
stage@tst20docker1:~$
````
#### Working with webgoat

``docker pull`` va télécharger les images demandées
``docker images`` va lister les images présentes
``docker build`` va créer un nouveau container
``docker run`` va créer et démarrer un nouveau container
``docker start`` va redémarrer un container existant
``docker stop`` va arrêter un container existant
````
stage@tst20docker1:~$ docker run -d -p 8080:8080 webgoat/webgoat
Unable to find image 'webgoat/webgoat:latest' locally
latest: Pulling from webgoat/webgoat
5a7813e071bf: Pull complete
d1504bee8985: Pull complete
7b5a3507f742: Pull complete
4f4fb700ef54: Pull complete
ea28f6f7f0aa: Pull complete
7b2e4df376c9: Pull complete
307ac9d4e999: Pull complete
Digest: sha256:3101bd9e7bcfe122d7ef91e690ef3720de36cc4e86b3d06763a1ddf2e2751a4b
Status: Downloaded newer image for webgoat/webgoat:latest
d88563c15303f56d9a6a59576f34f1f96de50beb8343086a123cf4bf8ee46ee9

stage@tst20docker1:~$ docker images
REPOSITORY        TAG       IMAGE ID       CREATED        SIZE
webgoat/webgoat   latest    d8434d588ee3   4 weeks ago    601MB
hello-world       latest    74cc54e27dc4   2 months ago   10.1kB

stage@tst20docker1:~$ docker ps
CONTAINER ID   IMAGE             COMMAND                  CREATED         STATUS                     PORTS                                                   NAMES
d88563c15303   webgoat/webgoat   "java -Duser.home=/h…"   6 minutes ago   Up 6 minutes (unhealthy)   0.0.0.0:8080->8080/tcp, [::]:8080->8080/tcp, 9090/tcp   wizardly_shamir
stage@tst20docker1:~$ docker ps -a
CONTAINER ID   IMAGE             COMMAND                  CREATED          STATUS                      PORTS                                                   NAMES
d88563c15303   webgoat/webgoat   "java -Duser.home=/h…"   6 minutes ago    Up 6 minutes (unhealthy)    0.0.0.0:8080->8080/tcp, [::]:8080->8080/tcp, 9090/tcp   wizardly_shamir
85485c3b8647   hello-world       "/hello"                 14 minutes ago   Exited (0) 14 minutes ago

stage@tst20docker1:~$ docker stop d885
d885
stage@tst20docker1:~$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

````
#### Working with ubuntu
````
stage@tst20docker1:~$ docker pull ubuntu
Using default tag: latest
latest: Pulling from library/ubuntu
2726e237d1a3: Pull complete
Digest: sha256:1e622c5f073b4f6bfad6632f2616c7f59ef256e96fe78bf6a595d1dc4376ac02
Status: Downloaded newer image for ubuntu:latest
docker.io/library/ubuntu:latest

stage@tst20docker1:~$ docker images
REPOSITORY        TAG       IMAGE ID       CREATED        SIZE
ubuntu            latest    602eb6fb314b   5 days ago     78.1MB
webgoat/webgoat   latest    d8434d588ee3   4 weeks ago    601MB
hello-world       latest    74cc54e27dc4   2 months ago   10.1kB

stage@tst20docker1:~$ docker run -it ubuntu
root@2d46c8e833e3:/# ls
bin  boot  dev  etc  home  lib  lib64  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var
root@2d46c8e833e3:/# pwd
/
root@2d46c8e833e3:/# cat /etc/os-release
PRETTY_NAME="Ubuntu 24.04.2 LTS"
NAME="Ubuntu"
VERSION_ID="24.04"
VERSION="24.04.2 LTS (Noble Numbat)"
root@2d46c8e833e3:/# apt update
Get:1 http://archive.ubuntu.com/ubuntu noble InRelease [256 kB]
Get:2 http://archive.ubuntu.com/ubuntu noble-updates InRelease [126 kB]
.....
root@2d46c8e833e3:/# apt install nodejs
Reading package lists... Done
Building dependency tree... Done
.....
Running hooks in /etc/ca-certificates/update.d...
done.
root@2d46c8e833e3:/# node -v
v18.19.1
root@2d46c8e833e3:/# exit
exit
stage@tst20docker1:~$
````
#### Deleting container
``docker rm``
````
stage@tst20docker1:~$ docker ps -a
CONTAINER ID   IMAGE             COMMAND                  CREATED          STATUS                        PORTS     NAMES
874afc02ac51   74cc54e27dc4      "/hello"                 2 minutes ago    Exited (0) 2 minutes ago                reverent_lumiere
2d46c8e833e3   ubuntu            "/bin/bash"              10 minutes ago   Exited (130) 5 minutes ago              trusting_mclaren
d88563c15303   webgoat/webgoat   "java -Duser.home=/h…"   21 minutes ago   Exited (143) 13 minutes ago             wizardly_shamir
85485c3b8647   hello-world       "/hello"                 29 minutes ago   Exited (0) 29 minutes ago               nice_kilby

stage@tst20docker1:~$ docker rm reverent_lumiere
reverent_lumiere
stage@tst20docker1:~$ docker ps -a
CONTAINER ID   IMAGE             COMMAND                  CREATED          STATUS                        PORTS     NAMES
2d46c8e833e3   ubuntu            "/bin/bash"              11 minutes ago   Exited (130) 6 minutes ago              trusting_mclaren
d88563c15303   webgoat/webgoat   "java -Duser.home=/h…"   22 minutes ago   Exited (143) 14 minutes ago             wizardly_shamir
85485c3b8647   hello-world       "/hello" 
````
### Informatique sans complexe
https://www.youtube.com/watch?v=8cH0ilGlQdE&list=PLp3pYrjF9bCkbUw7zEeQ4YBN6J2XUT-uY
https://www.youtube.com/watch?v=MfxKDC3RR-U

#### First container (video3)
````

stage@tst20docker1:~$ docker version
Client: Docker Engine - Community
 Version:           28.0.4
 API version:       1.48
 Go version:        go1.23.7
 Git commit:        b8034c0
.....

stage@tst20docker1:~$ docker run -p 80:80 httpd
Unable to find image 'httpd:latest' locally
latest: Pulling from library/httpd
8a628cdd7ccc: Pull complete
60ba3d18ad64: Pull complete
4f4fb700ef54: Pull complete
03e322382f93: Pull complete
4ad6b63c403f: Pull complete
c613327bbca6: Pull complete
Digest: sha256:4564ca7604957765bd2598e14134a1c6812067f0daddd7dc5a484431dd03832b
Status: Downloaded newer image for httpd:latest
AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 172.17.0.2. Set the 'ServerName' directive globally to suppress this message
AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 172.17.0.2. Set the 'ServerName' directive globally to suppress this message
[Mon Apr 14 10:15:49.740746 2025] [mpm_event:notice] [pid 1:tid 1] AH00489: Apache/2.4.63 (Unix) configured -- resuming normal operations
[Mon Apr 14 10:15:49.740968 2025] [core:notice] [pid 1:tid 1] AH00094: Command line: 'httpd -D FOREGROUND'
[Mon Apr 14 10:16:15.366269 2025] [mpm_event:notice] [pid 1:tid 1] AH00491: caught SIGTERM, shutting down
````
Depuis un autre terminal
````
Last login: Mon Apr 14 08:59:56 2025 from 192.168.80.1
stage@tst20docker1:~$ docker ps
CONTAINER ID   IMAGE     COMMAND              CREATED         STATUS         PORTS                                 NAMES
18818e62f461   httpd     "httpd-foreground"   5 minutes ago   Up 5 minutes   0.0.0.0:80->80/tcp, [::]:80->80/tcp   cool_noether
````

#### Mapping de répertoire (video4)
-v <local>:<container>

Identifier l'emplacement dans le container du stockage depuis
https://hub.docker.com/_/httpd

>**Without a Dockerfile**
>If you don't want to include a Dockerfile in your project, it is sufficient to do the following:
>``$ docker run -dit --name my-apache-app -p 8080:80 -v "$PWD":/usr/local/apache2/htdocs/ httpd:2.4``

Création du dossier récepteur
````
stage@tst20docker1:~$ mkdir htdocs
````
**Script pour atteindre le serveur dans le conteneur**
````
#!/bin/bash

# Récupère le conteneur Apache en cours
CONTAINER_ID=$(docker ps --filter "ancestor=httpd" --format "{{.ID}}")

if [ -z "$CONTAINER_ID" ]; then
  echo "❌ Aucun conteneur Apache (httpd) en cours d'exécution."
  exit 1
fi

# Récupère le port redirigé (host:container)
PORT=$(docker inspect --format='{{(index (index .NetworkSettings.Ports "80/tcp") 0).HostPort}}' "$CONTAINER_ID")

# Récupère l'adresse IP du serveur
IP=$(hostname -I | awk '{print $1}')

echo "✅ Conteneur Apache trouvé : $CONTAINER_ID"
echo "🌐 URL d'accès : http://$IP:$PORT"
````
Puis tester depuis un navigateur connecté au réseau.
````
stage@tst20docker1:~$ sudo nano testurl.sh
[sudo] password for stage:
stage@tst20docker1:~$ sudo chmod +x testurl.sh
stage@tst20docker1:~$ ./testurl.sh
✅ Conteneur Apache trouvé : 9e179629784a
🌐 URL d'accès : http://192.168.80.199:80
````
Le navigateur doit afficher:
``Index of /``

**Peut être vérifié aussi avec curl!**
``curl -v localhost:80`` ou IP appropriée??

Modifier contenu du dossier htdocs
````
stage@tst20docker1:~$ cd htdocs/
stage@tst20docker1:~/htdocs$ echo "Impôt sur la fortune" > index.html
````
Après redémarrage du conteneur, Le navigateur doit afficher ???
``Impôt sur la fortune``

````
blabla
````
#### Docker compose (video5)
**Installation next-cloud** avec 2 conteneurs
Test préalable, mais installation eut manquer aussi ???
````
stage@tst20docker1:~$ docker compose
Usage:  docker compose [OPTIONS] COMMAND

Define and run multi-container applications with Docker

Options:
      --all-resources              Include all resources, even those not used by services
.....
stage@tst20docker1:~/nextcloud$ sudo apt install docker-compose
Lecture des listes de paquets... Fait
Construction de l'arbre des dépendances
Lecture des informations d'état... Fait
.....
````
Dans https://hub.docker.com/_/nextcloud identifier:
````
Running this image with Docker Compose

The easiest way to get a fully featured and functional setup is using a compose.yaml file. There are too many different possibilities to setup your system, so here are only some examples of what you have to look for.

At first, make sure you have chosen the right base image (fpm or apache) and added features you wanted (see below). In every case, you would want to add a database container and docker volumes to get easy access to your persistent data. When you want to have your server reachable from the internet, adding HTTPS-encryption is mandatory! See below for more information.
Base version - apache

This version will use the apache image and add a mariaDB container. The volumes are set to keep your data persistent. This setup provides no ssl encryption and is intended to run behind a proxy.

Make sure to pass in values for MYSQL_ROOT_PASSWORD and MYSQL_PASSWORD variables before you run this setup.
````
Installer sur le serveur avec
````
stage@tst20docker1:~$ mkdir nextcloud
stage@tst20docker1:~$ cd nextcloud/
stage@tst20docker1:~/nextcloud$ sudo nano docker-compose.yml
[sudo] password for stage:
stage@tst20docker1:~/nextcloud$ docker compose up -d
[+] Running 32/32
 ✔ app Pulled                                                                                                                                                              73.2s
   ✔ 8a628cdd7ccc Already exists                                                                                                                                            0.0s
   ✔ 3c380393612c Pull complete                                                                                                                                             4.6s
   ✔ b572e7d435eb Pull complete
.....
````
Contenu depuis la page https://hub.docker.com/_/nextcloud
````
volumes:
  nextcloud:
  db:

services:
  db:
    image: mariadb:10.6
    restart: always
    command: --transaction-isolation=READ-COMMITTED --log-bin=binlog --binlog-format=ROW
    volumes:
      - db:/var/lib/mysql
    environment:
      - MYSQL_ROOT_PASSWORD=
      - MYSQL_PASSWORD=
      - MYSQL_DATABASE=nextcloud
      - MYSQL_USER=nextcloud

  app:
    image: nextcloud
    restart: always
    ports:
      - 8080:80
    links:
      - db
    volumes:
      - nextcloud:/var/www/html
    environment:
      - MYSQL_PASSWORD=
      - MYSQL_DATABASE=nextcloud
      - MYSQL_USER=nextcloud
      - MYSQL_HOST=db
````
Depuis un navigateur ouvrir ``http://192.168.80.199:8080/`` pour atteindre le portail *Nextcloud*
````
stage@tst20docker1:~/nextcloud$ docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS                         PORTS                                     NAMES
7b2a7b0d8f21   nextcloud      "/entrypoint.sh apac…"   10 minutes ago   Up 10 minutes                  0.0.0.0:8080->80/tcp, [::]:8080->80/tcp   nextcloud-app-1
fb9938030590   mariadb:10.6   "docker-entrypoint.s…"   10 minutes ago   Restarting (1) 7 seconds ago                                             nextcloud-db-1
stage@tst20docker1:~/nextcloud$ docker-compose logs -f
ERROR: The Compose file './docker-compose.yml' is invalid because:
Unsupported config option for services: 'app'
Unsupported config option for volumes: 'nextcloud'
stage@tst20docker1:~/nextcloud$ docker-compose down
ERROR: The Compose file './docker-compose.yml' is invalid because:
Unsupported config option for services: 'app'
Unsupported config option for volumes: 'nextcloud'
````
Ne fonctionne pas si dans mauvais dossier !!!
````
stage@tst20docker1:~$ cd nextcloud/
stage@tst20docker1:~/nextcloud$ docker compose down
[+] Running 3/3
 ✔ Container nextcloud-app-1  Removed                                                                                                                                       1.3s
 ✔ Container nextcloud-db-1   Removed                                                                                                                                       0.0s
 ✔ Network nextcloud_default  Removed                                                                                                                                       0.1s
stage@tst20docker1:~/nextcloud$
stage@tst20docker1:~/nextcloud$ docker ps -a
CONTAINER ID   IMAGE             COMMAND                  CREATED          STATUS                        PORTS     NAMES
448f5e38b8ac   httpd             "httpd-foreground"       37 minutes ago   Exited (0) 35 minutes ago               modest_moore
f5cd322ff2cb   httpd             "httpd-foreground"       38 minutes ago   Exited (0) 38 minutes ago               friendly_greider
9e179629784a   httpd             "httpd-foreground"       52 minutes ago   Exited (137) 46 minutes ago             nostalgic_northcutt
18818e62f461   httpd             "httpd-foreground"       3 hours ago      Exited (0) 2 hours ago                  cool_noether
ba3526c6af90   httpd             "httpd-foreground"       3 hours ago      Exited (0) 3 hours ago                  jolly_lalande
2d46c8e833e3   ubuntu            "/bin/bash"              3 hours ago      Exited (130) 3 hours ago                trusting_mclaren
d88563c15303   webgoat/webgoat   "java -Duser.home=/h…"   3 hours ago      Exited (143) 3 hours ago                wizardly_shamir
85485c3b8647   hello-world       "/hello"                 3 hours ago      Exited (0) 3 hours ago                  nice_kilby
stage@tst20docker1:~/nextcloud$ docker images
REPOSITORY        TAG       IMAGE ID       CREATED         SIZE
ubuntu            latest    602eb6fb314b   6 days ago      78.1MB
nextcloud         latest    b151457b6932   3 weeks ago     1.42GB
webgoat/webgoat   latest    d8434d588ee3   4 weeks ago     601MB
mariadb           10.6      e620a5d53dc4   2 months ago    396MB
httpd             latest    10fd72f437c4   2 months ago    148MB
hello-world       latest    74cc54e27dc4   2 months ago    10.1kB
ubuntu            18.04     f9a80a55f492   22 months ago   63.2MB
 ````

 ### NetworkChuck -16:25-

 https://www.youtube.com/watch?v=DM65_JyGxCo

````
sudo apt update
sudo apt install docker.io docker-compose -y
sudo docker run --name web -itd -p 8080:80 nginx
````


````
stage@tst20vide:~/coffee$ nano docker-compose.yml
stage@tst20vide:~/coffee$ cat docker-compose.yml
version: "3"
services:
        website:
                image: nginx
                ports:
                        - "8081:80"
                restart: always


````

#### Exercice 2
````

stage@tst20vide:~$ mkdir wordprezz
stage@tst20vide:~$ cd wordprezz/
stage@tst20vide:~/wordprezz$ sudo nano docker-compose.yaml
stage@tst20vide:~/wordprezz$ cat docker-compose.yaml
version: "3"
services:
        wordpress:
                image: wordpress
                ports:
                        - "8089:80"
                depends_on:
                        - mysql
                environment:
                        WORDPRESS_DB_HOST: mysql
                        WORDPRESS_DB_USER: root
                        WORDPRESS_DB_PASSWORD: "coffee"
                        WORDPRESS_DB_NAME: wordpress
        mysql:
                image: "mysql:5.7"
                environment:
                        MYSQL_ROOT_PASSWORD: "coffee"
                        MYSQL_DATABASE: wordpress
                volumes:
                        - ./mysql:/var/lib/mysql
networks:
        reseau:
                ipam:
                        driver: default
                        config:
                                - subnet: "192.168.90.0/24"

````
### Monis Yousouf
https://www.youtube.com/watch?v=k29FmUcihSA
https://monisyousuf.medium.com/what-is-docker-docker-file-images-and-containers-with-code-examples-6d81d426b3a0
https://www.youtube.com/watch?app=desktop&v=BTXfR76WmCw
https://github.com/monisyousuf/youtube-tutorials/blob/main/CD_007_docker_2/database/database.Dockerfile


````
blabla
````


````
blabla
````


````
blabla
````
