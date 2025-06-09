### Code Bash

- https://www.it-connect.fr/debuter-script-bash-linux/
- https://www.it-connect.fr/marquer-un-temps-darret-en-bash-avec-sleep/
- https://www.digitalocean.com/community/tutorials/how-to-use-bash-history-commands-and-expansions-on-a-linux-vps
- https://www.digitalocean.com/community/tutorials/how-to-read-and-set-environmental-and-shell-variables-on-linux
- https://abs.traduc.org/abs-5.0-fr/ch15s03.html
- 

### Commandes essentielles

````
#!/bin/bash
.
..
...

````
Pour donner droits d'éxecution

``chmod +x ScriptBash.sh``

Pour éxecuter le script

``./ScriptBash.sh``

Sans chmod:

``bash ScriptBash.sh``

## B - COmmande dans variable
Oui, vous pouvez stocker une commande `rsync` dans une variable et l'exécuter dans un script bash. Il existe plusieurs manières de le faire. Voici les différentes méthodes pour y parvenir :

### Méthode 1 : Utilisation de `eval` pour exécuter la commande

Vous pouvez simplement stocker la commande dans une variable et utiliser `eval` pour l'exécuter.

Voici un exemple :

```bash
#!/bin/bash

# Définir la commande rsync dans une variable
RSYNC_CMD="rsync -avh /source/directory/ /destination/directory/"

# Exécuter la commande
eval $RSYNC_CMD
```

Dans ce cas, la commande `rsync` est stockée dans la variable `RSYNC_CMD`, et `eval` est utilisé pour l'exécuter.

### Méthode 2 : Exécuter directement sans `eval`

Il est aussi possible de simplement exécuter la commande en utilisant la syntaxe `$()` ou en l'appelant directement avec la variable comme argument dans une autre commande :

```bash
#!/bin/bash

# Définir la commande rsync dans une variable
RSYNC_CMD="rsync -avh /source/directory/ /destination/directory/"

# Exécuter la commande avec la variable
$RSYNC_CMD
```

C'est plus simple que d'utiliser `eval` et ça évite d'éventuels risques liés à l'évaluation de commandes malicieuses. Cependant, cela fonctionne uniquement si la variable contient la commande complète, sans besoin d'une évaluation spéciale.

### Méthode 3 : Utilisation de la variable dans une fonction

Une autre méthode consiste à mettre la commande dans une fonction, ce qui permet de mieux organiser votre script si vous devez exécuter plusieurs commandes `rsync` avec des arguments différents.

```bash
#!/bin/bash

# Fonction pour exécuter rsync
function execute_rsync() {
    rsync -avh /source/directory/ /destination/directory/
}

# Appeler la fonction
execute_rsync
```

Cela permet de réutiliser la même logique tout en gardant un code propre et lisible.

### Conclusion

* **`eval`** est une bonne option si vous avez besoin de manipuler dynamiquement la commande, mais il faut faire attention, car une mauvaise utilisation peut introduire des failles de sécurité.
* **`$RSYNC_CMD`** est plus simple et sans risque, à condition que la commande soit bien définie.
* Utiliser une **fonction** est une bonne manière d'organiser les commandes si vous avez plusieurs tâches similaires.

Dans la plupart des cas, l'utilisation directe de la variable (comme dans la **méthode 2**) devrait suffire et est plus sûre.

Est-ce que tu veux plus d'exemples ou des ajustements à ce script ?

