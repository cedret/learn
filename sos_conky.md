
- http://sdz.tdct.org/sdz/installer-et-configurer-conky.html
- https://www.linuxtricks.fr/wiki/conky-des-variables-systeme-sur-le-bureau
- 

### First step

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
### Second step

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
Pour vérifier la vitesse du ventilateur CPU avec **Conky**, tu peux suivre ces étapes :

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
### Occupation des disques et réseau

   36  df -h
   38  lsblk -f
   
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
${color yellow}File systems:
 = $color${fs_used /}/${fs_size /} ${fs_bar 3 /}
 = $color${fs_used /media/secours/secu2505v1}/${fs_size /media/secours/secu2505v1} ${fs_bar 3 /media/secours/secu2505v1}
${color grey}Networking:
TtDw ${totaldown enp2s0}  # total downloaded
TtUp ${totalup enp2s0}    # total uploaded
Dw:$color ${downspeed enp2s0}  # download speed
Up:$color ${upspeed enp2s0}    # upload speed

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
External (/media/usb) : ${fs_used /media/usb} / ${fs_size /media/usb} (${fs_used_perc /media/usb}%)
]]

```
