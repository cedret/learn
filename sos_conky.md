
- http://sdz.tdct.org/sdz/installer-et-configurer-conky.html
- https://www.linuxtricks.fr/wiki/conky-des-variables-systeme-sur-le-bureau
- 

```
secours@secours-Macmini:~$ cat ~/.config/autostartconky.desktop
[Desktop Entry]
Type=Application
Exec=conky -p 5
X-GNOME-Autostart-enabled=true
NoDisplay=false
Hidden=false
Name[fr_FR]=Conky
Comment[fr_FR]=Conky
X-GNOME-Autostart-Delay=0
secours@secours-Macmini:~$ chmod +x ~/.config/autostartconky.desktop
chmod: modification des droits de '/home/secours/.config/autostartconky.desktop': Opération non permise
secours@secours-Macmini:~$ sudo chmod +x ~/.config/autostartconky.desktop
secours@secours-Macmini:~$ history 
```
```
    1  sudo apt update
    2  sudo apt-get install conky-all
    3  conky
    4  mkdir -p ~/.config/autostart
    5  ls -al
    6  sudo nano ~/.config/autostartconky.desktop
    7  cat ~/.config/autostartconky.desktop
    8  chmod +x ~/.config/autostartconky.desktop
    9  sudo chmod +x ~/.config/autostartconky.desktop
   10  history 
```
