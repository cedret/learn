https://www.sharemycode.fr/gel


# Configuration de git sur pc local
git config --global user.email "ahmed.mohameden@gmail.com"

git config --global user.name "meynahmed"


https://drive.google.com/file/d/1kr7jeHKGz-cK2__0ODiULCjBcmfH_YBP/view?usp=drive_link


sudo apt update

sudo apt install docker.io

# lister les images docker 
sudo docker image ls
# lister les container docker
sudo docker container ls

# Lancer un container de l'image hello-world

sudo docker run hello-world

# Pour afficher les container à l'arret
sudo docker container ls -a

# Télachager une image ubuntu
sudo docker pull ubuntu:latest

# Créer l'image 
sudo docker image build . -t mon_image:latest


# Installer ssh sur la machine
sudo apt install oprenssh-server 

RUN apt-get update && apt-get install -y python3-flask


sudo docker run -p 5000:5000 -d mon_image:latest





