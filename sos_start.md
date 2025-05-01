sostart.md
### Rapat github
````
  313  ls
  314  mkdir iprec25learn
  315  cd iprec25learn/
  316   ssh-keygen -t ed25519 -C "cedret3@mail.fr"
  317  cat /home/access/.ssh/id_ed25519.pub
  318  cat  /c/Users/access/.ssh/id_ed25519.pub
  319  cat  /c/Users/access/.ssh/id_ed25519.pub
  320  pwd
  321  git clone https://github.com/cedret/learn.git
  322  history
````
### SSH
https://www.outdoortechnologist.com/2024/01/31/remove-ssh-known-hosts-on-windows/

~/.ssh/known_hosts

C:\Users\username\.ssh

So the /home/username/.ssh/known_hosts is in C:\cygwin64\home\username\.ssh\known_hosts

#### Parc clé publique (dans serveur)
````
sudo nano /etc/ssh/sshd_config
PasswordAuthentication yes
PubkeyAuthentication yes
sudo systemctl restart sshd
````
### Python graphiques
````
# Graphiques avec matplotlib
pip list
pip install matplotlib pandas
python gantt.py

# Graphiques avec graphviz
pip install diagrams

````
Sources:
- https://www.youtube.com/watch?v=Oa-_EUg44cQ
- 

### Script check
````
#!/bin/bash

echo "🔍 Vérification de l'état SSH sur ce système Ubuntu..."

# 1. Vérifie si sshd est installé
if ! command -v sshd &> /dev/null; then
  echo "❌ OpenSSH Server (sshd) n'est pas installé."
  echo "➡️  Installe-le avec : sudo apt install -y openssh-server"
  exit 1
else
  echo "✅ OpenSSH Server est installé."
fi

# 2. Vérifie si le service est actif
STATUS=$(systemctl is-active ssh)
if [ "$STATUS" != "active" ]; then
  echo "❌ Le service SSH n'est pas actif."
  echo "➡️  Démarre-le avec : sudo systemctl enable --now ssh"
else
  echo "✅ Le service SSH est actif."
fi

# 3. Vérifie que le port 22 est à l'écoute
PORT_CHECK=$(ss -tlnp | grep ":22")
if [ -z "$PORT_CHECK" ]; then
  echo "❌ Le port 22 n'est pas en écoute. SSH ne répondra pas."
else
  echo "✅ Le port 22 est bien en écoute."
fi

# 4. Vérifie si ufw est actif et bloque SSH
if command -v ufw &> /dev/null; then
  UFW_STATUS=$(sudo ufw status | grep "Status: active")
  if [ -n "$UFW_STATUS" ]; then
    SSH_RULE=$(sudo ufw status | grep "22")
    if [ -z "$SSH_RULE" ]; then
      echo "⚠️  Le pare-feu UFW est actif mais ne permet pas SSH."
      echo "➡️  Autorise-le avec : sudo ufw allow ssh"
    else
      echo "✅ UFW autorise les connexions SSH."
    fi
  else
    echo "ℹ️  UFW n'est pas actif. Pas de pare-feu bloquant SSH."
  fi
fi

# 5. Affiche l'adresse IP de la machine
IP=$(hostname -I | awk '{print $1}')
echo "📡 Adresse IP locale du serveur : $IP"

echo "✅ Vérification SSH terminée."
echo "🧪 Tu peux maintenant tester : ssh ton_user@$IP"
````
