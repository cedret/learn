sos_rsync.md

````
    2  ls -al
    3  pwd
    4  lsblk
    5  cd /mnt/secu2505v1
    6  cd /media/secours/secu2505v1
    7  ls -al
    8  mkdir secu01test
    9  sudo mkdir secu01test
   10  ls -al
   11  sudo grsync
   12  sudo apt install rsnapshot grsync
   13  rsnapshot
   14  history 
   15  sudo grsync
   16  probleme permission distante
   17  history 
   18  sudo mkdir -p /mnt/secu7test1
   19  sudo mount -t cifs //192.168.1.207/vsy21v1bib_med /mnt/secu7test1 -o username=bill,password=fastoche
   20  cd /mnt/secu7test1/
   21  ls
   22  ls -al
   23  history 
   24  pwd
   25  cd /media/secours/secu2505v1
   26  pwd
   27  cd /media/secours/secu2505v1
   28  rsync -av /mnt/secu7test1 /media/secours/secu2505v1
   29  sudo rsync -av /mnt/secu7test1 /media/secours/secu2505v1
   30  history 
````
