**GitHub**

## A rassembler:
https://blog.bytebytego.com/
https://qtext.io/
https://www.sharemycode.fr/uz3
https://github.com/JustFS/cours-github

## Pré-requis
### Installer Git bash pour Windows
https://git-scm.com/downloads

Après installation, clic droit avec gitbash here depuis n'importe quel dossier.

*Différence entre main et master?*

### Sources Youtube

- Git Visually Explained 
https://www.youtube.com/watch?v=-iWaarLI7zI

### 1 Working directory area
````
mkdir blabla
touch truk.py
git init
ls -la .git
````
### 2 To staging area
````
git add truk.py
git status
.gitignore
````
### 3 To local repository
````
git commit
git commit -m "initial commit"
git status
git log
````
### 4 Evolution
modifier truk.py
````
git add.
git commit -m "modif"
git log --oneline
# Relaod previous version (skfksdjhfk)
git checkout skfksdjhfk
# Compare version
git diff poazpoa skfksdjhfk
````
### 5 To remote repository
````
git remote add origin https://github.com/bidule/bidule-git.git
git push --set-upstream origin main
````
### 6 To stash
````
# safe area before comminting
git stash save
# For moving into working directory
git stash pop
````
### 7 Collaboration
````
git clone //github.com/bidule/bidule-git.git
git clone https://github.com/fireship-io/225-github-actions-demo.git
# modifications
git add truk.py
git commit -m....
git push
````
### 8 Remote to local
````
# check changes
git fetch
````
### 9 Local to working directory
````
git merge
````
### 10 Remote to working directory
````
# git fetch + git merge
git pull
````
### 11 Branches
````
git branch evolution
# Liste des branches et celle active
git branch
# Switch to new branch
git checkout evolution
# COmmit with staging
git commit -am "added machin"
git push --set-upstream origin evolution
````
### 12 New developper
````
git fetch
git merge origin/evolution
# 
git cherry-pick abc1234
````
### 13 Change repository
````
git remote -v
git remote add origin git@github.com:cedret/prof25.git
git remote set-url origin git@github.com:cedret/prof25.git


- Git Tutorial For Dummies
https://www.youtube.com/watch?v=mJ-qvsxPHpY
- Bande de codeurs
https://www.youtube.com/watch?v=gGKZLfPYORs
- Graven (bof?)
https://www.youtube.com/watch?v=gp_k0UVOYMw
- From scratch (continuer à 28 minutes)
https://www.youtube.com/watch?v=eXF0epLeCgo
- Grafikart
https://grafikart.fr/tutoriels/init-config-add-log-585#autoplay
- Bytebytego
https://www.youtube.com/watch?v=e9lnsKot_SQ
- Git Made Easy: Learn Version Control & Collaboration in Minutes!
https://www.youtube.com/watch?v=b581jEZOS40

### Github actions
- MTG France
https://www.youtube.com/watch?v=DpAgmhwgnO8
- Itech time
https://www.youtube.com/watch?v=RF2i8_xYHgg
- Github actions -Fireship - 12'
https://www.youtube.com/watch?v=eB0nUzAI7M8

https://www.youtube.com/watch?v=yfBtjLxn_6k

https://medium.com/@sivesh-kumar/git-cheat-sheet-44752b679295

https://lepeng.org/2023-03-28-git-cheatsheet/



---

## IPREC
### Préparation compte
```
access@DESKTOP-4E2R2LH MINGW64 ~
$ pwd
/c/Users/access

access@DESKTOP-4E2R2LH MINGW64 ~
$ mkdir fscratch

access@DESKTOP-4E2R2LH MINGW64 ~
$ cd fscratch/

access@DESKTOP-4E2R2LH MINGW64 ~/fscratch
$ ls

access@DESKTOP-4E2R2LH MINGW64 ~/fscratch
$ git config --global --list
user.mail=cedret3@mail.fr
user.name=cedret
user.email=cedret3@mail.fr

access@DESKTOP-4E2R2LH MINGW64 ~/fscratch
$
````

**config de git sur pc local dans gitbash**

git config --global user.mail "cedret3@mail.fr"

git config --global user.name "cedret"

## Connexion Github

Initialisation de la connexion avec *git init* fait apparaître un dossier caché *.git*
```
access@DESKTOP-4E2R2LH MINGW64 ~/fscratch
$ git init
Initialized empty Git repository in C:/Users/access/fscratch/.git/

access@DESKTOP-4E2R2LH MINGW64 ~/fscratch (master)
$ ls -al
total 16
drwxr-xr-x 1 access 197121 0 Dec 26 22:33 ./
drwxr-xr-x 1 access 197121 0 Dec 26 22:21 ../
drwxr-xr-x 1 access 197121 0 Dec 26 22:33 .git/

access@DESKTOP-4E2R2LH MINGW64 ~/fscratch (master)
$ code .
````
Pour ouvrir Vscode depuis le point de travail
Création d'un fichier *index.html*
```
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <h1> COURS FROMSCRATCH</h1>
    <h2>Version 1</h2>
    <p>Lorem ipsum dolor sit amet consectetur adipisicing elit. Non delectus voluptates reprehenderit perspiciatis reiciendis. Ut vitae labore aliquid minima excepturi officia nesciunt, consectetur quia voluptas quis eveniet, ullam dolorum eos!</p>
</body>
</html>
````

#### Versionner en local puis sur Github
Fait apparaître ce qui a été modifié en local

$ git add .

$ git status

```
access@DESKTOP-4E2R2LH MINGW64 ~/fscratch (master)
$ git add .

access@DESKTOP-4E2R2LH MINGW64 ~/fscratch (master)
$ git status
On branch master

No commits yet

Changes to be committed:
  (use "git rm --cached <file>..." to unstage)
        new file:   index.html
````
#### Et doit être reporté dans GitHub

$ git commit -m "First test"

$ git log
```
access@DESKTOP-4E2R2LH MINGW64 ~/fscratch (master)
$ git commit -m "First test"
[master (root-commit) 0f117eb] First test
 1 file changed, 13 insertions(+)
 create mode 100644 index.html

access@DESKTOP-4E2R2LH MINGW64 ~/fscratch (master)
$ git log
commit 0f117ebec50125f0b5bb4e9305c13c4ab90df930 (HEAD -> master)
Author: cedret <cedret3@mail.fr>
Date:   Thu Dec 26 22:50:43 2024 +0100

    First test
````

### Seconde version de *index.html*, et mise à jour

$ git add .

$ git status

$ git commit -m "Version 2 enrichie"

$ git log
````
access@DESKTOP-4E2R2LH MINGW64 ~/fscratch (master)
$ git add .

access@DESKTOP-4E2R2LH MINGW64 ~/fscratch (master)
$ git status
On branch master
Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
        modified:   index.html

access@DESKTOP-4E2R2LH MINGW64 ~/fscratch (master)
$ git commit -m "Version 2 enrichie"
[master df5a082] Version 2 enrichie
 1 file changed, 2 insertions(+), 1 deletion(-)

access@DESKTOP-4E2R2LH MINGW64 ~/fscratch (master)
$ git log
commit df5a082ab48f761ee2dbd1dc6c82f5acbba5b2f3 (HEAD -> master)
Author: cedret <cedret3@mail.fr>
Date:   Thu Dec 26 22:55:38 2024 +0100

    Version 2 enrichie

commit 0f117ebec50125f0b5bb4e9305c13c4ab90df930
Author: cedret <cedret3@mail.fr>
Date:   Thu Dec 26 22:50:43 2024 +0100

    First test
````
#### Pour vérifier version précédente
en idiquant le sha-1 qui identifie la vesrion ciblée.
(avec molette de la souris?)

$ git show 0f117ebec50125f0b5bb4e9305c13c4ab90df930


```
access@DESKTOP-4E2R2LH MINGW64 ~/fscratch (master)
$ git show 0f117ebec50125f0b5bb4e9305c13c4ab90df930
commit 0f117ebec50125f0b5bb4e9305c13c4ab90df930
Author: cedret <cedret3@mail.fr>
Date:   Thu Dec 26 22:50:43 2024 +0100

    First test

diff --git a/index.html b/index.html
new file mode 100644
index 0000000..051acf8
--- /dev/null
+++ b/index.html
@@ -0,0 +1,13 @@
+<!DOCTYPE html>
+<html lang="en">
+<head>
+    <meta charset="UTF-8">
+    <meta name="viewport" content="width=device-width, initial-scale=1.0">
+    <title>Document</title>
+</head>
+<body>
+    <h1> COURS FROMSCRATCH</h1>
+    <h2>Version 1</h2>
+    <p>Lorem ipsum dolor sit amet consectetur adipisicing elit. Non delectus voluptates reprehenderit perspici
atis reiciendis. Ut vitae labore aliquid minima excepturi officia nesciunt, consectetur quia voluptas quis even
iet, ullam dolorum eos!</p>
+</body>
+</html>
\ No newline at end of file
````

#### Pour valider une version antérieure

$ git checkout  0f117ebec50125f0b5bb4e9305c13c4ab90df930


```
access@DESKTOP-4E2R2LH MINGW64 ~/fscratch (master)
$ git checkout  0f117ebec50125f0b5bb4e9305c13c4ab90df930
Note: switching to '0f117ebec50125f0b5bb4e9305c13c4ab90df930'.

You are in 'detached HEAD' state. You can look around, make experimental
changes and commit them, and you can discard any commits you make in this
state without impacting any branches by switching back to a branch.

If you want to create a new branch to retain commits you create, you may
do so (now or later) by using -c with the switch command. Example:

  git switch -c <new-branch-name>

Or undo this operation with:

  git switch -

Turn off this advice by setting config variable advice.detachedHead to false

HEAD is now at 0f117eb First test

access@DESKTOP-4E2R2LH MINGW64 ~/fscratch ((0f117eb...))
````
#### On voit que l'on est plus sur la version (master) du répertoire

Pour revenir au master:

$ git checkout master

````
access@DESKTOP-4E2R2LH MINGW64 ~/fscratch ((0f117eb...))
$ git checkout master
Previous HEAD position was 0f117eb First test
Switched to branch 'master'

````
### Partage de fichiers

git clone avec l'adresse d'un compte girhub

$ git clone https://github.com/cedret/fscratch_gh.git


```
access@DESKTOP-4E2R2LH MINGW64 ~/bob
$ git clone https://github.com/cedret/fscratch_gh.git
Cloning into 'fscratch_gh'...
remote: Enumerating objects: 3, done.
remote: Counting objects: 100% (3/3), done.
remote: Total 3 (delta 0), reused 0 (delta 0), pack-reused 0 (from 0)
Receiving objects: 100% (3/3), done.
````

#### Après copie d'index.html dans le dossier ~/bob/

$ cd fscratch_gh/

$ git add .

$ git status

$ git commit -m "modif1 vers github"

$ git push -u origin main

**main ou master?**
````
access@DESKTOP-4E2R2LH MINGW64 ~/bob
$ cd fscratch_gh/

access@DESKTOP-4E2R2LH MINGW64 ~/bob/fscratch_gh (main)
$ pwd
/c/Users/access/bob/fscratch_gh

access@DESKTOP-4E2R2LH MINGW64 ~/bob/fscratch_gh (main)
$ git add .

access@DESKTOP-4E2R2LH MINGW64 ~/bob/fscratch_gh (main)
$ git status
On branch main
Your branch is up to date with 'origin/main'.

Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
        new file:   index.html


access@DESKTOP-4E2R2LH MINGW64 ~/bob/fscratch_gh (main)
$ git commit -m "modif1 vers github"
[main 448b10b] modif1 vers github
 1 file changed, 14 insertions(+)
 create mode 100644 index.html

access@DESKTOP-4E2R2LH MINGW64 ~/bob/fscratch_gh (main)
$ git push -u origin master
error: src refspec master does not match any
error: failed to push some refs to 'https://github.com/cedret/fscratch_gh.git'

access@DESKTOP-4E2R2LH MINGW64 ~/bob/fscratch_gh (main)
$ git push -u origin main
Enumerating objects: 4, done.
Counting objects: 100% (4/4), done.
Delta compression using up to 12 threads
Compressing objects: 100% (3/3), done.
Writing objects: 100% (3/3), 1.69 KiB | 1.69 MiB/s, done.
Total 3 (delta 0), reused 0 (delta 0), pack-reused 0 (from 0)
To https://github.com/cedret/fscratch_gh.git
   6c99c42..448b10b  main -> main
branch 'main' set up to track 'origin/main'.
````

Oui, tu **peux créer un repository distant (remote)** sur GitHub **depuis ta machine** via la ligne de commande, mais il faut passer **par l’API GitHub**, ou utiliser un outil comme **GitHub CLI (`gh`)**, ce qui est **plus simple**.

---

## ✅ Méthode recommandée : utiliser GitHub CLI (`gh`)

### 1. **Installer GitHub CLI**
- macOS : `brew install gh`
- Ubuntu : `sudo apt install gh`
- Windows : via [winget](https://learn.microsoft.com/en-us/windows/package-manager/winget/) ou l’[installateur](https://cli.github.com/)

### 2. **Te connecter à ton compte GitHub**
```bash
gh auth login
```
Choisis GitHub.com → SSH → Se connecter via navigateur.

### 3. **Créer un nouveau dépôt distant depuis le terminal**
```bash
gh repo create mon-nouveau-repo --public --source=. --remote=origin --push
```

Explication :
- `mon-nouveau-repo` : nom de ton dépôt GitHub.
- `--public` ou `--private` : visibilité du repo.
- `--source=.` : indique que tu veux utiliser le dossier actuel.
- `--remote=origin` : nom du remote ajouté.
- `--push` : pousse le contenu existant (si tu as déjà un commit).

---

## 🔁 Autre méthode : via API GitHub (moins convivial)

Tu peux aussi utiliser un `curl` vers l'API GitHub, mais ça demande un **token personnel** et un peu plus de manip. Si tu veux, je peux te montrer cette méthode aussi.

---

Tu veux que je t’aide à l’installer ou à créer ton repo avec `gh` ?

### Pour créer un site hébergé par github
Créer un repository de la forme
**cedret.github.io**

