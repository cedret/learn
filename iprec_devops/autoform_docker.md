## docker (tech with nana)

Projet à 1h07:
https://www.youtube.com/watch?v=3c-iBn73dDE&list=PLy7NrYWoggjxtN4YbSMYFFdpaxb-fR4zC

*Monis Yousuf*
https://www.youtube.com/@MonisYousuf

*Phoenix nap cheatsheet*
https://phoenixnap.com/kb/docker-commands-cheat-sheet

*Bandedecodeurs:*
https://www.youtube.com/watch?v=ES4BcZcsBdUdocker stop 

*Informatique Sans complexe (nextcloud)*
https://www.youtube.com/watch?v=MfxKDC3RR-U

https://blog.stephane-robert.info/docs/conteneurs/orchestrateurs/docker-compose/

https://blog.myagilepartner.fr/index.php/2017/01/12/tutoriel-docker-francais/

## Commandes

[CTRL ALT T] pour ouvrir un terminal
```
sudo apt-get install docker.io
(selon version)

sudo docker run hello-world

docker ps

sudo docker pull redis

sudo docker images

sudo dokcer run redis

docker network ls

AUTRE TERMINAL
docker ps

docker ps -a
pour toutes les images
````
Le tag est la version, latest si non précisé.

## Tech with Nana
Pour lancer en tache de fond:

*sudo docker run -d nginx:1.23* 

pour voir les logs du container 5f...

*sudo docker logs 5f* 

```
cedrik@cedrik-virtual-machine:~$ sudo docker run -d nginx:1.23
5fec02e308d1-64 caractères au total-

cedrik@cedrik-virtual-machine:~$ docker ps
CONTAINER ID   IMAGE        COMMAND                  CREATED              STATUS              PORTS     NAMES
5fec02e308d1   nginx:1.23   "/docker-entrypoint.…"   About a minute ago   Up About a minute   80/tcp    distracted_archimedes

cedrik@cedrik-virtual-machine:~$ sudo docker logs 5f
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
````
Pour reporter le port de l'application vers le port de la machine:

*docker run -p port_dest:port_source*

et stopper:

*sudo docker stop 66 gallant_carver*
```
cedrik@cedrik-virtual-machine:~$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

cedrik@cedrik-virtual-machine:~$ docker run -d -p 9000:80 nginx:1.23
dc87bdeadb2c-64 caractères au total-

cedrik@cedrik-virtual-machine:~$ docker ps

CONTAINER ID   IMAGE        COMMAND                  CREATED         STATUS         PORTS                                   NAMES
dc87bdeadb2c   nginx:1.23   "/docker-entrypoint.…"   7 seconds ago   Up 6 seconds   0.0.0.0:9000->80/tcp, :::9000->80/tcp   frosty_ramanujan

cedrik@cedrik-virtual-machine:~$ sudo docker logs dc

172.17.0.1 - - [23/Dec/2024:21:58:32 +0000] "GET / HTTP/1.1" 200 615 "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:133.0) Gecko/20100101 Firefox/133.0" "-"
172.17.0.1 - - [23/Dec/2024:21:58:32 +0000] "GET /favicon.ico HTTP/1.1" 404 153 "http://localhost:9000/" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:133.0) Gecko/20100101 Firefox/133.0" "-"
2024/12/23 21:58:32 [error] 32#32: \*4 open() "/usr/share/nginx/html/favicon.ico" failed (2: No such file or directory), client: 172.17.0.1, server: localhost, request: "GET /favicon.ico HTTP/1.1", host: "localhost:9000", referrer: "http://localhost:9000/"

cedrik@cedrik-virtual-machine:~$ sudo docker stop dc
dc
````
```

cedrik@cedrik-virtual-machine:~$ sudo docker start 75
75

cedrik@cedrik-virtual-machine:~$ sudo docker start 66
66

cedrik@cedrik-virtual-machine:~$ docker ps

CONTAINER ID   IMAGE               COMMAND                  CREATED          STATUS          PORTS      NAMES
6681d6af26ca   nginx:1.22-alpine   "/docker-entrypoint.…"   20 minutes ago   Up 19 seconds   80/tcp     gallant_carver
752ac0786947   redis               "docker-entrypoint.s…"   45 minutes ago   Up 26 seconds   6379/tcp   flamboyant_pare

cedrik@cedrik-virtual-machine:~$ sudo docker stop 66 gallant_carver
66
gallant_carver
````
Pour nommer un container:

*docker run --name pouet -d -p 9000:80 nginx:1.23*
```
cedrik@cedrik-virtual-machine:~$ docker run --name pouet -d -p 9000:80 nginx:1.23
cc4bd387147b-64 caractères au total- 

cedrik@cedrik-virtual-machine:~$ docker ps
CONTAINER ID   IMAGE        COMMAND                  CREATED              STATUS              PORTS                                   NAMES
cc4bd387147b   nginx:1.23   "/docker-entrypoint.…"   About a minute ago   Up About a minute   0.0.0.0:9000->80/tcp, :::9000->80/tcp   pouet
752ac0786947   redis        "docker-entrypoint.s…"   48 minutes ago       Up 3 minutes        6379/tcp                                flamboyant_pare

cedrik@cedrik-virtual-machine:~$ sudo docker logs pouet
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
````
**Docker Hub is a registry**
**Docker Hub can host multiple repositories for your applications**

Dockerfile sert à fabriquer une image qui sert à construire des containers

## Informatique sans complexes

### Playlist: Docker

#### Lancer son premier container sur Docker !
```
C:\Users\access\Documents\autoform_pratik\autoform_isc>docker run -p 80:80 httpd
Unable to find image 'httpd:latest' locally
latest: Pulling from library/httpd
d7382fd3e491: Download complete
````
**Sur navigateur**
```
http://localhost:80

It works!
````
**Sur autre terminal**
```
C:\Users\access>docker ps -a
CONTAINER ID   IMAGE                                                 COMMAND                  CREATED         STATUS                    PORTS                NAMES
a73f667837bd   httpd                                                 "httpd-foreground"       4 minutes ago   Up 4 minutes              0.0.0.0:80->80/tcp   ecstatic_dhawan
a74f975eb221   docker.elastic.co/logstash/logstash:8.8.2             "/usr/local/bin/dock…"   9 days ago      Exited (0) 9 days ago                          dokr-logstash-1
20cd038e6c50   docker.elastic.co/kibana/kibana:8.8.2                 "/bin/tini -- /usr/l…"   9 days ago      Exited (0) 9 days ago                          dokr-kibana-1
97a1022c2983   docker.elastic.co/elasticsearch/elasticsearch:8.8.2   "/bin/tini -- /usr/l…"   9 days ago      Exited (143) 9 days ago                        dokr-elasticsearch-1
C:\Users\access>docker stop a73
a73
````
Pour supprimer un container arrêté
```
C:\Users\access>docker rm a73
a73

C:\Users\access>docker ps -a
CONTAINER ID   IMAGE                                                 COMMAND                  CREATED      STATUS                    PORTS     NAMES
a74f975eb221   docker.elastic.co/logstash/logstash:8.8.2             "/usr/local/bin/dock…"   9 days ago   Exited (0) 9 days ago               dokr-logstash-1
20cd038e6c50   docker.elastic.co/kibana/kibana:8.8.2                 "/bin/tini -- /usr/l…"   9 days ago   Exited (0) 9 days ago               dokr-kibana-1
97a1022c2983   docker.elastic.co/elasticsearch/elasticsearch:8.8.2   "/bin/tini -- /usr/l…"   9 days ago   Exited (143) 9 days ago             dokr-elasticsearch-1

````
#### Docker - Utiliser efficacement un container

Prendre infos sur site Docker Hub pour lier le volume du container au volume de l'hôte (similaire aux ports)
```
C:\Users\access\Documents\autoform_pratik\autoform_isc>mkdir htdocs

C:\Users\access\Documents\autoform_pratik\autoform_isc>dir
 Le volume dans le lecteur C s’appelle Win10pro
 Le numéro de série du volume est A0B1-0043

 Répertoire de C:\Users\access\Documents\autoform_pratik\autoform_isc

26/12/2024  17:42    <DIR>          .
26/12/2024  17:42    <DIR>          ..
25/12/2024  23:34               648 docker-compose.yml
26/12/2024  17:42    <DIR>          htdocs
               1 fichier(s)              648 octets
               3 Rép(s)  119 065 288 704 octets libres

C:\Users\access\Documents\autoform_pratik\autoform_isc>docker run -p 80:80 -v C:\Users\access\Documents\autoform_pratik\autoform_isc\htdocs:/usr/local/apache2/htdocs httpd
AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 172.17.0.2. Set the 'ServerName' directive globally to suppress this message
AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 172.17.0.2. Set the 'ServerName' directive globally to suppress this message
[Thu Dec 26 16:56:48.359233 2024] [mpm_event:notice] [pid 1:tid 1] AH00489: Apache/2.4.62 (Unix) configured -- resuming normal operations
[Thu Dec 26 16:56:48.359349 2024] [core:notice] [pid 1:tid 1] AH00094: Command line: 'httpd -D FOREGROUND'

```
En ouvrant à nouveau le navigateur:
```
http://localhost:80

Index of/
````
EN créant un fichier index.html
```
C:\Users\access\Documents\autoform_pratik\autoform_isc>cd htdocs

C:\Users\access\Documents\autoform_pratik\autoform_isc\htdocs>echo "Salut les moutons!" > index.html

C:\Users\access\Documents\autoform_pratik\autoform_isc\htdocs>more index.html
"Salut les moutons!"
````
Le navigateur affiche:
```
http://localhost:80

"Salut les moutons!"
````

*Avec Dockerfile, selon Docker-hub*
```
FROM httpd:2.4
COPY ./public-html/ /usr/local/apache2/htdocs/

$ docker build -t my-apache2 .
$ docker run -dit --name my-running-app -p 8080:80 my-apache2

````
#### Docker-compose, c'est quoi ?

```
C:\Users\access>docker compose

Usage:  docker compose [OPTIONS] COMMAND

Define and run multi-container applications with Docker

Options:
      --all-resources              Include all resources, even those not
                                   used by services
      --ansi string                Control when to print ANSI control
                                   characters ("never"|"always"|"auto")
                                   (default "auto")
      --compatibility              Run compose in backward compatibility mode
      --dry-run                    Execute command in dry run mode
      --env-file stringArray       Specify an alternate environment file
........
````
docker-compose.yml, copié de docker hub
```
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
Pratique
```
C:\Users\access\Documents\autoform_pratik\autoform_isc>docker-compose up -d

[+] Running 32/2
 ✔ app Pulled                                                                                                     19.6s
 ✔ db Pulled                                                                                                      10.7s
[+] Running 5/5
 ✔ Network autoform_isc_default     Created                                                                        0.0s
 ✔ Volume "autoform_isc_nextcloud"  Created                                                                        0.0s
 ✔ Volume "autoform_isc_db"         Created                                                                        0.0s
 ✔ Container autoform_isc-db-1      Started                                                                        2.9s
 ✔ Container autoform_isc-app-1     Started                                                                        1.0s

C:\Users\access\Documents\autoform_pratik\autoform_isc>docker-compose logs -f
app-1  | => Searching for scripts (*.sh) to run, located in the folder: /docker-entrypoint-hooks.d/before-starting
````
Vérification depuis autre terminal
```
C:\Users\access\Documents\autoform_pratik\autoform_isc>docker ps

CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS                         PORTS                  NAMES
427b92eaf2f0   nextcloud      "/entrypoint.sh apac…"   3 minutes ago   Up 3 minutes                   0.0.0.0:8080->80/tcp   autoform_isc-app-1
ca869b164b7e   mariadb:10.6   "docker-entrypoint.s…"   3 minutes ago   Restarting (1) 8 seconds ago                          autoform_isc-db-1
````
Vérifier l'accès à nextcloud depuis navigateur:

```
http://localhost:8080
````
Pour arrêter docker compose:
```
C:\Users\access\Documents\autoform_pratik\autoform_isc>docker-compose down

[+] Running 3/3
 ✔ Container autoform_isc-app-1  Removed                                                                                                                    1.4s
 ✔ Container autoform_isc-db-1   Removed                                                                                                                    0.0s
 ✔ Network autoform_isc_default  Removed                                                                                                                    0.3s
````
#### Créer une image Docker

Après création des fichiers *Dockerfile, index.html*
```
C:\Users\access\Documents\autoform_pratik\autoform_isc>more index.html
<html>
        <head>
                <title>Coucou les moutons</title>
        </head>
        <body>
                <h1>L'herbe est bonne?</h1>
                <p>dans le container?</p>
        </body>
</html>

C:\Users\access\Documents\autoform_pratik\autoform_isc>more Dockerfile
FROM ubuntu
RUN apt update && apt upgrade -y
RUN apt-get install -y apache2
ENTRYPOINT /usr/sbin/apache2ctl -D FOREGROUND
RUN mv /var/www/html/index.html /var/www/html/index.html.old
COPY index.html /var/www/html/index.html
````

Fabrication de l'image

````
C:\Users\access\Documents\autoform_pratik\autoform_isc>docker build -t fabrication .
[+] Building 22.1s (11/11) FINISHED                                                                                                         docker:desktop-linux
 => [internal] load build definition from Dockerfile                                                                                                        0.0s
 => => transferring dockerfile: 267B                                                                                                                        0.0s
 => [internal] load metadata for docker.io/library/ubuntu:latest                                                                                            1.3s
 => [auth] library/ubuntu:pull token for registry-1.docker.io                                                                                               0.0s
 => [internal] load .dockerignore                                                                                                                           0.0s
 => => transferring context: 2B                                                                                                                             0.0s
 => [1/5] FROM docker.io/library/ubuntu:latest@sha256:80dd3c3b9c6cecb9f1667e9290b3bc61b78c2678c02cbdae5f0fea92cc6734ab                                      1.8s
 => => resolve docker.io/library/ubuntu:latest@sha256:80dd3c3b9c6cecb9f1667e9290b3bc61b78c2678c02cbdae5f0fea92cc6734ab                                      0.0s
 => => sha256:de44b265507ae44b212defcb50694d666f136b35c1090d9709068bc861bb2d64 29.75MB / 29.75MB                                                            1.0s
 => => extracting sha256:de44b265507ae44b212defcb50694d666f136b35c1090d9709068bc861bb2d64                                                                   0.8s
 => [internal] load build context                                                                                                                           0.0s
 => => transferring context: 189B                                                                                                                           0.0s
 => [2/5] RUN apt update && apt upgrade -y                                                                                                                  4.8s
 => [3/5] RUN apt-get install -y apache2                                                                                                                    8.5s
 => [4/5] RUN mv /var/www/html/index.html /var/www/html/index.html.old                                                                                      0.4s
 => [5/5] COPY index.html /var/www/html/index.html                                                                                                          0.0s
 => exporting to image                                                                                                                                      5.1s
 => => exporting layers                                                                                                                                     3.9s
 => => exporting manifest sha256:070491f6030f94346d67dbdd49370108737dd96f90d3a9eda9cc2ced47684c5e                                                           0.0s
 => => exporting config sha256:ad9587bea0c3912ca57494b5590eb5a1d8d8b75160dc5788a909a7803f78699b                                                             0.0s
 => => exporting attestation manifest sha256:89f0926fc7f8826e8cce4382e325f9e391ace624af73a502d90128827e19477e                                               0.0s
 => => exporting manifest list sha256:1a0b162d152770380b2aa728c114c9a0e799c0960e8cd90c087b4798c8b42a19                                                      0.0s
 => => naming to docker.io/library/fabrication:latest                                                                                                       0.0s
 => => unpacking to docker.io/library/fabrication:latest                                                                                                    1.1s

View build details: docker-desktop://dashboard/build/desktop-linux/desktop-linux/z3i7v08ty715a8wzu9srry3t4

 1 warning found (use docker --debug to expand):
 - JSONArgsRecommended: JSON arguments recommended for ENTRYPOINT to prevent unintended behavior related to OS signals (line 4)
 ````

Lancement du container depuis l'image *fabrication*:

**docker run -p 9000:80 fabrication**

````
C:\Users\access\Documents\autoform_pratik\autoform_isc>docker images
REPOSITORY                                      TAG       IMAGE ID       CREATED              SIZE
fabrication                                     latest    1a0b162d1527   About a minute ago   345MB
nextcloud                                       latest    df061144b4e7   2 weeks ago          1.82GB
mariadb                                         10.6      0ba11696aa4b   7 weeks ago          539MB
httpd                                           latest    72f6e2460071   5 months ago         220MB
portnavigator/port-navigator                    1.1.0     1c3b1d792e15   14 months ago        235MB
docker.elastic.co/kibana/kibana                 8.8.2     f7d62957d7a8   18 months ago        1.49GB
docker.elastic.co/elasticsearch/elasticsearch   8.8.2     ec03cfb360d7   18 months ago        2.06GB
docker.elastic.co/logstash/logstash             8.8.2     d5bebfec7734   18 months ago        1.28GB

C:\Users\access\Documents\autoform_pratik\autoform_isc>docker run -p 9000:80 fabrication
AH00558: apache2: Could not reliably determine the server's fully qualified domain name, using 172.17.0.2. Set the 'ServerName' directive globally to suppress this message
````
Depuis un autre terminal:
````
C:\Users\access>docker ps -a
CONTAINER ID   IMAGE                                                 COMMAND                  CREATED              STATUS                      PORTS                  NAMES
76a05608e6ed   fabrication                                           "/bin/sh -c '/usr/sb…"   About a minute ago   Up About a minute           0.0.0.0:9000->80/tcp   stoic_spence
cf8d09024ea1   nextcloud                                             "/entrypoint.sh apac…"   28 minutes ago       Exited (0) 14 minutes ago                          autoform_isc-app-1
2c63e40d40cc   mariadb:10.6                                          "docker-entrypoint.s…"   28 minutes ago       Exited (1) 14 minutes ago                          autoform_isc-db-1
````
Vérifier l'accès depuis navigateur:
```
http://localhost:9000

L'herbe est bonne ?
dans le container?
````
#### Gérer efficacement Docker® via une interface Web ! LINUX UNIQUEMENT

Trouver Dockge dans le docker-hub et copier la lgne adaptée à votre environnement