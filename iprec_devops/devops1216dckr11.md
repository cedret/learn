devops01.txt

gitbash
https://git-scm.com/downloads/win

file:///C:/Program%20Files/Git/ReleaseNotes.html

https://www.sharemycode.fr/gel
https://drive.google.com/file/d/1kr7jeHKGz-cK2__0ODiULCjBcmfH_YBP/view?usp=drive_link

https://qtext.io/
https://www.sharemycode.fr/uz3

# config de git sur pc local
git config --global user.mail "cedret3@mail.fr"

git config --global user.name "cedret"


https://hub.docker.com/
https://docs.docker.com/desktop/setup/install/windows-install/

============= PRATIQUE ================= GITBASH
access@DESKTOP-4E2R2LH MINGW64 ~
$ git config --global user.mail "cedret3@mail.fr"

access@DESKTOP-4E2R2LH MINGW64 ~
$ cd desktop

access@DESKTOP-4E2R2LH MINGW64 ~/desktop
$ git clone https://github.com/asrs-iprec/cedret2.git
Cloning into 'cedret2'...
info: please complete authentication in your browser...
remote: Enumerating objects: 3, done.
remote: Counting objects: 100% (3/3), done.
remote: Total 3 (delta 0), reused 0 (delta 0), pack-reused 0 (from 0)
Receiving objects: 100% (3/3), done.

access@DESKTOP-4E2R2LH MINGW64 ~/desktop
$ ls
'Nouveau dossier'/   cedret2/   desktop.ini

access@DESKTOP-4E2R2LH MINGW64 ~/desktop
$ cd cedret2

access@DESKTOP-4E2R2LH MINGW64 ~/desktop/cedret2 (main)
$ ls
README.md

access@DESKTOP-4E2R2LH MINGW64 ~/desktop/cedret2 (main)
$ ls
README.md  exercice2math2411dm.xlsx

access@DESKTOP-4E2R2LH MINGW64 ~/desktop/cedret2 (main)
$ git init
Reinitialized existing Git repository in C:/Users/access/Desktop/cedret2/.git/

access@DESKTOP-4E2R2LH MINGW64 ~/desktop/cedret2 (main)
$ git add .

access@DESKTOP-4E2R2LH MINGW64 ~/desktop/cedret2 (main)
$ git commit -m "coucou les maths"
Author identity unknown

*** Please tell me who you are.

Run

  git config --global user.email "you@example.com"
  git config --global user.name "Your Name"

to set your account's default identity.
Omit --global to set the identity only in this repository.

fatal: unable to auto-detect email address (got 'access@DESKTOP-4E2R2LH.(none)')

=========== REFAIT ============
access@DESKTOP-4E2R2LH MINGW64 ~/desktop/cedret2 (main)
$  git config --global user.email "cedret3@mail.fr"

access@DESKTOP-4E2R2LH MINGW64 ~/desktop/cedret2 (main)
$ git config --global user.name "cedret"

access@DESKTOP-4E2R2LH MINGW64 ~/desktop/cedret2 (main)
$ git commit -m "coucou"
[main 8f7a6d1] coucou
 1 file changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 exercice2math2411dm.xlsx

access@DESKTOP-4E2R2LH MINGW64 ~/desktop/cedret2 (main)
$ git push
Enumerating objects: 4, done.
Counting objects: 100% (4/4), done.
Delta compression using up to 12 threads
Compressing objects: 100% (3/3), done.
Writing objects: 100% (3/3), 9.05 KiB | 9.05 MiB/s, done.
Total 3 (delta 0), reused 0 (delta 0), pack-reused 0 (from 0)
To https://github.com/asrs-iprec/cedret2.git
   d0053ab..8f7a6d1  main -> main

============ PRATIQUE ========= UBUNTU DOCKER

sudo apt install docker.io

cedrik@cedrik-virtual-machine:~$ docker --version 
Docker version 24.0.7, build 24.0.7-0ubuntu2~22.04.1

failed to start the virtual machine vmware

https://docs.redhat.com/fr/documentation/red_hat_enterprise_linux/9/html/performing_a_standard_rhel_9_installation/preparing-for-a-network-install_assembly_preparing-for-your-installation#configuring-a-tftp-server-for-bios-based-clients_preparing-for-a-network-install

cedrik@cedrik-virtual-machine:~$ sudo docker image ls
REPOSITORY    TAG       IMAGE ID       CREATED         SIZE
hello-world   latest    d2c94e258dcb   19 months ago   13.3kB

cedrik@cedrik-virtual-machine:~$ sudo docker container ls
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

# containers arrêtés
cedrik@cedrik-virtual-machine:~$ sudo docker container ls -a
CONTAINER ID   IMAGE         COMMAND    CREATED         STATUS                     PORTS     NAMES
1c4236a7375e   hello-world   "/hello"   2 minutes ago   Exited (0) 2 minutes ago             confident_payne

cedrik@cedrik-virtual-machine:~$ sudo docker container rm 1c
1c
cedrik@cedrik-virtual-machine:~$ sudo docker pull ubuntu:latest
latest: Pulling from library/ubuntu
de44b265507a: Pull complete 
Digest: sha256:80dd3c3b9c6cecb9f1667e9290b3bc61b78c2678c02cbdae5f0fea92cc6734ab
Status: Downloaded newer image for ubuntu:latest
docker.io/library/ubuntu:latest

cedrik@cedrik-virtual-machine:~$ sudo docker image ls
REPOSITORY    TAG       IMAGE ID       CREATED         SIZE
ubuntu        latest    b1d9df8ab815   3 weeks ago     78.1MB
hello-world   latest    d2c94e258dcb   19 months ago   13.3kB

cedrik@cedrik-virtual-machine:~$ sudo docker run -it unbuntu:latest
Unable to find image 'unbuntu:latest' locally
docker: Error response from daemon: pull access denied for unbuntu, repository does not exist or may require 'docker login': denied: requested access to the resource is denied.
See 'docker run --help'.
cedrik@cedrik-virtual-machine:~$ sudo docker run -it ubuntu:latest
root@58921157fb6d:/# ls
bin  boot  dev  etc  home  lib  lib64  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var
root@58921157fb6d:/# export toto=ais
root@58921157fb6d:/# echo $toto
ais
root@58921157fb6d:/# cedrik@cedrik-virtual-machine:~$ sudo docker container ls -a
CONTAINER ID   IMAGE           COMMAND       CREATED         STATUS                        PORTS     NAMES
58921157fb6d   ubuntu:latest   "/bin/bash"   2 minutes ago   Exited (137) 17 seconds ago             mystifying_solomon
59d2d70ddef5   ubuntu:latest   "/bin/bash"   4 minutes ago   Exited (0) 4 minutes ago                upbeat_leavitt

cedrik@cedrik-virtual-machine:~$ sudo docker run -it --detach --name mubu ubuntu:latest
0a29024ee2e09e106efe0170ce52577afafa2cdcffac66273454c1f4e625ec78

cedrik@cedrik-virtual-machine:~$ sudo docker container ls
CONTAINER ID   IMAGE           COMMAND       CREATED          STATUS          PORTS     NAMES
0a29024ee2e0   ubuntu:latest   "/bin/bash"   32 seconds ago   Up 31 seconds             mubu

cedrik@cedrik-virtual-machine:~$ sudo docker container ls -a
CONTAINER ID   IMAGE           COMMAND       CREATED          STATUS          PORTS     NAMES
0a29024ee2e0   ubuntu:latest   "/bin/bash"   38 seconds ago   Up 37 seconds             mubu

cedrik@cedrik-virtual-machine:~$ sudo docker container start mubu
mubu

cedrik@cedrik-virtual-machine:~$ sudo docker container ls
CONTAINER ID   IMAGE           COMMAND       CREATED              STATUS              PORTS     NAMES
0a29024ee2e0   ubuntu:latest   "/bin/bash"   About a minute ago   Up About a minute             mubu

cedrik@cedrik-virtual-machine:~$ sudo docker container inspect mubu
[
    {
        "Id": "0a29024ee2e09e106efe0170ce52577afafa2cdcffac66273454c1f4e625ec78",
        "Created": "2024-12-16T13:09:17.516685433Z",
        "Path": "/bin/bash",
        "Args": [],
        "State": {.......................................

cedrik@cedrik-virtual-machine:~$ sudo docker container inspect mubu | grep IPAddress
            "SecondaryIPAddresses": null,
            "IPAddress": "172.17.0.2",
                    "IPAddress": "172.17.0.2",

=============== AJOUTER OPENSSH

cedrik@cedrik-virtual-machine:~$ sudo apt install openssh-server 
cedrik@cedrik-virtual-machine:~$ sudo systemctl start ssh
cedrik@cedrik-virtual-machine:~$ sudo systemctl enable ssh
Synchronizing state of ssh.service with SysV service script with /lib/systemd/systemd-sysv-install.
Executing: /lib/systemd/systemd-sysv-install enable ssh
cedrik@cedrik-virtual-machine:~$ sudo systemctl status ssh

================ APRES CONNEXION PAR VS CODE, CREATION DES FICHIERS server.py & dockerfile

cedrik@cedrik-virtual-machine:~/monimage$ cat server.py 
from flask import Flask

server = Flask('my_server')

@server.route('/')
def index():

        return 'Bonjour depuis mon conteneur'

if __name__ == '__main__':
        server.run(host='0.0.0.0', port=5000)
cedrik@cedrik-virtual-machine:~/monimage$ cat dockerfile 
FROM ubuntu:latest

RUN apt-get update && apt-get install python3-pip -y --fix-missing && pip3 install flask

ADD server.py /my_server/server.py

WORKDIR /my_server/

EXPOSE 5000

CMD python3 server.py

=========== CORRECTION ++++++++++ ATTENTION AU RESEAU !!!!!!!!!!!!

FROM ubuntu:latest
 
RUN apt-get update
RUN apt-get update && apt-get install -y python3-flask
 
ADD server.py /my_server/server.py
 
WORKDIR /my_server/
 
EXPOSE 5000
 
CMD python3 server.py

========= EXECUTION
cedrik@cedrik-virtual-machine:~/monimage$ sudo docker image build . -t monimage:latest

sudo docker image build . -t mon_image:latest

sudo docker container ls -a

cedrik@cedrik-virtual-machine:~/monimage$ sudo docker image save --output dockimag.tar monimage
[sudo] Mot de passe de cedrik : 

cedrik@cedrik-virtual-machine:~/monimage$ ls -al
total 206844
drwxrwxr-x  2 cedrik cedrik      4096 déc.  16 16:08 .
drwxr-x--- 16 cedrik cedrik      4096 déc.  16 14:39 ..
-rw-rw-r--  1 cedrik cedrik       192 déc.  16 15:28 dockerfile
-rw-rw-r--  1 cedrik cedrik       203 déc.  16 15:16 dockerfile.sos
-rw-------  1 root   root   211780096 déc.  16 16:08 dockimag.tar
-rw-rw-r--  1 cedrik cedrik       201 déc.  16 14:51 server.py


docker image load --input my_docker_image.tar

cedrik@cedrik-virtual-machine:~/monimage$ sudo docker image load --input dockimag.tar
Loaded image: monimage:latest

================ COMPOSE AVEC DOCKER DESKTOP

access@DESKTOP-4E2R2LH MINGW64 ~/dokr
$ ls
docker-compose.yml  logstash.conf

access@DESKTOP-4E2R2LH MINGW64 ~/dokr
$ docker-compose up

========= NAVIGATEUR

http://localhost:5601/app/home#/