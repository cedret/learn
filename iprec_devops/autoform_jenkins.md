

[TOC] pouet
JENKINS
https://www.youtube.com/watch?v=6YZvp2GwT0A

#### Jenkins (tech with nana)
https://www.youtube.com/watch?v=6YZvp2GwT0A

cedrik@cedrik-virtualbox:~$ sudo docker run -p 8080:8080 -p 50000:50000 -d -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts
[sudo] Mot de passe de cedrik : 
Unable to find image 'jenkins/jenkins:lts' locally
lts: Pulling from jenkins/jenkins
b2b31b28ee3c: Pull complete 
768595d27f0b: Pull complete
.......

cedrik@cedrik-virtualbox:~$ sudo docker ps
CONTAINER ID   IMAGE                 COMMAND                  CREATED              STATUS              PORTS                                                                                      NAMES
4ab1dc25d5dd   jenkins/jenkins:lts   "/usr/bin/tini -- /u…"   About a minute ago   Up About a minute   0.0.0.0:8080->8080/tcp, :::8080->8080/tcp, 0.0.0.0:50000->50000/tcp, :::50000->50000/tcp   flamboyant_bose

cedrik@cedrik-virtualbox:~$ sudo docker logs 4a
.......
*************************************************************

Jenkins initial setup is required. An admin user has been created and a password generated.
Please use the following password to proceed to installation:

ab98585694074443bd7c16ed78899485

This may also be found at: /var/jenkins_home/secrets/initialAdminPassword

*************************************************************



http://localhost:8080/
```
Démarrage
Débloquer Jenkins

Pour être sûr que que Jenkins soit configuré de façon sécurisée par un administrateur, un mot de passe a été généré dans le fichier de logs (où le trouver) ainsi que dans ce fichier sur le serveur :

/var/jenkins_home/secrets/initialAdminPassword

Veuillez copier le mot de passe depuis un des 2 endroits et le coller ci-dessous.
Mot de passe administrateur
````


suggested tools

ministrator//poiuytre
administrator//ad@ministrator.org

Sauver et continuer

http://localhost:8080/

Sauver et terminer

Jenkins est prêt !

L'installation de votre Jenkins est terminée.

### Wewantcode
https://www.youtube.com/watch?v=wByi40-bgBk&list=PLy8DguObsSuYwugJooZF_KaGO5-F_fukI&index=3
