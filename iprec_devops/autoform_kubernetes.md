#### Kubernetes



## Commandes principales



## Tech with Nana

sudo docker run -d nginx:1.23
pour lancer en tache de fond

cedrik@cedrik-virtual-machine:~$ sudo docker run -d nginx:1.23
5fec02e308d1314322c1d542a91c9514aad09ada0aa12dc9837bc77e70f9c0ab

cedrik@cedrik-virtual-machine:~$ docker ps
CONTAINER ID   IMAGE        COMMAND                  CREATED              STATUS              PORTS     NAMES
5fec02e308d1   nginx:1.23   "/docker-entrypoint.…"   About a minute ago   Up About a minute   80/tcp    distracted_archimedes

cedrik@cedrik-virtual-machine:~$ sudo docker logs 5f
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/

Pour reporter le port de l'application vers le port de la machine: docker run -p port_dest:port_source

cedrik@cedrik-virtual-machine:~$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

cedrik@cedrik-virtual-machine:~$ docker run -d -p 9000:80 nginx:1.23
dc87bdeadb2cf44b2ce8bf9fb41f802060ee09866add2275c9fcc577b17c9450

cedrik@cedrik-virtual-machine:~$ docker ps
````
CONTAINER ID   IMAGE        COMMAND                  CREATED         STATUS         PORTS                                   NAMES
dc87bdeadb2c   nginx:1.23   "/docker-entrypoint.…"   7 seconds ago   Up 6 seconds   0.0.0.0:9000->80/tcp, :::9000->80/tcp   frosty_ramanujan
````
cedrik@cedrik-virtual-machine:~$ sudo docker logs dc
```
172.17.0.1 - - [23/Dec/2024:21:58:32 +0000] "GET / HTTP/1.1" 200 615 "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:133.0) Gecko/20100101 Firefox/133.0" "-"
172.17.0.1 - - [23/Dec/2024:21:58:32 +0000] "GET /favicon.ico HTTP/1.1" 404 153 "http://localhost:9000/" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:133.0) Gecko/20100101 Firefox/133.0" "-"
2024/12/23 21:58:32 [error] 32#32: \*4 open() "/usr/share/nginx/html/favicon.ico" failed (2: No such file or directory), client: 172.17.0.1, server: localhost, request: "GET /favicon.ico HTTP/1.1", host: "localhost:9000", referrer: "http://localhost:9000/"
````
cedrik@cedrik-virtual-machine:~$ sudo docker stop dc
dc

cedrik@cedrik-virtual-machine:~$ docker ps

cedrik@cedrik-virtual-machine:~$ sudo docker start 75
75

cedrik@cedrik-virtual-machine:~$ sudo docker start 66
66

cedrik@cedrik-virtual-machine:~$ docker ps
````
CONTAINER ID   IMAGE               COMMAND                  CREATED          STATUS          PORTS      NAMES
6681d6af26ca   nginx:1.22-alpine   "/docker-entrypoint.…"   20 minutes ago   Up 19 seconds   80/tcp     gallant_carver
752ac0786947   redis               "docker-entrypoint.s…"   45 minutes ago   Up 26 seconds   6379/tcp   flamboyant_pare
````
cedrik@cedrik-virtual-machine:~$ sudo docker stop 66 gallant_carver
66
gallant_carver

cedrik@cedrik-virtual-machine:~$ docker run --name pouet -d -p 9000:80 nginx:1.23
cc4bd387147b0169dc5e5f3bdf9ffbe6ab06b61c8fc014b7d6b9312f75233a4a

cedrik@cedrik-virtual-machine:~$ docker ps
CONTAINER ID   IMAGE        COMMAND                  CREATED          STATUS         PORTS                                   NAMES
cc4bd387147b   nginx:1.23   "/docker-entrypoint.…"   6 seconds ago    Up 5 seconds   0.0.0.0:9000->80/tcp, :::9000->80/tcp   pouet
752ac0786947   redis        "docker-entrypoint.s…"   47 minutes ago   Up 2 minutes   6379/tcp  

cedrik@cedrik-virtual-machine:~$ docker ps
CONTAINER ID   IMAGE        COMMAND                  CREATED              STATUS              PORTS                                   NAMES
cc4bd387147b   nginx:1.23   "/docker-entrypoint.…"   About a minute ago   Up About a minute   0.0.0.0:9000->80/tcp, :::9000->80/tcp   pouet
752ac0786947   redis        "docker-entrypoint.s…"   48 minutes ago       Up 3 minutes        6379/tcp                                flamboyant_pare

cedrik@cedrik-virtual-machine:~$ sudo docker logs pouet
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/

**Docker Hub is a registry**
**Docker Hub can host multiple repositories for your applications**

Dockerfile sert à fabriquer une imge qui sert à construire des containers

## Informatique sans complexes

#### docker-compose.yml (copie de docker hub)
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
#### Pratique
C:\Users\access\Documents\autoform_pratik\autoform_isc>docker-compose up -d
```
[+] Running 32/2
 ✔ app Pulled                                                                                                     19.6s
 ✔ db Pulled                                                                                                      10.7s
[+] Running 5/5
 ✔ Network autoform_isc_default     Created                                                                        0.0s
 ✔ Volume "autoform_isc_nextcloud"  Created                                                                        0.0s
 ✔ Volume "autoform_isc_db"         Created                                                                        0.0s
 ✔ Container autoform_isc-db-1      Started                                                                        2.9s
 ✔ Container autoform_isc-app-1     Started                                                                        1.0s
````
C:\Users\access\Documents\autoform_pratik\autoform_isc>docker-compose logs -f

C:\Users\access\Documents\autoform_pratik\autoform_isc>docker ps
```
CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS                         PORTS                  NAMES
427b92eaf2f0   nextcloud      "/entrypoint.sh apac…"   3 minutes ago   Up 3 minutes                   0.0.0.0:8080->80/tcp   autoform_isc-app-1
ca869b164b7e   mariadb:10.6   "docker-entrypoint.s…"   3 minutes ago   Restarting (1) 8 seconds ago                          autoform_isc-db-1
````
C:\Users\access\Documents\autoform_pratik\autoform_isc>docker-compose down
```
[+] Running 3/3
 ✔ Container autoform_isc-app-1  Removed                                                                                                                    1.4s
 ✔ Container autoform_isc-db-1   Removed                                                                                                                    0.0s
 ✔ Network autoform_isc_default  Removed                                                                                                                    0.3s
````
C:\Users\access\Documents\autoform_pratik\autoform_isc>
