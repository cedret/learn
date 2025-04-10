https://www.sharemycode.fr/h20



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

import pandas as pd
# Fonction qui transforme les données en DataFrame
def dictToDataframe(data: dict):
    # Normaliser les longueurs des listes du dictionnaire
    max_len = max(len(liste) for liste in data.values())
    for key in data:
        while len(data[key]) < max_len:
            data[key].append("")

    return pd.DataFrame(data)

result = dictToDataframe(Magasin)

print(result)

result.to_csv('magasin.csv', index=False)

print("\nCSV sauvegardé sous le nom 'magasin.csv.")