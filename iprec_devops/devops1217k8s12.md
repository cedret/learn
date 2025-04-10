devops1217_12.txt

minikube

cedrik@cedrik-virtual-machine:~/lamp_app/app$ touch contact.html
cedrik@cedrik-virtual-machine:~/lamp_app/app$ vim contact.html 
cedrik@cedrik-virtual-machine:~/lamp_app/app$ touch destinations.html
cedrik@cedrik-virtual-machine:~/lamp_app/app$ vim destinations.html 
cedrik@cedrik-virtual-machine:~/lamp_app/app$ touch reservation.html
cedrik@cedrik-virtual-machine:~/lamp_app/app$ vim reservation.html 
cedrik@cedrik-virtual-machine:~/lamp_app/app$ cd ..
cedrik@cedrik-virtual-machine:~/lamp_app$ ls
app  build
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
cedrik@cedrik-virtual-machine:~/lamp_app$ ^C
cedrik@cedrik-virtual-machine:~/lamp_app$ cd ..
cedrik@cedrik-virtual-machine:~$ # Installation de curl
sudo apt install curl

# télécharger minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64

# Installation de minikube
sudo install minikube-linux-amd64 /usr/local/bin/minikube^C

cedrik@cedrik-virtual-machine:~$ sudo apt install curl
[sudo] Mot de passe de cedrik : 
Lecture des listes de paquets... Fait
Construction de l'arbre des dépendances... Fait
Lecture des informations d'état... Fait      
Les paquets suivants ont été installés automatiquement et ne sont plus nécessaires :
  libwpe-1.0-1 libwpebackend-fdo-1.0-1
Veuillez utiliser « sudo apt autoremove » pour les supprimer.
Les NOUVEAUX paquets suivants seront installés :
  curl
0 mis à jour, 1 nouvellement installés, 0 à enlever et 0 non mis à jour.
Il est nécessaire de prendre 194 ko dans les archives.
Après cette opération, 455 ko d'espace disque supplémentaires seront utilisés.
Réception de :1 http://fr.archive.ubuntu.com/ubuntu jammy-updates/main amd64 curl amd64 7.81.0-1ubuntu1.19 [194 kB]
194 ko réceptionnés en 0s (1 767 ko/s)
Sélection du paquet curl précédemment désélectionné.
(Lecture de la base de données... 210641 fichiers et répertoires déjà installés.)
Préparation du dépaquetage de .../curl_7.81.0-1ubuntu1.19_amd64.deb ...
Dépaquetage de curl (7.81.0-1ubuntu1.19) ...
Paramétrage de curl (7.81.0-1ubuntu1.19) ...
Traitement des actions différées (« triggers ») pour man-db (2.10.2-1) ...

cedrik@cedrik-virtual-machine:~$ curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 99.0M  100 99.0M    0     0  30.6M      0  0:00:03  0:00:03 --:--:-- 30.6M

cedrik@cedrik-virtual-machine:~$ sudo install minikube-linux-amd64 /usr/local/bin/minikube

cedrik@cedrik-virtual-machine:~$ minikube start
😄  minikube v1.34.0 sur Ubuntu 22.04
👎  Impossible de choisir un pilote par défaut. Voici ce qui a été considéré, par ordre de préférence :
    ▪ docker : Not healthy: "docker version --format {{.Server.Os}}-{{.Server.Version}}:{{.Server.Platform.Name}}" exit status 1: permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Get "http://%2Fvar%2Frun%2Fdocker.sock/v1.24/version": dial unix /var/run/docker.sock: connect: permission denied
    ▪ docker: Suggestion: Add your user to the 'docker' group: 'sudo usermod -aG docker $USER && newgrp docker' <https://docs.docker.com/engine/install/linux-postinstall/>
💡  Vous pouvez également installer l'un de ces pilotes :
    ▪ kvm2 : Not installed: exec: "virsh": executable file not found in $PATH
    ▪ qemu2 : Not installed: exec: "qemu-system-x86_64": executable file not found in $PATH
    ▪ podman : Not installed: exec: "podman": executable file not found in $PATH
    ▪ virtualbox : Not installed: unable to find VBoxManage in $PATH

❌  Fermeture en raison de DRV_NOT_HEALTHY : Pilote(s) trouvé(s) mais aucun n'était en fonctionnement. Voir ci-dessus pour des suggestions sur la façon de réparer les pilotes installés.

cedrik@cedrik-virtual-machine:~$ minikube start --driver=docker
😄  minikube v1.34.0 sur Ubuntu 22.04
✨  Utilisation du pilote docker basé sur la configuration de l'utilisateur

💣  Fermeture en raison de PROVIDER_DOCKER_NEWGRP : "docker version --format <no value>-<no value>:<no value>" exit status 1: permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Get "http://%2Fvar%2Frun%2Fdocker.sock/v1.24/version": dial unix /var/run/docker.sock: connect: permission denied
💡  Suggestion : Add your user to the 'docker' group: 'sudo usermod -aG docker $USER && newgrp docker'
📘  Documentation: https://docs.docker.com/engine/install/linux-postinstall/

cedrik@cedrik-virtual-machine:~$ minikub delete
minikub : commande introuvable
cedrik@cedrik-virtual-machine:~$ minikube delete
🙄  Le profil "minikube" n'existe pas, tentative de suppression quand même.
💀  Le cluster "minikube" a été supprimé.
cedrik@cedrik-virtual-machine:~$ minikube start --driver=docker
😄  minikube v1.34.0 sur Ubuntu 22.04
✨  Utilisation du pilote docker basé sur la configuration de l'utilisateur

💣  Fermeture en raison de PROVIDER_DOCKER_NEWGRP : "docker version --format <no value>-<no value>:<no value>" exit status 1: permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Get "http://%2Fvar%2Frun%2Fdocker.sock/v1.24/version": dial unix /var/run/docker.sock: connect: permission denied
💡  Suggestion : Add your user to the 'docker' group: 'sudo usermod -aG docker $USER && newgrp docker'
📘  Documentation: https://docs.docker.com/engine/install/linux-postinstall/

cedrik@cedrik-virtual-machine:~$ minikube dashboard --url=true
🤷  Profil "minikube" introuvable. Exécutez "minikube profile list" pour afficher tous les profils.
👉  Pour démarrer un cluster, exécutez : "minikube start"
cedrik@cedrik-virtual-machine:~$ minikube profile list

🤹  Fermeture en raison de MK_USAGE_NO_PROFILE : Aucun profil minikube n’a été trouvé.
💡  Suggestion : 

    Vous pouvez en créer un en utilisant 'minikube start'.
    
cedrik@cedrik-virtual-machine:~$ minikube start
😄  minikube v1.34.0 sur Ubuntu 22.04
👎  Impossible de choisir un pilote par défaut. Voici ce qui a été considéré, par ordre de préférence :
    ▪ docker : Not healthy: "docker version --format {{.Server.Os}}-{{.Server.Version}}:{{.Server.Platform.Name}}" exit status 1: permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Get "http://%2Fvar%2Frun%2Fdocker.sock/v1.24/version": dial unix /var/run/docker.sock: connect: permission denied
    ▪ docker: Suggestion: Add your user to the 'docker' group: 'sudo usermod -aG docker $USER && newgrp docker' <https://docs.docker.com/engine/install/linux-postinstall/>
💡  Vous pouvez également installer l'un de ces pilotes :
    ▪ kvm2 : Not installed: exec: "virsh": executable file not found in $PATH
    ▪ qemu2 : Not installed: exec: "qemu-system-x86_64": executable file not found in $PATH
    ▪ podman : Not installed: exec: "podman": executable file not found in $PATH
    ▪ virtualbox : Not installed: unable to find VBoxManage in $PATH

❌  Fermeture en raison de DRV_NOT_HEALTHY : Pilote(s) trouvé(s) mais aucun n'était en fonctionnement. Voir ci-dessus pour des suggestions sur la façon de réparer les pilotes installés.

cedrik@cedrik-virtual-machine:~$ minikube start --driver=docker
😄  minikube v1.34.0 sur Ubuntu 22.04
✨  Utilisation du pilote docker basé sur la configuration de l'utilisateur

💣  Fermeture en raison de PROVIDER_DOCKER_NEWGRP : "docker version --format <no value>-<no value>:<no value>" exit status 1: permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Get "http://%2Fvar%2Frun%2Fdocker.sock/v1.24/version": dial unix /var/run/docker.sock: connect: permission denied
💡  Suggestion : Add your user to the 'docker' group: 'sudo usermod -aG docker $USER && newgrp docker'
📘  Documentation: https://docs.docker.com/engine/install/linux-postinstall/

cedrik@cedrik-virtual-machine:~$ minikube dashboard --url=true
🤷  Profil "minikube" introuvable. Exécutez "minikube profile list" pour afficher tous les profils.
👉  Pour démarrer un cluster, exécutez : "minikube start"
cedrik@cedrik-virtual-machine:~$ minikube start --driver=docker
😄  minikube v1.34.0 sur Ubuntu 22.04
✨  Utilisation du pilote docker basé sur la configuration de l'utilisateur

💣  Fermeture en raison de PROVIDER_DOCKER_NEWGRP : "docker version --format <no value>-<no value>:<no value>" exit status 1: permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Get "http://%2Fvar%2Frun%2Fdocker.sock/v1.24/version": dial unix /var/run/docker.sock: connect: permission denied
💡  Suggestion : Add your user to the 'docker' group: 'sudo usermod -aG docker $USER && newgrp docker'
📘  Documentation: https://docs.docker.com/engine/install/linux-postinstall/

cedrik@cedrik-virtual-machine:~$ sudo usermod -aG docker  $cedrik
[sudo] Mot de passe de cedrik : 
Utilisation : usermod[options] LOGIN

Options :
  -b, --badnames                allow bad names
  -c, --comment COMMENT        nouvelle valeur du champ GECOS
  -d, --home HOME_DIR           nouveau répertoire personnel du compte utilisateur
  -e, --expiredate EXPIRE_DATE  définir la date d'expiration du compte avec EXPIRE_DATE
  -f, --inactive INACTIVE       définir le mot de passe inactif après expiration
                                à INACTIVE
  -g, --gid GROUP               forcer l'utiisation de GROUP comme groupe primaire
  -G, --groups GROUPS           nouvelle liste de groupes GROUPS supplémentaires
  -a, --append                   ajouter l'utilisateur au GROUPS supplémentaire
                                       mentionné par l'option -G sans supprimer
                                       l'utilisateur des autres groupes
  -h, --help                   afficher ce message d'aide et quitter
  -l, --login NEW_LOGIN         nouvelle valeur pour le nom de connexion
  -L, --lock                    verrouiller le compte utilisateur
  -m, --move-home               déplacer le contenu du répertoire personnel dans le
                                    nouvel emplacement (à utiliser seulement avec -d)
  -o, --non-unique              autoriser l'utilisation d'UID dupliqué (non-unique)
  -p, --password PASSWORD       utiliser un mot de passe chiffré pour le nouveau mot de passe
  -R, --root CHROOT_DIR          répertoire dans lequel faire un chroot
  -P, --prefix PREFIX_DIR       préfixe du répertoire où sont situés les fichiers etc/*
  -s, --shell SHELL             nouveau shell de login pour le compte utilisateur
  -u, --uid UID                nouvel UID pour le compte utilisateur
  -U, --unlock                  déverrouiller le compte utilisateur
  -v, --add-subuids FIRST-LAST  ajouter une gamme d'UID subordonnés
  -V, --del-subuids FIRST-LAST  supprimer la gamme des UID subordonnés
  -w, --add-subgids FIRST-LAST  ajouter une gamme de GID subordonnés
  -W, --del-subgids FIRST-LAST supprimer la gamme des GID subordonnés
  -Z, --selinux-user SEUSER   nouveau mappage d'utilisateur SELinux pour le compte utilisateur

cedrik@cedrik-virtual-machine:~$ newgrp docker
Mot de passe : 
Mot de passe non valable.
cedrik@cedrik-virtual-machine:~$ curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.21.0/bin/linux/amd64/kubectl
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 44.2M  100 44.2M    0     0  21.6M      0  0:00:02  0:00:02 --:--:-- 21.6M
cedrik@cedrik-virtual-machine:~$ chmod +x ./kubectl
cedrik@cedrik-virtual-machine:~$ kubectl version --client
La commande « kubectl » n'a pas été trouvée, mais peut être installée avec :
sudo snap install kubectl
cedrik@cedrik-virtual-machine:~$ sudo mv ./kubectl /usr/local/bin/kubectl
cedrik@cedrik-virtual-machine:~$ kubectl version --client
Client Version: version.Info{Major:"1", Minor:"21", GitVersion:"v1.21.0", GitCommit:"cb303e613a121a29364f75cc67d3d580833a7479", GitTreeState:"clean", BuildDate:"2021-04-08T16:31:21Z", GoVersion:"go1.16.1", Compiler:"gc", Platform:"linux/amd64"}
cedrik@cedrik-virtual-machine:~$ kubectl proxy --address='0.0.0.0' --disable-filter=true
W1217 14:35:49.842050   18397 proxy.go:162] Request filter disabled, your proxy is vulnerable to XSRF attacks, please be cautious
Starting to serve on [::]:8001
E1217 14:36:27.950340   18397 proxy_server.go:147] Error while proxying request: dial tcp 127.0.0.1:8080: connect: connection refused
E1217 14:36:27.975736   18397 proxy_server.go:147] Error while proxying request: dial tcp 127.0.0.1:8080: connect: connection refused
^C
cedrik@cedrik-virtual-machine:~$ sudo usermod -aG docker  $USER
cedrik@cedrik-virtual-machine:~$ newgrp docker
cedrik@cedrik-virtual-machine:~$ minkube delete
minkube : commande introuvable

cedrik@cedrik-virtual-machine:~$ minikube delete
🙄  Le profil "minikube" n'existe pas, tentative de suppression quand même.
💀  Le cluster "minikube" a été supprimé.

cedrik@cedrik-virtual-machine:~$ history 
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

cedrik@cedrik-virtual-machine:~$ minikube start
😄  minikube v1.34.0 sur Ubuntu 22.04
✨  Choix automatique du pilote docker. Autres choix: none, ssh
📌  Utilisation du pilote Docker avec le privilège root
👍  Démarrage du nœud "minikube" primary control-plane dans le cluster "minikube"
🚜  Extraction de l'image de base v0.0.45...
💾  Téléchargement du préchargement de Kubernetes v1.31.0...
    > preloaded-images-k8s-v18-v1...:  326.69 MiB / 326.69 MiB  100.00% 42.02 M
    > gcr.io/k8s-minikube/kicbase...:  487.90 MiB / 487.90 MiB  100.00% 67.78 M
🔥  Création de docker container (CPU=2, Memory=2200Mo) ...
🐳  Préparation de Kubernetes v1.31.0 sur Docker 27.2.0...
    ▪ Génération des certificats et des clés
    ▪ Démarrage du plan de contrôle ...
    ▪ Configuration des règles RBAC ...
🔗  Configuration de bridge CNI (Container Networking Interface)...
🔎  Vérification des composants Kubernetes...
    ▪ Utilisation de l'image gcr.io/k8s-minikube/storage-provisioner:v5
🌟  Modules activés: storage-provisioner, default-storageclass

❗  /usr/local/bin/kubectl est la version 1.21.0, qui peut comporter des incompatibilités avec Kubernetes 1.31.0.
    ▪ Vous voulez kubectl v1.31.0 ? Essayez 'minikube kubectl -- get pods -A'
🏄  Terminé ! kubectl est maintenant configuré pour utiliser "minikube" cluster et espace de noms "default" par défaut.
cedrik@cedrik-virtual-machine:~$ minikube dashboard --url=true
🔌  Activation du tableau de bord...
    ▪ Utilisation de l'image docker.io/kubernetesui/dashboard:v2.7.0
    ▪ Utilisation de l'image docker.io/kubernetesui/metrics-scraper:v1.0.8
💡  Certaines fonctionnalités du tableau de bord nécessitent le module complémentaire metrics-server. Pour activer toutes les fonctionnalités, veuillez exécuter :

	minikube addons enable metrics-server

🤔  Vérification de l'état du tableau de bord...
🚀  Lancement du proxy...
🤔  Vérification de l'état du proxy...
http://127.0.0.1:44827/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/

cedrik@cedrik-virtual-machine:~$ minikube stop
✋  Nœud d'arrêt "minikube" ...
🛑  1 nœud arrêté.
cedrik@cedrik-virtual-machine:~$ 
