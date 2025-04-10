devops1218_21.txt
github


https://www.sharemycode.fr/h20

cedrik@cedrik-virtual-machine:~/devops1218/elastic$ sudo docker-compose up

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

============================ passage sur VScode

cedrik@cedrik-virtual-machine:~/devops1218$ ls
docker-compose.yaml  elastic  github
cedrik@cedrik-virtual-machine:~/devops1218$ cd github/
cedrik@cedrik-virtual-machine:~/devops1218/github$ ls
cedret3
cedrik@cedrik-virtual-machine:~/devops1218/github$ git clone https://github.com/asrs-iprec/projet.git
Clonage dans 'projet'...
remote: Enumerating objects: 16, done.
remote: Counting objects: 100% (16/16), done.
remote: Compressing objects: 100% (12/12), done.
remote: Total 16 (delta 2), reused 7 (delta 1), pack-reused 0 (from 0)
Réception d'objets: 100% (16/16), fait.
Résolution des deltas: 100% (2/2), fait.
cedrik@cedrik-virtual-machine:~/devops1218/github$ ls
cedret3  projet
cedrik@cedrik-virtual-machine:~/devops1218/github$ git branch
fatal: ni ceci ni aucun de ses répertoires parents n'est un dépôt git : .git
cedrik@cedrik-virtual-machine:~/devops1218/github$ cd projet/
cedrik@cedrik-virtual-machine:~/devops1218/github/projet$ git branch
* main
cedrik@cedrik-virtual-machine:~/devops1218/github/projet$ ls
apprenants.txt  README.md  test.py
cedrik@cedrik-virtual-machine:~/devops1218/github/projet$ git branch cedret4
cedrik@cedrik-virtual-machine:~/devops1218/github/projet$ ls
apprenants.txt  README.md  test.py
cedrik@cedrik-virtual-machine:~/devops1218/github/projet$ git push -u origin cedret4
Total 0 (delta 0), réutilisés 0 (delta 0), réutilisés du pack 0
remote: 
remote: Create a pull request for 'cedret4' on GitHub by visiting:
remote:      https://github.com/asrs-iprec/projet/pull/new/cedret4
remote: 
To https://github.com/asrs-iprec/projet.git
 * [new branch]      cedret4 -> cedret4
La branche 'cedret4' est paramétrée pour suivre la branche distante 'cedret4' depuis 'origin'.
cedrik@cedrik-virtual-machine:~/devops1218/github/projet$ git checkout cedret4
Basculement sur la branche 'cedret4'
Votre branche est à jour avec 'origin/cedret4'.
cedrik@cedrik-virtual-machine:~/devops1218/github/projet$ ls
apprenants.txt  README.md  test.py
cedrik@cedrik-virtual-machine:~/devops1218/github/projet$ touch cedtest
cedrik@cedrik-virtual-machine:~/devops1218/github/projet$ git branch
* cedret4
  main
*cedrik@cedrik-virtual-machine:~/devops1218/github/projet$ ls*
apprenants.txt  cedtest  README.md  test.py
*cedrik@cedrik-virtual-machine:~/devops1218/github/projet$ git pull*
Depuis https://github.com/asrs-iprec/projet
 * [nouvelle branche] nidhal     -> origin/nidhal
 * [nouvelle branche] virgile    -> origin/virgile
 * [nouvelle branche] yes1       -> origin/yes1
Déjà à jour.
*cedrik@cedrik-virtual-machine:~/devops1218/github/projet$ git checkout yes1*
La branche 'yes1' est paramétrée pour suivre la branche distante 'yes1' depuis 'origin'.
Basculement sur la nouvelle branche 'yes1'
*cedrik@cedrik-virtual-machine:~/devops1218/github/projet$ ls*
apprenants.txt  cedtest  README.md  test2.py  test.py
*cedrik@cedrik-virtual-machine:~/devops1218/github/projet$ git checkout cedret4*
Basculement sur la branche 'cedret4'
Votre branche est à jour avec 'origin/cedret4'.
*cedrik@cedrik-virtual-machine:~/devops1218/github/projet$ touch koukou.txt*
*cedrik@cedrik-virtual-machine:~/devops1218/github/projet$ ls*
apprenants.txt  cedtest  koukou.txt  README.md  test.py

*cedrik@cedrik-virtual-machine:~/devops1218/github/projet$ git push*
Everything up-to-date

*cedrik@cedrik-virtual-machine:~/devops1218/github/projet$ git pull*
remote: Enumerating objects: 5, done.
remote: Counting objects: 100% (5/5), done.
remote: Compressing objects: 100% (3/3), done.
remote: Total 4 (delta 0), reused 4 (delta 0), pack-reused 0 (from 0)
Dépaquetage des objets: 100% (4/4), 411 octets | 411.00 Kio/s, fait.
Depuis https://github.com/asrs-iprec/projet
   3deb7d2..69da58c  cedret4    -> origin/cedret4
 * [nouvelle branche] sabri      -> origin/sabri
Mise à jour 3deb7d2..69da58c
Fast-forward
 ced1.txt | 1 +
 test3.py | 0
 2 files changed, 1 insertion(+)
 create mode 100644 ced1.txt
 create mode 100644 test3.py