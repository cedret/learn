www.sharemycode.fr/fxz

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

Les étapes en détails :

Téléchargement :
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64

Installation :
sudo install minikube-linux-amd64 /usr/local/bin/minikube

Lancement du cluster minikube :
minikube start --driver=docker


Spécifier le Driver :
minikube start --driver=docker

Lancer le dashboard de minikube :
minikube dashboard --url=true


On a besoin kubectl pour pouvoir interagir avec kubernetes
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



https://www.ambient-it.net/postgresql-kubernetes/

