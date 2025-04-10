devops1218_21.txt

https://www.sharemycode.fr/h20

cedrik@cedrik-virtual-machine:~/devops1218/elastic$ sudo docker-compose up

============================= COMMANDES

git clone https://github.com/asrs-iprec/projet.git

## Ajouter un script python dans le dossier cloné (projet)

## initialisation du depot
git init

## additionner le contenu dans la liste à envoyer sur github
git add .

## Preparation de l'envoie avec git commit
git commit -m "Ajout du script python"

## Pousser sur github
git push

## lister les branches
git branch

## créer une branche
git branch nom_branche (dev1)

## pour se deplacer sur une branche
git checkout nom_branche

## pour voir l'historique des commits
git log
git log --oneline
git log --graph 

## Pour voir la difference entre deux branches
git diff branch1 branch2

## Faiz dev
- git init
- git remote add origin https://github.com/gus/pouet.git
- git status
- git add index.html
-** pour ajouter contenu du répertoire**
- git add .
- git commit -m "first commit"
- git push
** pour forcer la déclaratiobn master**
- git push --set-upstream origin master
- git pull
** pour cloner par aun autre développeur**
- git clone https://github.com/gus/pouet.git
** Ajouter comme collaborateur**
- 

============================passage sur VScode

cedrik@cedrik-virtual-machine:~/devops1218$ ls

*docker-compose.yaml  elastic  github*

cedrik@cedrik-virtual-machine:~/devops1218$ cd github/

cedrik@cedrik-virtual-machine:~/devops1218/github$ ls

*cedret3*

cedrik@cedrik-virtual-machine:~/devops1218/github$ git clone https://github.com/asrs-iprec/projet.git

*Clonage dans 'projet'...
remote: Enumerating objects: 16, done.
remote: Counting objects: 100% (16/16), done.
remote: Compressing objects: 100% (12/12), done.
remote: Total 16 (delta 2), reused 7 (delta 1), pack-reused 0 (from 0)
Réception d'objets: 100% (16/16), fait.
Résolution des deltas: 100% (2/2), fait.*

cedrik@cedrik-virtual-machine:~/devops1218/github$ ls

*cedret3  projet*

cedrik@cedrik-virtual-machine:~/devops1218/github$ git branch

*fatal: ni ceci ni aucun de ses répertoires parents n'est un dépôt git : .git*

cedrik@cedrik-virtual-machine:~/devops1218/github$ cd projet/

cedrik@cedrik-virtual-machine:~/devops1218/github/projet$ git branch

* main*

cedrik@cedrik-virtual-machine:~/devops1218/github/projet$ ls

*apprenants.txt  README.md  test.py*

cedrik@cedrik-virtual-machine:~/devops1218/github/projet$ git branch cedret4

cedrik@cedrik-virtual-machine:~/devops1218/github/projet$ ls

*apprenants.txt  README.md  test.py*

cedrik@cedrik-virtual-machine:~/devops1218/github/projet$ git push -u origin cedret4

*Total 0 (delta 0), réutilisés 0 (delta 0), réutilisés du pack 0
remote: 
remote: Create a pull request for 'cedret4' on GitHub by visiting:
remote:      https://github.com/asrs-iprec/projet/pull/new/cedret4
remote: 
To https://github.com/asrs-iprec/projet.git
 * [new branch]      cedret4 -> cedret4
La branche 'cedret4' est paramétrée pour suivre la branche distante 'cedret4' depuis 'origin'.*

cedrik@cedrik-virtual-machine:~/devops1218/github/projet$ git checkout cedret4

*Basculement sur la branche 'cedret4'
Votre branche est à jour avec 'origin/cedret4'.*

cedrik@cedrik-virtual-machine:~/devops1218/github/projet$ ls

*apprenants.txt  README.md  test.py*

cedrik@cedrik-virtual-machine:~/devops1218/github/projet$ touch cedtest

cedrik@cedrik-virtual-machine:~/devops1218/github/projet$ git branch
 cedret4
  main*

cedrik@cedrik-virtual-machine:~/devops1218/github/projet$ ls

*apprenants.txt  cedtest  README.md  test.py*

cedrik@cedrik-virtual-machine:~/devops1218/github/projet$ git pull

*Depuis https://github.com/asrs-iprec/projet
 * [nouvelle branche] nidhal     -> origin/nidhal
 * [nouvelle branche] virgile    -> origin/virgile
 * [nouvelle branche] yes1       -> origin/yes1
Déjà à jour.*

cedrik@cedrik-virtual-machine:~/devops1218/github/projet$ git checkout yes1

*La branche 'yes1' est paramétrée pour suivre la branche distante 'yes1' depuis 'origin'.
Basculement sur la nouvelle branche 'yes1'*

cedrik@cedrik-virtual-machine:~/devops1218/github/projet$ ls

*apprenants.txt  cedtest  README.md  test2.py  test.py*

cedrik@cedrik-virtual-machine:~/devops1218/github/projet$ git checkout cedret4

*Basculement sur la branche 'cedret4'
Votre branche est à jour avec 'origin/cedret4'.*

cedrik@cedrik-virtual-machine:~/devops1218/github/projet$ touch koukou.txt

cedrik@cedrik-virtual-machine:~/devops1218/github/projet$ ls

*apprenants.txt  cedtest  koukou.txt  README.md  test.py*

cedrik@cedrik-virtual-machine:~/devops1218/github/projet$ git push

*Everything up-to-date*

cedrik@cedrik-virtual-machine:~/devops1218/github/projet$ git pull

*remote: Enumerating objects: 5, done.
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
 create mode 100644 test3.py*

 =================== EXERCICE PROJET

Exercice 1 :

- Créez une nouvelle branche modif-doc
- Déplacez vous dans celle-ci
- Faites des modifications dans un document (par exemple via nano)
- Enregistrez ces modifications (add + commit)
- Assurez vous que les modifications sont bien prises en comptes dans la branche (status + log)
- Retournez dans la branche master et observez que les modifications de sont pas présentes
- Fusionnez les deux branches et observez maintenant que les modifications se trouvent bien dans master

TP1 : Collaborer pour optimiser un code avec Github

- Créer 3 branches : dev1, dev2 et dev3
- Dev 1 : Ecrire un script python qui déclare un dictionnaire "Magasin" contenant des listes de produit en fonction de la catégorie.
- Dev2 : Ecrire un script qui transforme ces données en DataFrame et les afficher
- DeV3 : Ecrire un script qui va écrire le resultat du DataFrame dans un fichier csv.

- Le script de la bibliothèque est biblio.py le dictionnaire dans le script est Magasin
- Fusionnez les branches deux à deux et observez maintenant que les modifications se trouvent bien dans master
==================== ETAPES GIT

Configuration git sur machine local :
git config --global user.email "mail github"
git config --global user.name "username github"

1. Création d'un dépot sur Github (repository)
2. Copier le lien du depot distant
3. Ouvrir l'invite de commande Gitbash
4. Cloner le depot en local : git clone <lien>
5. se deplacer dans ce depot (avec la commande cd)
6. Ajoutrer le contenu à partager avec les collaborateurs
7. git init
8. git add .
9. git commit -m "message à passer aux collaborateurs" 
10. git push

-------
Pour recuperer une mise à jour :
git pull

========================= scripts pour py
# Déclaration du dictionnaire "Magasin" avec des listes de longueurs différentes
Magasin = {
    "Fruits": ["Pomme", "Banane", "Orange", "Fraise"],
    "Légumes": ["Carotte", "Brocoli", "Tomate", "Épinard"],
    "Produits laitiers": ["Lait", "Fromage", "Yaourt"],  # Liste plus courte
    "Viandes": ["Poulet", "Boeuf", "Porc", "Poisson"],
    "Céréales": ["Riz", "Pâtes", "Pain", "Quinoa"]
}

# Fonction pour afficher le contenu du dictionnaire
def afficher_magasin(magasin):
    for categorie, produits in magasin.items():
        print(f"{categorie}: {', '.join([str(p) for p in produits])}")

# Appel de la fonction d'affichage
afficher_magasin(Magasin)

print("\n")

========================== SUITE TP MOMO

cedrik@cedrik-virtual-machine:~/devops1218/github/projet$ git clone https://github.com/asrs-iprec/projet2.git
Clonage dans 'projet2'...
remote: Enumerating objects: 6, done.
remote: Counting objects: 100% (6/6), done.
remote: Compressing objects: 100% (5/5), done.
remote: Total 6 (delta 0), reused 3 (delta 0), pack-reused 0 (from 0)
Réception d'objets: 100% (6/6), fait.
cedrik@cedrik-virtual-machine:~/devops1218/github/projet$ ls
apprenants.txt  ced1.txt  cedtest  encsv.py  endataframe.py  koukou.txt  produits.py  projet2  README.md  test3.py  test.py
cedrik@cedrik-virtual-machine:~/devops1218/github/projet$ cd projet2/
cedrik@cedrik-virtual-machine:~/devops1218/github/projet/projet2$ git branch 
* main
cedrik@cedrik-virtual-machine:~/devops1218/github/projet/projet2$ git checkout dev2
La branche 'dev2' est paramétrée pour suivre la branche distante 'dev2' depuis 'origin'.
Basculement sur la nouvelle branche 'dev2'
cedrik@cedrik-virtual-machine:~/devops1218/github/projet/projet2$ git branch 
* dev2
  main
cedrik@cedrik-virtual-machine:~/devops1218/github/projet/projet2$ ls
README.md
cedrik@cedrik-virtual-machine:~/devops1218/github/projet/projet2$ git add .
cedrik@cedrik-virtual-machine:~/devops1218/github/projet/projet2$ git pull
Déjà à jour.
cedrik@cedrik-virtual-machine:~/devops1218/github/projet/projet2$ ls
README.md
cedrik@cedrik-virtual-machine:~/devops1218/github/projet/projet2$ git pull
Déjà à jour.
cedrik@cedrik-virtual-machine:~/devops1218/github/projet/projet2$ git pull
remote: Enumerating objects: 4, done.
remote: Counting objects: 100% (4/4), done.
remote: Compressing objects: 100% (3/3), done.
remote: Total 3 (delta 0), reused 3 (delta 0), pack-reused 0 (from 0)
Dépaquetage des objets: 100% (3/3), 453 octets | 453.00 Kio/s, fait.
Depuis https://github.com/asrs-iprec/projet2
   16329d4..14a38ae  dev2       -> origin/dev2
Mise à jour 16329d4..14a38ae
Fast-forward
 biblio.py | 9 +++++++++
 1 file changed, 9 insertions(+)
 create mode 100644 biblio.py

===========================  SUITE TP VIVI

cedrik@cedrik-virtual-machine:~/devops1218/github/projet/projet2$ cd ..
cedrik@cedrik-virtual-machine:~/devops1218/github/projet$ cd ..
cedrik@cedrik-virtual-machine:~/devops1218/github$ git pull
fatal: ni ceci ni aucun de ses répertoires parents n'est un dépôt git : .git
cedrik@cedrik-virtual-machine:~/devops1218/github$ cd projet/
cedrik@cedrik-virtual-machine:~/devops1218/github/projet$ git pull
Votre information de configuration indique de fusionner avec la référence 'refs/heads/cedret4'
du serveur distant, mais cette référence n'a pas été récupérée.
cedrik@cedrik-virtual-machine:~/devops1218/github/projet$ ls
apprenants.txt  ced1.txt  cedtest  encsv.py  endataframe.py  koukou.txt  produits.py  projet2  README.md  test3.py  test.py
cedrik@cedrik-virtual-machine:~/devops1218/github/projet$ cd projet2/
cedrik@cedrik-virtual-machine:~/devops1218/github/projet/projet2$ git pull
Déjà à jour.
cedrik@cedrik-virtual-machine:~/devops1218/github/projet/projet2$ git branch
* dev2
  main
cedrik@cedrik-virtual-machine:~/devops1218/github/projet/projet2$ git checkout dev3
La branche 'dev3' est paramétrée pour suivre la branche distante 'dev3' depuis 'origin'.
Basculement sur la nouvelle branche 'dev3'
cedrik@cedrik-virtual-machine:~/devops1218/github/projet/projet2$ git checkout dev2
Basculement sur la branche 'dev2'
Votre branche est à jour avec 'origin/dev2'.
cedrik@cedrik-virtual-machine:~/devops1218/github/projet/projet2$ git fetch
cedrik@cedrik-virtual-machine:~/devops1218/github/projet/projet2$ git pull
remote: Enumerating objects: 15, done.
remote: Counting objects: 100% (15/15), done.
remote: Compressing objects: 100% (8/8), done.
remote: Total 10 (delta 2), reused 10 (delta 2), pack-reused 0 (from 0)
Dépaquetage des objets: 100% (10/10), 1.86 Kio | 953.00 Kio/s, fait.
Depuis https://github.com/asrs-iprec/projet2
   29a6c8e..8f92b02  dev1       -> origin/dev1
   16329d4..4487ad9  dev3       -> origin/dev3
Déjà à jour.
cedrik@cedrik-virtual-machine:~/devops1218/github/projet/projet2$ 