devops rattrapage

https://www.youtube.com/watch?v=2ygog4MHXws

### TP Docker
1. Création des pages web
Créer trois pages PHP :
- index.php : Page d'accueil avec un message statique de bienvenue.
- about.php : Page À propos avec un texte statique sur l'application.
- contact.php : Page Contact affichant dynamiquement un message stocké dans la
base de données (par exemple : "Contactez-nous au 0976436742").
Configurez un serveur Apache/PHP pour servir ces pages dans un conteneur.

2. Configuration Docker Compose
Écrivez un fichier docker-compose.yml pour orchestrer les deux conteneurs (Web et Base de
données). Assurez-vous que :
- Les conteneurs sont interconnectés via le même réseau.
- Les ports externes sont mappés correctement pour accéder à l'application.
- Configurez un volume pour persister les données de MySQL.
- Montez les fichiers PHP via un volume dans le conteneur Apache pour faciliter les
modifications.

### TP Kubernetes postgré
1. Déployer PostgreSQL sur un cluster Kubernetes.
2. Configurer des volumes persistants pour les données PostgreSQL.
3. Exposer PostgreSQL avec un Service.
4. Se connecter à PostgreSQL depuis un client externe pour vérifier l'installation

https://test.gclocked.com/?form=-OEZIKJw5BHUik6DtIYO

