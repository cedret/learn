devops1217_13.txt

cedrik@cedrik-virtual-machine:~/lamp_app/build$ kubectl create namespace postgres2
namespace/postgres2 created
cedrik@cedrik-virtual-machine:~/lamp_app/build$ kubectl get namespaces
NAME                   STATUS   AGE
default                Active   79m
kube-node-lease        Active   79m
kube-public            Active   79m
kube-system            Active   79m
kubernetes-dashboard   Active   78m
postgres2              Active   22s
cedrik@cedrik-virtual-machine:~/lamp_app/build$ cd ..
cedrik@cedrik-virtual-machine:~/lamp_app$ cd ..
cedrik@cedrik-virtual-machine:~$ mkdir kubernetes
cedrik@cedrik-virtual-machine:~$ cd kubernetes/
cedrik@cedrik-virtual-machine:~/kubernetes$ ls
cedrik@cedrik-virtual-machine:~/kubernetes$ minikube addons enable metrics-server

❌  Fermeture en raison de MK_ADDON_ENABLE_PAUSED : enabled failed: get state: unknown state "minikube": docker container inspect minikube --format=<no value>: exit status 1
stdout:


stderr:
permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Get "http://%2Fvar%2Frun%2Fdocker.sock/v1.24/containers/minikube/json": dial unix /var/run/docker.sock: connect: permission denied


╭──────────────────────────────────────────────────────────────────────────────────────────────────╮
│                                                                                                  │
│    😿  Si les conseils ci-dessus ne vous aident pas, veuillez nous en informer :                 │
│    👉  https://github.com/kubernetes/minikube/issues/new/choose                                  │
│                                                                                                  │
│    Veuillez exécuter `minikube logs --file=logs.txt` et attachez logs.txt au problème GitHub.    │
│    Veuillez également joindre le fichier suivant au problème GitHub                              │
│    - /tmp/minikube_addons_4c70c0a0a52dae6687bbcf5185f0845dc8841694_0.log                         │
│                                                                                                  │
╰──────────────────────────────────────────────────────────────────────────────────────────────────╯

cedrik@cedrik-virtual-machine:~/kubernetes$ sudo minikube addons enable metrics-server
[sudo] Mot de passe de cedrik : 
🤷  Profil "minikube" introuvable. Exécutez "minikube profile list" pour afficher tous les profils.
👉  Pour démarrer un cluster, exécutez : "minikube start"
cedrik@cedrik-virtual-machine:~/kubernetes$ minikube start
😄  minikube v1.34.0 sur Ubuntu 22.04
✨  Utilisation du pilote docker basé sur le profil existant

💣  Fermeture en raison de PROVIDER_DOCKER_NEWGRP : "docker version --format <no value>-<no value>:<no value>" exit status 1: permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Get "http://%2Fvar%2Frun%2Fdocker.sock/v1.24/version": dial unix /var/run/docker.sock: connect: permission denied
💡  Suggestion : Add your user to the 'docker' group: 'sudo usermod -aG docker $USER && newgrp docker'
📘  Documentation: https://docs.docker.com/engine/install/linux-postinstall/

cedrik@cedrik-virtual-machine:~/kubernetes$ sudo minikube start
😄  minikube v1.34.0 sur Ubuntu 22.04
✨  Choix automatique du pilote docker. Autres choix: none, ssh
🛑  Le pilote "docker" ne doit pas être utilisé avec les privilèges root. Si vous souhaitez continuer en tant que root, utilisez --force.
💡  Si vous exécutez minikube dans une machine virtuelle, envisagez d'utiliser --driver=none
📘    https://minikube.sigs.k8s.io/docs/reference/drivers/none/

❌  Fermeture en raison de DRV_AS_ROOT : Le pilote "docker" ne doit pas être utilisé avec les privilèges root.

cedrik@cedrik-virtual-machine:~/kubernetes$ minikube start --driver=docker
😄  minikube v1.34.0 sur Ubuntu 22.04
✨  Utilisation du pilote docker basé sur le profil existant

💣  Fermeture en raison de PROVIDER_DOCKER_NEWGRP : "docker version --format <no value>-<no value>:<no value>" exit status 1: permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Get "http://%2Fvar%2Frun%2Fdocker.sock/v1.24/version": dial unix /var/run/docker.sock: connect: permission denied
💡  Suggestion : Add your user to the 'docker' group: 'sudo usermod -aG docker $USER && newgrp docker'
📘  Documentation: https://docs.docker.com/engine/install/linux-postinstall/

cedrik@cedrik-virtual-machine:~/kubernetes$ sudo usermod -aG docker $USER && newgrp docker
cedrik@cedrik-virtual-machine:~/kubernetes$ minikube start --driver=docker
😄  minikube v1.34.0 sur Ubuntu 22.04
✨  Utilisation du pilote docker basé sur le profil existant
👍  Démarrage du nœud "minikube" primary control-plane dans le cluster "minikube"
🚜  Extraction de l'image de base v0.0.45...
🏃  Mise à jour du container docker en marche "minikube" ...
🐳  Préparation de Kubernetes v1.31.0 sur Docker 27.2.0...
🔎  Vérification des composants Kubernetes...
    ▪ Utilisation de l'image gcr.io/k8s-minikube/storage-provisioner:v5
    ▪ Utilisation de l'image docker.io/kubernetesui/metrics-scraper:v1.0.8
    ▪ Utilisation de l'image docker.io/kubernetesui/dashboard:v2.7.0
💡  Certaines fonctionnalités du tableau de bord nécessitent le module complémentaire metrics-server. Pour activer toutes les fonctionnalités, veuillez exécuter :

	minikube addons enable metrics-server

🌟  Modules activés: storage-provisioner, default-storageclass, dashboard

❗  /usr/local/bin/kubectl est la version 1.21.0, qui peut comporter des incompatibilités avec Kubernetes 1.31.0.
    ▪ Vous voulez kubectl v1.31.0 ? Essayez 'minikube kubectl -- get pods -A'
🏄  Terminé ! kubectl est maintenant configuré pour utiliser "minikube" cluster et espace de noms "default" par défaut.
cedrik@cedrik-virtual-machine:~/kubernetes$ minikube addons enable metrics-server
💡  metrics-server est un addon maintenu par Kubernetes. Pour toute question, contactez minikube sur GitHub.
Vous pouvez consulter la liste des mainteneurs de minikube sur : https://github.com/kubernetes/minikube/blob/master/OWNERS
    ▪ Utilisation de l'image registry.k8s.io/metrics-server/metrics-server:v0.7.2
🌟  Le module 'metrics-server' est activé

cedrik@cedrik-virtual-machine:~/kubernetes$ kubectl apply -f https://raw.githubusercontent.com/reactive-tech/kubegres/v1.16/kubegres.yaml
namespace/kubegres-system created
customresourcedefinition.apiextensions.k8s.io/kubegres.kubegres.reactive-tech.io created
serviceaccount/kubegres-controller-manager created
role.rbac.authorization.k8s.io/kubegres-leader-election-role created
clusterrole.rbac.authorization.k8s.io/kubegres-manager-role created
clusterrole.rbac.authorization.k8s.io/kubegres-metrics-reader created
clusterrole.rbac.authorization.k8s.io/kubegres-proxy-role created
rolebinding.rbac.authorization.k8s.io/kubegres-leader-election-rolebinding created
clusterrolebinding.rbac.authorization.k8s.io/kubegres-manager-rolebinding created
clusterrolebinding.rbac.authorization.k8s.io/kubegres-proxy-rolebinding created
configmap/kubegres-manager-config created
service/kubegres-controller-manager-metrics-service created
deployment.apps/kubegres-controller-manager created
cedrik@cedrik-virtual-machine:~/kubernetes$ docker ps
CONTAINER ID   IMAGE                                 COMMAND                  CREATED       STATUS       PORTS                                                                                                                                  NAMES
62c242bd4ed8   gcr.io/k8s-minikube/kicbase:v0.0.45   "/usr/local/bin/entr…"   2 hours ago   Up 2 hours   127.0.0.1:32772->22/tcp, 127.0.0.1:32771->2376/tcp, 127.0.0.1:32770->5000/tcp, 127.0.0.1:32769->8443/tcp, 127.0.0.1:32768->32443/tcp   minikube
cedrik@cedrik-virtual-machine:~/kubernetes$ kubectl version --client
Client Version: version.Info{Major:"1", Minor:"21", GitVersion:"v1.21.0", GitCommit:"cb303e613a121a29364f75cc67d3d580833a7479", GitTreeState:"clean", BuildDate:"2021-04-08T16:31:21Z", GoVersion:"go1.16.1", Compiler:"gc", Platform:"linux/amd64"}
cedrik@cedrik-virtual-machine:~/kubernetes$ vim db-persistent-volume.yaml
cedrik@cedrik-virtual-machine:~/kubernetes$ vim db-volume-claim.yaml
cedrik@cedrik-virtual-machine:~/kubernetes$ vim db-configmap.yaml 
cedrik@cedrik-virtual-machine:~/kubernetes$ vim db-deployment.yaml
cedrik@cedrik-virtual-machine:~/kubernetes$ vim db-service.yaml
cedrik@cedrik-virtual-machine:~/kubernetes$ kubectl apply -f db-persistent-volume.yaml
persistentvolume/postgresdb-persistent-volume created
cedrik@cedrik-virtual-machine:~/kubernetes$ kubectl apply -f db-volume-claim.yaml
persistentvolumeclaim/db-persistent-volume-claim created
cedrik@cedrik-virtual-machine:~/kubernetes$ kubectl apply -f db-configmap.yaml
configmap/db-secret-credentials created
cedrik@cedrik-virtual-machine:~/kubernetes$ kubectl apply -f db-deployment.yaml
deployment.apps/postgresdb created
cedrik@cedrik-virtual-machine:~/kubernetes$ kubectl apply -f db-service.yaml
service/postgresdb created
cedrik@cedrik-virtual-machine:~/kubernetes$ kubectl get all
NAME                              READY   STATUS             RESTARTS         AGE
pod/postgres-7898df757b-dxjbt     0/1     CrashLoopBackOff   21 (5m10s ago)   88m
pod/postgresdb-549946d946-9xsvl   1/1     Running            0                25s
pod/postgresdb-549946d946-hh2z6   1/1     Running            0                25s
pod/postgresdb-549946d946-x2whq   1/1     Running            0                25s

NAME                 TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
service/kubernetes   ClusterIP   10.96.0.1       <none>        443/TCP          107m
service/postgresdb   NodePort    10.109.130.67   <none>        5432:30839/TCP   11s

NAME                         READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/postgres     0/1     1            0           88m
deployment.apps/postgresdb   3/3     3            3           25s

NAME                                    DESIRED   CURRENT   READY   AGE
replicaset.apps/postgres-7898df757b     1         1         0       88m
replicaset.apps/postgresdb-549946d946   3         3         3       25s
cedrik@cedrik-virtual-machine:~/kubernetes$ minikube dashboard
🤔  Vérification de l'état du tableau de bord...
🚀  Lancement du proxy...
🤔  Vérification de l'état du proxy...
🎉  Ouverture de http://127.0.0.1:44219/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/ dans votre navigateur par défaut...
update.go:85: cannot change mount namespace according to change mount (/run/user/1000/doc/by-app/snap.firefox /run/user/1000/doc none bind,rw,x-snapd.ignore-missing 0 0): cannot inspect "/run/user/1000/doc": lstat /run/user/1000/doc: permission denied
Gtk-Message: 16:29:40.378: Not loading module "atk-bridge": The functionality is provided by GTK natively. Please try to not load it.
[53649, Main Thread] WARNING: Failed to read portal settings: GDBus.Error:org.freedesktop.DBus.Error.AccessDenied: Portal operation not allowed: Unable to open /proc/53649/root: 'glib warning', file /build/firefox/parts/firefox/build/toolkit/xre/nsSigHandlers.cpp:201

(firefox:53649): Gdk-WARNING **: 16:29:40.404: Failed to read portal settings: GDBus.Error:org.freedesktop.DBus.Error.AccessDenied: Portal operation not allowed: Unable to open /proc/53649/root
^C
cedrik@cedrik-virtual-machine:~/kubernetes$ kubectl exec -it postgresdb-5b9bf77c46-6xhx2 -- psql -h localhost -U testUser --password -p 5432 testDB
Error from server (NotFound): pods "postgresdb-5b9bf77c46-6xhx2" not found

cedrik@cedrik-virtual-machine:~/kubernetes$ minikube dashboard
🤔  Vérification de l'état du tableau de bord...
🚀  Lancement du proxy...
🤔  Vérification de l'état du proxy...
🎉  Ouverture de http://127.0.0.1:38121/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/ dans votre navigateur par défaut...
update.go:85: cannot change mount namespace according to change mount (/run/user/1000/doc/by-app/snap.firefox /run/user/1000/doc none bind,rw,x-snapd.ignore-missing 0 0): cannot inspect "/run/user/1000/doc": lstat /run/user/1000/doc: permission denied
Gtk-Message: 16:43:11.981: Not loading module "atk-bridge": The functionality is provided by GTK natively. Please try to not load it.
[56952, Main Thread] WARNING: Failed to read portal settings: GDBus.Error:org.freedesktop.DBus.Error.AccessDenied: Portal operation not allowed: Unable to open /proc/56952/root: 'glib warning', file /build/firefox/parts/firefox/build/toolkit/xre/nsSigHandlers.cpp:201

(firefox:56952): Gdk-WARNING **: 16:43:11.987: Failed to read portal settings: GDBus.Error:org.freedesktop.DBus.Error.AccessDenied: Portal operation not allowed: Unable to open /proc/56952/root

cedrik@cedrik-virtual-machine:~/kubernetes$ minikube stop
✋  Nœud d'arrêt "minikube" ...
🛑  Mise hors tension du profil "minikube" via SSH…
🛑  1 nœud arrêté.
