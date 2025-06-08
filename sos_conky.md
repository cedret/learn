
- http://sdz.tdct.org/sdz/installer-et-configurer-conky.html
- https://www.linuxtricks.fr/wiki/conky-des-variables-systeme-sur-le-bureau
- 

## A - First step

```
    1  sudo apt update
    2  sudo apt-get install conky-all
    3  mkdir -p ~/.config/autostart
    4  sudo nano ~/.config/autostart/conky.desktop
    5  
    6  sudo chmod +x ~/.config/autostart/conky.desktop
    7  history
    8  reboot

secours@secours-NUC7i7BNH:~$ cat ~/.config/autostart/conky.desktop
[Desktop Entry]
Type=Application
Exec=conky -p 5
X-GNOME-Autostart-enabled=true
NoDisplay=false
Hidden=false
Name[fr_FR]=Conky
Comment[fr_FR]=Conky
X-GNOME-Autostart-Delay=0
```
#### Avec sensors
```
    1  sudo apt-get install conky-all
    2  mkdir -p ~/.config/autostart
    3  sudo chmod +x ~/.config/autostart/conky.desktop
    4  cat /etc/conky/conky.conf
    5  sudo nano /etc/conky/conky.conf
    6  sudo apt-get install lm-sensors
    7  sudo sensors-detect
```
## B - Second step

secours@secours-Macmini:~$ cat /etc/conky/conky.conf
```
-- Conky, a system monitor https://github.com/brndnmtthws/conky
--
-- This configuration file is Lua code. You can write code in here, and it will
-- execute when Conky loads. You can use it to generate your own advanced
-- configurations.
--
-- Try this (remove the `--`):
--
--   print("Loading Conky config")
--
-- For more on Lua, see:
-- https://www.lua.org/pil/contents.html

conky.config = {
    alignment = 'down_left',
    background = false,
    border_width = 1,
    cpu_avg_samples = 2,
    default_color = 'white',
    default_outline_color = 'white',
    default_shade_color = 'white',
    double_buffer = true,
    draw_borders = false,
    draw_graph_borders = true,
    draw_outline = false,
    draw_shades = false,
    extra_newline = false,
    font = 'DejaVu Sans Mono:size=10',
    gap_x = 20,
    gap_y = 20,
    minimum_height = 5,
    minimum_width = 5,
    net_avg_samples = 2,
    no_buffers = true,
    out_to_console = false,
    out_to_ncurses = false,
    out_to_stderr = false,
    out_to_x = true,
    own_window = true,
    own_window_class = 'Conky',
    own_window_type = 'desktop',
    own_window_transparent = true,
    own_window_argb_visual = true,
    own_window_argb_value = 0,
    show_graph_range = false,
    show_graph_scale = false,
    stippled_borders = 0,
    update_interval = 1.0,
    uppercase = false,
    use_spacer = 'none',
    use_xft = true,
}

conky.text = [[
${color grey}Info:$color ${scroll 32 Conky $conky_version - $sysname $nodename $kernel $machine}
$hr
${color grey}Uptime:$color $uptime
${color grey}Frequency (in MHz):$color $freq
${color grey}Frequency (in GHz):$color $freq_g
${color grey}RAM Usage:$color $mem/$memmax - $memperc% ${membar 4}
${color grey}Swap Usage:$color $swap/$swapmax - $swapperc% ${swapbar 4}
${color grey}CPU Usage:$color $cpu% ${cpubar 4}
${color grey}Processes:$color $processes  ${color grey}Running:$color $running_processes
$hr
${color grey}File systems:
 / $color${fs_used /}/${fs_size /} ${fs_bar 5 /}
${color grey}Networking:
Up:$color ${upspeed} ${color grey} - Down:$color ${downspeed}
$hr
${color grey}Name              PID     CPU%   MEM%
${color lightgrey} ${top name 1} ${top pid 1} ${top cpu 1} ${top mem 1}
${color lightgrey} ${top name 2} ${top pid 2} ${top cpu 2} ${top mem 2}
${color lightgrey} ${top name 3} ${top pid 3} ${top cpu 3} ${top mem 3}
${color lightgrey} ${top name 4} ${top pid 4} ${top cpu 4} ${top mem 4}
]]
```
---

### Afficher adresse IP

To display your **local IP address** using **Conky**, you need to use the `${addr}` variable with the name of your **network interface**.

### Step-by-Step

1. **Find your network interface name**
   Common ones are:

   * `eth0` → for Ethernet
   * `wlan0` or `wlp2s0` → for Wi-Fi

   Run this command in the terminal to see your interface names:

   ```bash
   ip addr
   ```

2. **Edit your `.conkyrc` file** (or your `conky.conf` if using newer syntax)

   Add this line where you want the local IP to appear:

   ```conky
   Local IP: ${addr wlp2s0}
   ```

   Replace `wlp2s0` with your actual interface name.

3. **Save and reload Conky**
   Either reboot or run:

   ```bash
   conky -c ~/.conkyrc
   ```

---

### Example `.conkyrc` snippet

```conky
conky.config = {
    use_xft = true,
    update_interval = 1.0,
    double_buffer = true,
    own_window = true,
    own_window_type = 'desktop',
    alignment = 'top_left',
    gap_x = 10,
    gap_y = 10,
};

conky.text = [[
${color white}Local IP: ${addr wlp2s0}
]];
```

## C - Pour vérifier la vitesse du ventilateur CPU avec **Conky**, tu peux suivre ces étapes :

### 1. Vérifie si ton système possède les outils nécessaires

Assure-toi que tu as installé **`lm-sensors`**, qui est un paquet utilisé pour accéder aux informations des capteurs de température et de vitesse des ventilateurs.

* Sur **Ubuntu/Debian** :

  ```bash
  sudo apt-get install lm-sensors
  ```

* Sur **Arch Linux** :

  ```bash
  sudo pacman -S lm_sensors
  ```

Ensuite, lance la commande suivante pour détecter les capteurs disponibles :

```bash
sudo sensors-detect
```

Réponds aux questions en acceptant les options par défaut (en appuyant sur "Entrée").

### 2. Vérifie la vitesse du ventilateur

Après avoir configuré `lm-sensors`, tu peux utiliser la commande suivante pour voir les vitesses des ventilateurs :

```bash
sensors
```

Cela te donnera des informations comme la température des différents composants et la vitesse des ventilateurs (par exemple, `fan1`, `fan2`, etc.).

### 3. Intégrer la vitesse du ventilateur dans Conky

Maintenant, pour afficher la vitesse du ventilateur CPU dans **Conky**, tu peux ajouter la ligne suivante dans ton fichier de configuration Conky (`~/.conkyrc` ou `/etc/conky/conky.conf`, selon ton installation) :

```conky
${execi 10 sensors | grep 'fan1' | cut -d' ' -f2} RPM
```

* **`execi 10`** : Cette commande exécute `sensors` toutes les 10 secondes (ajuste ce chiffre selon tes préférences).
* **`grep 'fan1'`** : Filtre la sortie pour afficher uniquement la ligne contenant la vitesse du ventilateur `fan1` (si ton ventilateur est étiqueté différemment, tu devras ajuster `fan1` par le bon nom).
* **`cut -d' ' -f2`** : Extraie la vitesse en RPM.

Si tu as plusieurs ventilateurs, tu peux répéter cette ligne pour afficher la vitesse d'autres ventilateurs, par exemple `fan2`, `fan3`, etc.

### 4. Exemple complet de configuration Conky

Voici un exemple simple de fichier `.conkyrc` où la vitesse des ventilateurs est affichée :

```conky
conky.config = {
    alignment = 'top_left',
    background = true,
    double_buffer = true,
    own_window = true,
    own_window_type = 'desktop',
    update_interval = 1.0,
};

conky.text = [[
    ${time %H:%M:%S}
    CPU Temp: ${execi 10 sensors | grep 'Core 0' | cut -d' ' -f3}
    Fan Speed: ${execi 10 sensors | grep 'fan1' | cut -d' ' -f2} RPM
]];
```
``${execi 10 sensors | grep 'fan1' | cut -d' ' -f2} RPM``

Cela va afficher l'heure, la température du CPU et la vitesse du ventilateur.

### 5. Personnalisation

Si tu veux personnaliser davantage la sortie ou si tes ventilateurs sont étiquetés différemment, n'hésite pas à adapter les commandes `grep` et `cut` en fonction de ce que retourne la commande `sensors`.

Voilà, tu devrais maintenant pouvoir voir la vitesse du ventilateur CPU dans Conky ! Si tu as d'autres questions ou si tu rencontres un problème, je suis là pour t'aider !
**.conkyrc**
```
conky.config = {
    alignment = 'top_left',
    background = true,
    double_buffer = true,
    own_window = true,
    own_window_type = 'desktop',
    update_interval = 1.0,
};

conky.text = [[
    ${time %H:%M:%S}
    CPU Temp: ${execi 10 sensors | grep 'Core 0' | cut -d' ' -f3}
    Fan Speed: ${execi 10 sensors | grep 'fan1' | cut -d' ' -f2} RPM
]];
```
---

## D - Autre approche?
To add **fan speed** information to your **Conky** setup, you'll need to first check if your system is reporting the fan speed and then display it in your Conky configuration.

### 🧰 **Steps to Add Fan Speed to Conky**

#### 1. **Check if fan speed is available on your system**

Most Linux systems expose fan speed data via the `lm-sensors` package. Here’s how you can check:

##### a. Install `lm-sensors` if you haven't already:

```bash
sudo apt install lm-sensors
```

##### b. Run the sensor detection tool:

```bash
sudo sensors-detect
```

Follow the prompts and let it scan for hardware sensors (this might take a few minutes). Once it's done, you can check your fan speeds with:

```bash
sensors
```

This command will show output like:

```
coretemp-isa-0000
Adapter: ISA adapter
Core 0:       +30.0°C  (high = +80.0°C, crit = +100.0°C)
Core 1:       +32.0°C  (high = +80.0°C, crit = +100.0°C)

fan1:        1200 RPM
fan2:        1500 RPM
```

Look for lines like `fan1`, `fan2`, etc., which indicate fan speeds in RPM (Revolutions Per Minute).

---

#### 2. **Add fan speed to your Conky config**

Once you've confirmed your fan speeds are available, you can display them in Conky.

##### Example Conky Config:

```lua
# Fan speed
Fan1 Speed: ${execi 10 sensors | grep 'fan1' | awk '{print $2}'} RPM
Fan2 Speed: ${execi 10 sensors | grep 'fan2' | awk '{print $2}'} RPM
```

### Explanation:

* **`execi 10`**: Executes the command every 10 seconds. You can adjust the interval (e.g., `execi 5` for 5 seconds).
* **`sensors`**: Runs the `sensors` command to get temperature and fan data.
* **`grep 'fan1'`**: Filters the output of `sensors` to only show lines containing `fan1`. You can change `fan1` to `fan2` or any other fan name depending on your system.
* **`awk '{print $2}'`**: Extracts the second column, which in this case would be the RPM value of the fan.

### 🧭 **Customizing Fan Speed Display**

If you want to display more than one fan (e.g., `fan1`, `fan2`), you can simply add multiple lines as shown in the example. If your system has more fans, you can repeat this process for each one.

---

#### 3. **Testing and Adjusting**

Once you've updated your Conky config, save it and restart Conky:

```bash
pkill conky
conky
```

This will display the fan speeds (RPM) on your Conky desktop.

---

### 🛠 **Alternative: Direct Access to Fan Data Files**

Some systems expose fan speed data directly via files under `/sys/class/hwmon/`. If you don't want to rely on `lm-sensors`, you can check if fan speed is available in those files.

For example:

```bash
cat /sys/class/hwmon/hwmon0/fan1_input
```

If this file exists, it will give you the RPM of `fan1`.

You can then modify your Conky config to display this file directly:

```lua
Fan1 Speed: ${execi 10 cat /sys/class/hwmon/hwmon0/fan1_input} RPM
```

---

Let me know if you have trouble finding the fan data or need help customizing further!

---

## E - Occupation des disques et réseau

   36  df -h
   38  lsblk -f
   50  ip link
   51  ip route

```
-- Conky, a system monitor https://github.com/brndnmtthws/conky
--
-- This configuration file is Lua code. You can write code in here, and it will
-- execute when Conky loads. You can use it to generate your own advanced
-- configurations.
--
-- Try this (remove the `--`):
--
--   print("Loading Conky config")
--
-- For more on Lua, see:
-- https://www.lua.org/pil/contents.html

conky.config = {
    alignment = 'down_right',
    background = false,
    border_width = 1,
    cpu_avg_samples = 2,
    default_color = 'white',
    default_outline_color = 'white',
    default_shade_color = 'white',
    double_buffer = true,
    draw_borders = false,
    draw_graph_borders = true,
    draw_outline = false,
    draw_shades = false,
    extra_newline = false,
    font = 'DejaVu Sans Mono:size=10',
    gap_x = 100,
    gap_y = 10,
    minimum_height = 5,
    minimum_width = 5,
    net_avg_samples = 2,
    no_buffers = true,
    out_to_console = false,
    out_to_ncurses = false,
    out_to_stderr = false,
    out_to_x = true,
    own_window = true,
    own_window_class = 'Conky',
    own_window_type = 'desktop',
    own_window_transparent = true,
    own_window_argb_visual = true,
    own_window_argb_value = 0,
    show_graph_range = false,
    show_graph_scale = false,
    stippled_borders = 0,
    update_interval = 2.0,
    uppercase = false,
    use_spacer = 'none',
    use_xft = true,
}

conky.text = [[
${color grey}Info:$color ${scroll 32 Conky $conky_version - $sysname $nodename $kernel $machine}
$hr
${color grey}SysTmp: ${execi 10 sensors | grep 'temp1' | awk '{print $2}'} - Uptime:$color $uptime
${color grey}Frequency (in MHz):$color $freq
${color grey}Frequency (in GHz):$color $freq_g
${color grey}RAM Usage:$color $mem/$memmax - $memperc% ${membar 4}
${color grey}Swap Usage:$color $swap/$swapmax - $swapperc% ${swapbar 4}
${color grey}CPU Usage:$color $cpu% ${cpubar 4}
${color grey}Processes:$color $processes  ${color grey}Running:$color $running_processes
$hr
${color yellow}File systems:
 = $color${fs_used /}/${fs_size /} ${fs_bar 3 /}
 = $color${fs_used /media/secours/secu2505v1}/${fs_size /media/secours/secu2505v1} ${fs_bar 3 /media/secours/secu2505v1}
 = $color${fs_used /media/secours/secu2505v2}/${fs_size /media/secours/secu2505v2} ${fs_bar 3 /media/secours/secu2505v2}
${color grey}Networking: Local IP: ${addr enp2s0}
# Network speed (download and upload) with graph
# Download speed
${downspeedgraph enp2s0 20,150 0000ff 00ff00}  # Graph for download speed (20 width, 150 height, colors)
Dw:$color ${downspeed enp2s0} KB/s
# Upload speed
${upspeedgraph enp2s0 20,150 ff0000 ffff00}  # Graph for upload speed (20 width, 150 height, colors)
Up:$color ${upspeed enp2s0} KB/s

# Add total data transferred
Total Download: ${totaldown enp2s0} 
Total Upload: ${totalup enp2s0}
$hr
${color grey}Name              PID     CPU%   MEM%
${color lightgrey} ${top name 1} ${top pid 1} ${top cpu 1} ${top mem 1}
${color lightgrey} ${top name 2} ${top pid 2} ${top cpu 2} ${top mem 2}
${color lightgrey} ${top name 3} ${top pid 3} ${top cpu 3} ${top mem 3}
${color lightgrey} ${top name 4} ${top pid 4} ${top cpu 4} ${top mem 4}
${color lightgrey} ${top name 5} ${top pid 5} ${top cpu 5} ${top mem 5}
$hr
${color lightblue}Drive Usage${color}
Root (/)      : ${fs_used /} / ${fs_size /} (${fs_used_perc /}%)
Home (/home)  : ${fs_used /home} / ${fs_size /home} (${fs_used_perc /home}%)
Secu1 (/dev/sda) : ${fs_used /media/secours/secu2505v1} / ${fs_size /media/secours/secu2505v1} (${fs_used_perc /media/secours/secu2505v1}%)
Secu2 (/dev/sdb) : ${fs_used /media/secours/secu2505v2} / ${fs_size /media/secours/secu2505v2} (${fs_used_perc /media/secours/secu2505v2}%)
External (/media/usb) : ${fs_used /media/usb} / ${fs_size /media/usb} (${fs_used_perc /media/usb}%)
# Fan speed
CpuTmp: ${execi 10 sensors | grep 'Core0' | awk '{print $2}'}

#acpitz-acpi-0
#Adapter: ACPI interface
#temp1:        +26.8°C  (crit = +95.0°C)
#coretemp-isa-0000
#Adapter: ISA adapter
#Core 0:       +45.0°C  (high = +90.0°C, crit = +90.0°C)
#Core 1:       +45.0°C  (high = +90.0°C, crit = +90.0°C)
#Core 2:       +47.0°C  (high = +90.0°C, crit = +90.0°C)
#Core 3:       +47.0°C  (high = +90.0°C, crit = +90.0°C)
]]
```
## F - Alerte coupure réseau

Très bonne idée d’utiliser **Conky** pour surveiller une **coupure réseau** sous macOS ou Linux. Même si Conky est plutôt utilisé pour l'affichage graphique, **on peut l’utiliser comme un indicateur visuel d'état réseau**, voire simuler une **alerte visuelle** si le réseau tombe.

---

## Objectif :

Afficher **un message ou une icône** dans Conky quand **le réseau est coupé**, par exemple :

* ✅ "Réseau OK"
* ❌ "⚠️ Réseau indisponible"

---

## 🛠️ Étapes avec Conky :

### 1. ✅ **Créer une fonction de test réseau dans Conky**

On utilise `if_existing` ou `execpi` pour exécuter une commande shell toutes les X secondes.

### 2. ✅ **Pinger une IP fiable** (ex. : `8.8.8.8` ou ta box)

---

### Exemple de config dans ton `~/.conkyrc` ou fichier de config Conky :

```lua
conky.config = {
    update_interval = 2,
    out_to_console = false,
    background = true,
    double_buffer = true,
    no_buffers = true,
    cpu_avg_samples = 2,
    net_avg_samples = 2,
    use_xft = true,
    font = 'DejaVu Sans:size=10',
    own_window = true,
    own_window_type = 'desktop',
    own_window_transparent = true,
    alignment = 'top_right',
    gap_x = 20,
    gap_y = 40,
};

conky.text = [[
${execpi 5 ~/.conky/network_check.sh}
]];
```

---

### 🖥️ Script Bash `~/.conky/network_check.sh`

```bash
#!/bin/bash

# IP à tester (peut être ton routeur ou une IP externe comme 8.8.8.8)
PING_IP="8.8.8.8"

# Ping une fois avec délai court
if ping -c 1 -W 1 $PING_IP &> /dev/null; then
    echo "\${color green}✅ Réseau OK"
else
    echo "\${color red}❌ Coupure réseau détectée"
fi
```

> N'oublie pas de rendre ce script exécutable :

```bash
chmod +x ~/.conky/network_check.sh
```

---

### 🧪 Résultat dans Conky :

* 🟢 Affiche en vert : `✅ Réseau OK`
* 🔴 Affiche en rouge : `❌ Coupure réseau détectée`

---

## 🔔 Bonus : Pour une vraie alerte (popup, son, etc.)

Tu peux coupler ça à un script externe déclenché depuis Conky ou cron :

```bash
if ! ping -c 1 -W 1 8.8.8.8 &> /dev/null; then
    osascript -e 'display notification "Coupure réseau détectée" with title "ALERTE Réseau"'  # macOS
fi
```

Ou sur Linux :

```bash
notify-send "ALERTE Réseau" "Coupure détectée"
```

---

## ✅ En résumé :

| Élément         | Méthode                      |
| --------------- | ---------------------------- |
| Détection       | `ping` via script Conky      |
| Affichage Conky | `execpi` toutes X secondes   |
| Alerte visuelle | Couleurs, emojis, texte      |
| Alerte externe  | `notify-send` ou `osascript` |

---

Souhaites-tu que je t’aide à intégrer ça **dans un thème Conky existant** ou que je t’ajoute un **son ou une action automatique** en cas de coupure ?

## G - Oui, il est tout à fait possible de **greffer un script Bash** dans **Conky**, ce qui permet d'afficher des informations dynamiques issues de scripts ou de commandes personnalisées directement sur ton bureau.

Voici comment tu peux intégrer un script Bash dans un fichier de configuration Conky.

---

### 1. **Utilisation de la directive `${exec}` de Conky**

Conky permet d'exécuter des commandes et des scripts via la directive `${exec}`. Cela te permet d'exécuter un script Bash à intervalles réguliers et d'afficher sa sortie dans ton interface Conky.

#### Exemple :

Imaginons que tu souhaites afficher la sortie d'un script Bash personnalisé dans Conky. Voici les étapes :

### 2. **Création d'un script Bash**

Créons un exemple de script qui récupère des informations système (par exemple, la température du processeur, l'utilisation de la mémoire, etc.). Appelons ce script `mon_script.sh`.

#### Exemple de script `mon_script.sh` :

```bash
#!/bin/bash

# Exemple de script Bash qui renvoie la température du CPU
# Cette commande est spécifique à Linux avec `sensors` installé
# Assure-toi d'avoir installé le paquet `lm-sensors` pour obtenir les températures

sensors | grep "Core 0" | awk '{print $3}'
```

1. **Rendre le script exécutable** :

   ```bash
   chmod +x /chemin/vers/mon_script.sh
   ```

2. **Vérifier le script** (au cas où il renvoie bien une sortie correcte) :

   ```bash
   /chemin/vers/mon_script.sh
   ```

### 3. **Intégrer le script Bash dans le fichier de configuration de Conky**

Voici un exemple simple d’un fichier de configuration Conky (`~/.conkyrc` ou `/etc/conky/conky.conf`), où nous greffons notre script Bash à l'aide de `${exec}`.

#### Exemple de configuration Conky :

```bash
conky.config = {
    -- Configuration globale
    alignment = 'top_left',
    background = false,
    update_interval = 1,  -- Temps entre chaque mise à jour (en secondes)
    use_xft = true,
    font = 'DejaVu Sans:size=10',
};

conky.text = [[
${color green}CPU Temperature:
${exec /chemin/vers/mon_script.sh}

${color blue}Memory Usage:
${mem} / ${memmax} (${memperc}%)

${color yellow}Uptime:
${uptime}
]];
```

#### Explications :

* **`${exec /chemin/vers/mon_script.sh}`** : Cette directive indique à Conky d'exécuter le script Bash et d'afficher sa sortie. Le résultat du script sera mis à jour à l'intervalle spécifié par `update_interval` (ici 1 seconde).
* Le reste de la configuration est standard pour afficher la température, l'utilisation de la mémoire, et l'uptime du système.

### 4. **Lancer Conky avec la nouvelle configuration**

Après avoir ajouté ton script dans la configuration Conky, lance Conky comme d'habitude :

```bash
conky
```

Tu devrais maintenant voir les informations dynamiques issues de ton script Bash s'afficher dans Conky sur ton bureau.

### 5. **Utiliser des scripts plus complexes**

Si ton script Bash est plus complexe, tu peux aussi utiliser `${execi}` pour exécuter un script à intervalles spécifiques. Par exemple, si tu veux que ton script s'exécute toutes les 10 secondes :

```bash
${execi 10 /chemin/vers/mon_script.sh}
```

Cela exécutera le script toutes les 10 secondes et mettra à jour la sortie affichée dans Conky à cet intervalle.

---

### Quelques autres options utiles :

* **`${execpi}`** : Exécuter un script ou une commande en arrière-plan à intervalles réguliers, mais sans bloquer la mise à jour de Conky.

  ```bash
  ${execpi 5 /chemin/vers/mon_script.sh}
  ```

  Cela exécutera le script toutes les 5 secondes, mais il n'attendra pas que le script se termine avant de mettre à jour l'affichage de Conky.

---

### Résumé :

1. **Créer un script Bash** qui génère des informations dynamiques.
2. **Utiliser `${exec}` ou `${execi}`** dans le fichier de configuration Conky pour exécuter ce script.
3. **Lancer Conky** et vérifier que les informations apparaissent sur ton bureau.

Cela te permet de personnaliser Conky en fonction de tes besoins et d'afficher des informations système spécifiques, en plus de celles qui sont déjà disponibles par défaut dans Conky.

Est-ce que tu veux un exemple concret de script ou une fonction particulière à intégrer dans Conky ?
