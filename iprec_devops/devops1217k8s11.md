devops1217_11.txt
docker - minikube - 1 -

================= INSTALLATIONS SUR VM

sudo apt install docker.io

sudo apt install docker-compose

?????????????????
docker system prune --all --force
?????????????????

# Installation de curl
sudo apt install curl

# télécharger minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64

# Installation de minikube
sudo install minikube-linux-amd64 /usr/local/bin/minikube

==============================================

access@DESKTOP-4E2R2LH MINGW64 ~
$ cd Desktop/

access@DESKTOP-4E2R2LH MINGW64 ~/Desktop
$ ls
'Docker Desktop.lnk'*  'Nouveau dossier'/   cedret2/   desktop.ini

access@DESKTOP-4E2R2LH MINGW64 ~/Desktop
$ cd cedret2

access@DESKTOP-4E2R2LH MINGW64 ~/Desktop/cedret2 (main)
$ mkdir lamp_app

access@DESKTOP-4E2R2LH MINGW64 ~/Desktop/cedret2 (main)
$ cd lamp_app

access@DESKTOP-4E2R2LH MINGW64 ~/Desktop/cedret2/lamp_app (main)
$ touch index.html

access@DESKTOP-4E2R2LH MINGW64 ~/Desktop/cedret2/lamp_app (main)
$ cd ..

access@DESKTOP-4E2R2LH MINGW64 ~/Desktop/cedret2 (main)
$ mkdir build

access@DESKTOP-4E2R2LH MINGW64 ~/Desktop/cedret2 (main)
$ cd build

access@DESKTOP-4E2R2LH MINGW64 ~/Desktop/cedret2/build (main)
$ ls

access@DESKTOP-4E2R2LH MINGW64 ~/Desktop/cedret2/build (main)
$ mkdir mysql

access@DESKTOP-4E2R2LH MINGW64 ~/Desktop/cedret2/build (main)
$ cd mysql

access@DESKTOP-4E2R2LH MINGW64 ~/Desktop/cedret2/build/mysql (main)
$ touch dockerfile

access@DESKTOP-4E2R2LH MINGW64 ~/Desktop/cedret2/build/mysql (main)
$ cd ..

access@DESKTOP-4E2R2LH MINGW64 ~/Desktop/cedret2/build (main)
$ mkdir php

access@DESKTOP-4E2R2LH MINGW64 ~/Desktop/cedret2/build (main)
$ cd php

access@DESKTOP-4E2R2LH MINGW64 ~/Desktop/cedret2/build/php (main)
$ touche dockerfile
bash: touche: command not found

access@DESKTOP-4E2R2LH MINGW64 ~/Desktop/cedret2/build/php (main)
$ cd ..

access@DESKTOP-4E2R2LH MINGW64 ~/Desktop/cedret2/build (main)
$ touch docker-compose.yml

access@DESKTOP-4E2R2LH MINGW64 ~/Desktop/cedret2/build (main)
$

==================== VM UBUNTU

docker system prune --all --force

===================== VM UBUNTU   EN SUDO!!!!!!

cedrik@cedrik-virtual-machine:~/lamp_app/build$ vim docker-compose.yml 
cedrik@cedrik-virtual-machine:~/lamp_app/build$ pwd
/home/cedrik/lamp_app/build
cedrik@cedrik-virtual-machine:~/lamp_app/build$ vim docker-compose.yml 
cedrik@cedrik-virtual-machine:~/lamp_app/build$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: ens33: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 00:0c:29:c4:ed:22 brd ff:ff:ff:ff:ff:ff
    altname enp2s1
    inet 192.168.83.129/24 brd 192.168.83.255 scope global dynamic noprefixroute ens33
       valid_lft 1688sec preferred_lft 1688sec
3: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default 
    link/ether 02:42:31:53:cf:44 brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.1/16 brd 172.17.255.255 scope global docker0
       valid_lft forever preferred_lft forever
cedrik@cedrik-virtual-machine:~/lamp_app/build$ vim docker-compose.yml 
cedrik@cedrik-virtual-machine:~/lamp_app/build$ docker-compose up
La commande « docker-compose » n'a pas été trouvée, mais peut être installée avec :
sudo snap install docker          # version 27.2.0, or
sudo apt  install docker-compose  # version 1.29.2-1
Voir « snap info docker » pour des versions additionelles.
cedrik@cedrik-virtual-machine:~/lamp_app/build$ sudo apt install docker-compose


cedrik@cedrik-virtual-machine:~/lamp_app/build$ vim docker-compose.yml 
cedrik@cedrik-virtual-machine:~/lamp_app/build$ sudo docker-compose up


cedrik@cedrik-virtual-machine:~/lamp_app$ tree
.
├── app
│   ├── contact.html
│   ├── destinations.html
│   ├── index.html
│   └── reservation.html
└── build
    ├── docker-compose.yml
    ├── mysql
    │   └── dockerfile
    └── php
        └── dockerfile

4 directories, 7 files

===================== CURL - KUBERNETES

# Installation de curl
sudo apt install curl

# télécharger minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64

# Installation de minikube
sudo install minikube-linux-amd64 /usr/local/bin/minikube

# Lancer minikube
minikube start

# lancer le dashbord de minikube
minikube dashboard --url=true

=============   Les étapes en détails :

sudo usermod -aG docker  $cedrik
newgrp docker

============== ou
sudo usermod -aG docker  $USER

Téléchargement :
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64

---------- Installation
sudo install minikube-linux-amd64 /usr/local/bin/minikube

---------Lancement du cluster minikube :
minikube start

---------si problème
minikube delete

--------Spécifier le Driver :
minikube start --driver=docker

--------Lancer le dashboard de minikube :
minikube dashboard --url=true

--------On a besoin kubectl pour pouvoir interagir avec kubernetes
Dans une nouvelle console on télécharge kubectl.
Téléchargement de kubectl:
curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.21.0/bin/linux/amd64/kubectl

Droit d'exécution :
chmod +x ./kubectl

Déplacement dans bin :
sudo mv ./kubectl /usr/local/bin/kubectl

kubectl version --client

Permettre d'accéder au dashboard depuis votre machine locale :
kubectl proxy --address='0.0.0.0' --disable-filter=true

=========
    1  df -h
    2  sudo apt install docker.io
    3  docker --version
    4  mk mon_image
    5  mkdir mon_image
    6  cd mon_image/
    7  nano dockerfile
    8  nano server.py
    9  nano dockerfile
   10  sudo docker container ls
   11  sudo docker image build . -t mon_image:latest
   12  docker container run -p 5000:5000 -d mon_image:latest
   13  sudo docker container run -p 5000:5000 -d mon_image:latest
   14  IP A
   15  ip a
   16  ping 192.168.1.1
   17  minkube delete
   18  minikube delete
   19  history 
   18  minikube start

minikube dashboard --url=true
Copier lien obtenu


http://127.0.0.1:44827/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/#/workloads?namespace=default
CTRL C
cedrik@cedrik-virtual-machine:~/kubernetes$ minikube stop
✋  Nœud d'arrêt "minikube" ...
🛑  Mise hors tension du profil "minikube" via SSH…
🛑  1 nœud arrêté.


========== SOLUTION ALI SUR PORT 8001 DEDIE Kubernetes

http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/#/workloads?namespace=default


================= DEPUIS Kuber
postgres:latest
