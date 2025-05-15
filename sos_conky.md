
- http://sdz.tdct.org/sdz/installer-et-configurer-conky.html
- https://www.linuxtricks.fr/wiki/conky-des-variables-systeme-sur-le-bureau
- 

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
secours@secours-Macmini:~$ cat /etc/conky/conky.conf
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
    font = 'DejaVu Sans Mono:size=12',
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
 / $color${fs_used /}/${fs_size /} ${fs_bar 6 /}
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
