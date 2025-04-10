devops1218_11.txt

https://www.sharemycode.fr/h20

cedrik@cedrik-virtual-machine:~/devops1218/elastic$ sudo docker-compose up

============== VERIFICATION SSH ==================

cedrik@cedrik-virtual-machine:~/devops1218/elastic$ systemctl status ssh
● ssh.service - OpenBSD Secure Shell server
     Loaded: loaded (/lib/systemd/system/ssh.service; enabled; vendor preset: enabled)
     Active: active (running) since Wed 2024-12-18 10:02:40 CET; 6min ago
       Docs: man:sshd(8)
             man:sshd_config(5)
   Main PID: 271587 (sshd)
      Tasks: 1 (limit: 4551)
     Memory: 1.7M
        CPU: 19ms
     CGroup: /system.slice/ssh.service
             └─271587 "sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups"

déc. 18 10:02:40 cedrik-virtual-machine systemd[1]: Starting OpenBSD Secure Shell server...
déc. 18 10:02:40 cedrik-virtual-machine sshd[271587]: Server listening on 0.0.0.0 port 22.
déc. 18 10:02:40 cedrik-virtual-machine sshd[271587]: Server listening on :: port 22.
déc. 18 10:02:40 cedrik-virtual-machine systemd[1]: Started OpenBSD Secure Shell server.

cedrik@cedrik-virtual-machine:~/devops1218/elastic$ systemctl restart ssh


=======================

Après correction du logstash.conf

http://localhost:5601/app/dev_tools#/console

============ script python
cedrik@cedrik-virtual-machine:~/devops1218/elastic$ cat recup.py


#! /usr/bin/python
from elasticsearch import Elasticsearch
import json
import warnings

import warnings
warnings.filterwarnings("ignore")

# connexion au cluster
client = Elasticsearch(hosts = "http://@localhost:9200")

Ville = "Toulouse"
query = {

  "query": {
    "match": {
      "tags": "Toulouse"
    }
  }

}

response = client.search(index="vm-logs-2024.12.18", body=query)

# Sauvegarde de la requête et la réponse dans un fichier json
with open("./{}.json".format("reponse" + Ville), "w") as f:
  json.dump(dict(response), f, indent=2)

with open("./{}.json".format("requete" + Ville), "w") as f:
  json.dump(query, f, indent=2)

  ================================

cedrik@cedrik-virtual-machine:~$ cd devops1218/
cedrik@cedrik-virtual-machine:~/devops1218$ mkdir github
cedrik@cedrik-virtual-machine:~/devops1218$ cd github/
cedrik@cedrik-virtual-machine:~/devops1218/github$ git config --global user.email "cedret3@mail.fr"
cedrik@cedrik-virtual-machine:~/devops1218/github$ git config --global user.name "cedret"

============== token github
depuis settings à droite, puis developper , puis token, puis classic
A copier-coller

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

cedrik@cedrik-virtual-machine:~/devops1218/github$ git clone https://github.com/cedret/cedret3.git
Clonage dans 'cedret3'...
Username for 'https://github.com': cedret
Password for 'https://cedret@github.com': 
remote: Enumerating objects: 3, done.
remote: Counting objects: 100% (3/3), done.
remote: Total 3 (delta 0), reused 0 (delta 0), pack-reused 0 (from 0)
Réception d'objets: 100% (3/3), fait.

============================= COMMANDES

git clone https://github.com/asrs-iprec/projet.git

# Ajouter un script python dans le dossier cloné (projet)

# initialisation du depot 
git init

# additionner le contenu dans la liste à envoyer sur github
git add .

# Preparation de l'envoie avec git commit
git commit -m "Ajout du script python"

# Pousser sur github
git push

# lister les branches 
git branch

# créer une branche
git branch nom_branche (dev1)

# pour se deplacer sur une branche
git checkout nom_branche

# pour voir l'historique des commits
git log
git log --oneline
git log --graph 

# Pour voir la difference entre deux branches
git diff branch1 branch2