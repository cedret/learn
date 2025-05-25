sos_rsync.md

### Script v1

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
### Script v2
```
#!/bin/bash

lsblk
cd /mnt/secu2505v2
ls -al
pwd
echo "Contenu de mnt/secu2505v2"

sleep 5
cd /media/secours/secu2505v2
ls -al
pwd
echo "Contenu de media/secours/secu2505v2"

sleep 5
# mkdir secu01test
# sudo mkdir secu01test
sudo mkdir -p /mnt/secu7test5
sudo mount -t cifs //192.168.1.207/vsy21v4vrac /mnt/secu7test5 -o username=bill,password=fastoche
cd /mnt/secu7test5/
ls -al
pwd
echo "Contenu de secu7test5"

sleep 5

df -h
echo "df-h"
sleep 5
lsblk -f
echo "lsblk -f"

sleep 5
sensors
date
while true;
do
	echo "11 pour rsync depuis .207 -v1-"
	echo "12 pour rsync depuis .207 -v2-"
	echo "13 pour rsync depuis .207 -v2-"
	echo "14 pour rsync depuis .207 -v3-"
	echo "15 pour rsync depuis .207 -v4vrac-"
	echo " 0 pour quitter"

	read choix

	case $choix in
	15)
		sudo rsync -av /mnt/secu7test5 /media/secours/secu2505v2
		echo "sudo rsync -av /mnt/secu7test5 /media/secours/secu2505v2"
		echo "terminé à"
		date
		;;
	0)
		 break
		;;
	esac
done
echo "Script fini"
```
### Autres pistes

To copy a file from a **Samba shared directory** to a local directory, you can use a few different methods depending on how the Samba share is set up and the tools available on your system.

Here's how you can do it:

---

### **1. Mount the Samba Share**

First, you need to mount the Samba share to access it like a local directory. Use the following steps:

#### a. **Install the required package (if not already installed)**

On most Linux systems, the `cifs-utils` package is required to mount a Samba share. If it's not installed, you can install it using:

```bash
sudo apt install cifs-utils  # Debian/Ubuntu-based systems
sudo yum install cifs-utils  # CentOS/RedHat-based systems
```

#### b. **Mount the Samba share**

To mount the Samba share, use the `mount` command. For example:

```bash
sudo mount -t cifs //server_address/shared_folder /mnt/samba -o username=your_username,password=your_password
```

* **`//server_address/shared_folder`**: Replace this with the path to the Samba share.
* **`/mnt/samba`**: This is the local mount point where the share will be mounted.
* **`username=your_username,password=your_password`**: Provide your Samba credentials here.

#### c. **Copy the file**

Now that the Samba share is mounted, you can use standard Linux commands like `cp` or `rsync` to copy files from the mounted share to your local directory.

```bash
cp /mnt/samba/path/to/remote_file /local/directory/
```

---

### **2. Use `smbclient` to Copy Files (Without Mounting)**

If you don’t want to mount the share permanently, you can use `smbclient` to interact with the Samba share directly.

#### a. **Install smbclient (if not installed)**

If `smbclient` is not already installed, you can install it with:

```bash
sudo apt install smbclient   # Debian/Ubuntu
sudo yum install samba-client   # CentOS/RedHat
```

#### b. **Use `smbclient` to copy the file**

Once `smbclient` is installed, you can use it to connect to the Samba share and copy files. The basic syntax is:

```bash
smbclient //server_address/shared_folder -U username
```

This will prompt you for the password. After you're logged in, use the `get` command to copy a file from the Samba share to your local directory:

```bash
smb: \> get /path/to/remote_file /local/directory/
```

---

### **3. Use `rsync` with Samba Share**

You can also use `rsync` to copy files from the Samba share to your local directory. If the share is mounted, the command is straightforward:

```bash
rsync -av /mnt/samba/path/to/remote_file /local/directory/
```

If you want to use `rsync` without mounting the share, you can do something like this:

```bash
rsync -av smb://server_address/shared_folder/path/to/remote_file /local/directory/
```

Make sure that `rsync` can handle SMB protocol if you're not mounting the share first.

---

### **4. Direct File Copy Using GUI (File Manager)**

If you prefer a graphical approach:

1. **Open your file manager** (e.g., Nautilus, Dolphin).
2. **Go to "Network"** and browse for the Samba share.
3. **Connect to the share** using your credentials.
4. **Drag and drop** the file from the Samba share to your local directory.

---

### **Summary**

* **Mounting**: Mount the Samba share to a local directory and then use `cp` or `rsync`.
* **`smbclient`**: Use it directly to interact with the Samba share from the terminal without mounting.
* **GUI**: For a visual approach, use your file manager to access and copy files from the Samba share.

Let me know if you need more details on any of these steps!
