sos01cli01macos.md

https://www.cyberciti.biz/faq/apple-mac-osx-nfs-mount-command-tutorial/

```
echo "monter réseau pour copie thunderbird"
  258  mkdir -p /Volumes/secu25dest207
  259  sudo mkdir -p /Volumes/secu25dest207
  260  ls
  261  mount_smbfs //accesr@192.168.1.207/vsy21tri2int /Volumes/secu25dest207
  262  mount_smbfs //accesr@192.168.1.207/vsy21tri2int /Volumes/secu25sour207
  263  ls
  264  cd vsy21tri2int/
  265  ls
  266  df -h
  267  mount
  269  ifconfig
  270  umount /Volumes/partage
  271  history 10
  272  pwd
  273  ls -al
  274  cd ..
  275  ls
  276  pwd
  277  umount /Volumes/vsy21tri2int


  360  sudo mkdir -p /Volumes/secu25dest207tri2
  361  ls /Volumes/
  363  sudo mount_smbfs //access@192.168.1.207/vsy21tri2int /Volumes/secu25dest207tri2/
  364  ls /Volumes/
  366  sudo ls /Volumes/secu25dest207tri2 
```
### Copie
```
  325  cd /Volumes/secu25dest207 
  326  sudo cd /Volumes/secu25dest207 
  327  ls
  328  sudo ls /Volumes/secu25dest207 
  329  sudo cp ttbird.txt /Volumes/secu25dest207 
  330  sudo ls /Volumes/secu25dest207 
  331  sudo cp ttbird.txt /Volumes/secu25dest207/test.rep 
  332  sudo ls /Volumes/secu25dest207/test.rep 
  333  cp -R /Users/john/Documents/mon_dossier /Volumes/partage/
  334* 
  335  cp -R /Users/access/Documents/_MNI01_Fixe/ecrans /Volumes/secu25dest207/test.rep/
  336  sudo cp -R /Users/access/Documents/_MNI01_Fixe/ecrans /Volumes/secu25dest207/test.rep/
  337  sudo ls /Volumes/secu25dest207/test.rep 
  338  sudo ls /Volumes/secu25dest207/test.rep/ecrans 
  339  sudo cp -R /Users/access/Documents/_MNI01_Fixe/Thunderbird2020 /Volumes/secu25dest207/test.rep/
  340  sudo ls /Volumes/secu25dest207/test.rep/
  341  sudo ls /Volumes/secu25dest207/test.rep/Thunderbird2020
  342  sudo ls -al /Volumes/secu25dest207/test.rep/Thunderbird2020
```

### rsync

```
  343  date
  344  echo "test macos rsync"
  346  rsync -avh --progress /Users/access/Documents/_MNI01_Fixe/miraheze /Volumes/secu25dest207/test.rep/
  347  sudo rsync -avh --progress /Users/access/Documents/_MNI01_Fixe/miraheze /Volumes/secu25dest207/test.rep/
  348  date
```

ATTENTION AU MONTAGE PAR INTERFACE GRAPHIQUE EN //

```
  359  ls /Volumes/
  360  sudo mkdir -p /Volumes/secu25dest207tri2
  361  ls /Volumes/
  363  sudo mount_smbfs //access@192.168.1.207/vsy21tri2int /Volumes/secu25dest207tri2/
  364  ls /Volumes/
  365  ls /Volumes/secu25dest207tri2 
  366  sudo ls /Volumes/secu25dest207tri2 
  369  echo "test macos rsync MNI01"
  370  date
  376  sudo rsync -avh --progress /Users/access/Documents/_MNI01_Fixe /Volumes/secu25dest207/mni01ccc2505/
  382  sudo mkdir /Volumes/secu25dest207tri2/ccc2505mni01
  385  sudo ls -al /Volumes/secu25dest207tri2/ccc2505mni01/
  390  sudo umount /Volumes/secu25dest207tri2 
  391  ls -al /Volumes/
  392  ls -al /Volumes/vsy21tri2int/
  393  ls -al /Volumes/vsy21tri2int/ccc2505mni01/
  395  sudo rsync -avh --progress /Users/access/Documents/_MNI01_Fixe /Volumes/vsy21tri2int/ccc2505mni01/
  406  sudo ls -al /Volumes/vsy21tri2int/ccc2505mni01/_MNI01_Fixe/
  sudo umount /Volumes/vsy21tri2int/
```


  Reference:
```
#Mounting the share is a 2 stage process:
# 1. Create a directory that will be the mount point
# 2. Mount the share to that directory
#Create the mount point:
mkdir share_name
#Mount the share:
mount_smbfs //username:password@server.name/share_name share_name/
#Unmount the share:
umount share_nam
```
