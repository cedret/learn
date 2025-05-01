docker5compose.md

Avec Ubuntu 24
````
stage@srv24vide:~$ sudo apt update
stage@srv24vide:~$ sudo apt install docker.io
stage@srv24vide:~$ sudo apt install docker-compose
stage@srv24vide:~$ sudo usermod -aG docker stage
stage@srv24vide:~$ su - stage
Password:
stage@srv24vide:~$ groups
stage adm cdrom sudo dip plugdev lxd docker
stage@srv24vide:~$ sudo apt install tree
````
### Création des fichiers et répertoires
````
stage@srv24vide:~/db$ cd ~/apaphp
stage@srv24vide:~/apaphp$ sudo nano Dockerfile
stage@srv24vide:~/apaphp$ mkdir www
stage@srv24vide:~/apaphp$ cd www
stage@srv24vide:~/apaphp/www$ sudo nano index.php
stage@srv24vide:~/apaphp/www$ sudo nano about.php
stage@srv24vide:~/apaphp/www$ sudo nano dynamique.php
````
### Affichage des fichiers
stage@srv24vide:~/apaphp/www$ cat index.php
````
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Bienvenue</title>
</head>
<body>
    <h1>Bienvenue sur mon site !</h1>
    <p>Ce message est généré avec PHP</p>
</body>
</html>
````
stage@srv24vide:~/apaphp/www$ cat about.php
````
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>À propos</title>
</head>
<body>
    <h1>À propos de ce site</h1>
    <p>Ce site a été créé pour apprendre Docker.</p>
</body>
</html>
````
stage@srv24vide:~/apaphp/www$ cat dynamique.php
````
<?php
$host = 'db';
$user = 'user';
$pass = 'pass';
$dbname = 'testdb';

$conn = new mysqli($host, $user, $pass, $dbname);

if ($conn->connect_error) {
    die("Connexion échouée : " . $conn->connect_error);
}

$result = $conn->query("SELECT message FROM messages");

echo "<h1>Messages depuis la base de données :</h1>";
while ($row = $result->fetch_assoc()) {
    echo "<p>" . htmlspecialchars($row['message']) . "</p>";
}

$conn->close();
?>
````
stage@srv24vide:~/apaphp/www$ cd -
/home/stage/apaphp
stage@srv24vide:~/apaphp$ cat Dockerfile
````
FROM php:7.4-apache

# Active mod_rewrite (optionnel)
RUN a2enmod rewrite

# Installer l'extension mysqli pour MySQL
RUN docker-php-ext-install mysqli

# Copier un fichier de config Apache si besoin (optionnel)
# COPY my-apache.conf /etc/apache2/sites-available/000-default.conf
````
stage@srv24vide:~/apaphp$ cd -
/home/stage/apaphp/www
stage@srv24vide:~/apaphp/www$ cd ~
stage@srv24vide:~$ cd dckr/
stage@srv24vide:~/dckr$ sudo nano docker-compose.yml

### Création fichier docker-compose
stage@srv24vide:~/dckr$ cat docker-compose.yml
````
version: '3.8'

services:
  web:
    build: ./apaphp
    ports:
      - "8080:80"
    volumes:
      - ./apaphp/www:/var/www/html
    depends_on:
      - db

  db:
    image: mysql:5.7
    restart: always
    environment:
      MYSQL_DATABASE: testdb
      MYSQL_USER: user
      MYSQL_PASSWORD: pass
      MYSQL_ROOT_PASSWORD: rootpass
    volumes:
      - ./db/init.sql:/docker-entrypoint-initdb.d/init.sql
````

### Structure construite
````
stage@srv24vide:~$ tree
.
└── dckr
    ├── apaphp
    │   ├── Dockerfile
    │   └── www
    │       ├── about.php
    │       ├── dynamique.php
    │       └── index.php
    ├── db
    │   └── init.sql
    └── docker-compose.yml

5 directories, 6 files
````

``stage@srv24vide:~/dckr$ docker-compose up --build``

````
Creating network "dckr_default" with the default driver
Pulling db (mysql:5.7)...
5.7: Pulling from library/mysql
20e4dcae4c69: Pull complete
1c56c3d4ce74: Pull complete
e9f03a1c24ce: Pull complete
68c3898c2015: Pull complete
6b95a940e7b6: Pull complete
90986bb8de6e: Pull complete
ae71319cb779: Pull complete
ffc89e9dfd88: Pull complete
43d05e938198: Pull complete
064b2d298fba: Pull complete
df9a4d85569b: Pull complete
Digest: sha256:4bc6bc963e6d8443453676cae56536f4b8156d78bae03c0145cbe47c2aad73bb
Status: Downloaded newer image for mysql:5.7
Building web
DEPRECATED: The legacy builder is deprecated and will be removed in a future release.
            Install the buildx component to build images with BuildKit:
            https://docs.docker.com/go/buildx/

Sending build context to Docker daemon  5.632kB
Step 1/3 : FROM php:7.4-apache
7.4-apache: Pulling from library/php
a603fa5e3b41: Pull complete
c428f1a49423: Pull complete
156740b07ef8: Pull complete
fb5a4c8af82f: Pull complete
25f85b498fd5: Pull complete
9b233e420ac7: Pull complete
fe42347c4ecf: Pull complete
d14eb2ed1e17: Pull complete
66d98f73acb6: Pull complete
d2c43c5efbc8: Pull complete
ab590b48ea47: Pull complete
80692ae2d067: Pull complete
05e465aaa99a: Pull complete
Digest: sha256:c9d7e608f73832673479770d66aacc8100011ec751d1905ff63fae3fe2e0ca6d
Status: Downloaded newer image for php:7.4-apache
 ---> 20a3732f422b
Step 2/3 : RUN a2enmod rewrite
 ---> Running in 7e2f2a38707a
Enabling module rewrite.
To activate the new configuration, you need to run:
  service apache2 restart
 ---> Removed intermediate container 7e2f2a38707a
 ---> 87f77400a35c
Step 3/3 : RUN docker-php-ext-install mysqli
 ---> Running in c186678ec70b
Configuring for:
PHP Api Version:         20190902
Zend Module Api No:      20190902
Zend Extension Api No:   320190902
````

````
checking for grep that handles long lines and -e... /bin/grep
checking for egrep... /bin/grep -E
checking for a sed that does not truncate output... /bin/sed
checking for pkg-config... /usr/bin/pkg-config
checking pkg-config is at least version 0.9.0... yes
checking for cc... cc
checking whether the C compiler works... yes
checking for C compiler default output file name... a.out
checking for suffix of executables...
checking whether we are cross compiling... no
checking for suffix of object files... o
checking whether we are using the GNU C compiler... yes
checking whether cc accepts -g... yes
checking for cc option to accept ISO C89... none needed
checking how to run the C preprocessor... cc -E
checking for icc... no
checking for suncc... no
checking for system library directory... lib
checking if compiler supports -R... no
checking if compiler supports -Wl,-rpath,... yes
checking build system type... x86_64-pc-linux-gnu
checking host system type... x86_64-pc-linux-gnu
checking target system type... x86_64-pc-linux-gnu
checking for PHP prefix... /usr/local
checking for PHP includes... -I/usr/local/include/php -I/usr/local/include/php/main -I/usr/local/include/php/TSRM -I/usr/local/include/php/Zend -I/usr/local/include/php/ext -I/usr/local/include/php/ext/date/lib
checking for PHP extension directory... /usr/local/lib/php/extensions/no-debug-non-zts-20190902
checking for PHP installed headers prefix... /usr/local/include/php
checking if debug is enabled... no
checking if zts is enabled... no
checking for gawk... no
checking for nawk... nawk
checking if nawk is broken... no
checking for MySQLi support... yes, shared
checking for specified location of the MySQL UNIX socket... no
checking for MySQL UNIX socket location... no
checking for a sed that does not truncate output... /bin/sed
checking for ld used by cc... /usr/bin/ld
checking if the linker (/usr/bin/ld) is GNU ld... yes
checking for /usr/bin/ld option to reload object files... -r
checking for BSD-compatible nm... /usr/bin/nm -B
checking whether ln -s works... yes
checking how to recognize dependent libraries... pass_all
checking for ANSI C header files... yes
checking for sys/types.h... yes
checking for sys/stat.h... yes
checking for stdlib.h... yes
checking for string.h... yes
checking for memory.h... yes
checking for strings.h... yes
checking for inttypes.h... yes
checking for stdint.h... yes
checking for unistd.h... yes
checking dlfcn.h usability... yes
checking dlfcn.h presence... yes
checking for dlfcn.h... yes
checking the maximum length of command line arguments... 1572864
checking command to parse /usr/bin/nm -B output from cc object... ok
checking for objdir... .libs
checking for ar... ar
checking for ranlib... ranlib
checking for strip... strip
checking if cc supports -fno-rtti -fno-exceptions... no
checking for cc option to produce PIC... -fPIC
checking if cc PIC flag -fPIC works... yes
checking if cc static flag -static works... yes
checking if cc supports -c -o file.o... yes
checking whether the cc linker (/usr/bin/ld -m elf_x86_64) supports shared libraries... yes
checking whether -lc should be explicitly linked in... no
checking dynamic linker characteristics... GNU/Linux ld.so
checking how to hardcode library paths into programs... immediate
checking whether stripping libraries is possible... yes
checking if libtool supports shared libraries... yes
checking whether to build shared libraries... yes
checking whether to build static libraries... no

````

````
creating libtool
appending configuration tag "CXX" to libtool
configure: patching config.h.in
configure: creating ./config.status
config.status: creating config.h
/bin/bash /usr/src/php/ext/mysqli/libtool --mode=compile cc -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -I. -I/usr/src/php/ext/mysqli -DPHP_ATOM_INC -I/usr/src/php/ext/mysqli/include -I/usr/src/php/ext/mysqli/main -I/usr/src/php/ext/mysqli -I/usr/local/include/php -I/usr/local/include/php/main -I/usr/local/include/php/TSRM -I/usr/local/include/php/Zend -I/usr/local/include/php/ext -I/usr/local/include/php/ext/date/lib  -fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -DHAVE_CONFIG_H  -fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64   -c /usr/src/php/ext/mysqli/mysqli.c -o mysqli.lo
mkdir .libs
 cc -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -I. -I/usr/src/php/ext/mysqli -DPHP_ATOM_INC -I/usr/src/php/ext/mysqli/include -I/usr/src/php/ext/mysqli/main -I/usr/src/php/ext/mysqli -I/usr/local/include/php -I/usr/local/include/php/main -I/usr/local/include/php/TSRM -I/usr/local/include/php/Zend -I/usr/local/include/php/ext -I/usr/local/include/php/ext/date/lib -fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -DHAVE_CONFIG_H -fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -c /usr/src/php/ext/mysqli/mysqli.c  -fPIC -DPIC -o .libs/mysqli.o
/bin/bash /usr/src/php/ext/mysqli/libtool --mode=compile cc -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -I. -I/usr/src/php/ext/mysqli -DPHP_ATOM_INC -I/usr/src/php/ext/mysqli/include -I/usr/src/php/ext/mysqli/main -I/usr/src/php/ext/mysqli -I/usr/local/include/php -I/usr/local/include/php/main -I/usr/local/include/php/TSRM -I/usr/local/include/php/Zend -I/usr/local/include/php/ext -I/usr/local/include/php/ext/date/lib  -fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -DHAVE_CONFIG_H  -fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64   -c /usr/src/php/ext/mysqli/mysqli_api.c -o mysqli_api.lo
 cc -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -I. -I/usr/src/php/ext/mysqli -DPHP_ATOM_INC -I/usr/src/php/ext/mysqli/include -I/usr/src/php/ext/mysqli/main -I/usr/src/php/ext/mysqli -I/usr/local/include/php -I/usr/local/include/php/main -I/usr/local/include/php/TSRM -I/usr/local/include/php/Zend -I/usr/local/include/php/ext -I/usr/local/include/php/ext/date/lib -fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -DHAVE_CONFIG_H -fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -c /usr/src/php/ext/mysqli/mysqli_api.c  -fPIC -DPIC -o .libs/mysqli_api.o
/bin/bash /usr/src/php/ext/mysqli/libtool --mode=compile cc -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -I. -I/usr/src/php/ext/mysqli -DPHP_ATOM_INC -I/usr/src/php/ext/mysqli/include -I/usr/src/php/ext/mysqli/main -I/usr/src/php/ext/mysqli -I/usr/local/include/php -I/usr/local/include/php/main -I/usr/local/include/php/TSRM -I/usr/local/include/php/Zend -I/usr/local/include/php/ext -I/usr/local/include/php/ext/date/lib  -fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -DHAVE_CONFIG_H  -fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64   -c /usr/src/php/ext/mysqli/mysqli_prop.c -o mysqli_prop.lo
 cc -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -I. -I/usr/src/php/ext/mysqli -DPHP_ATOM_INC -I/usr/src/php/ext/mysqli/include -I/usr/src/php/ext/mysqli/main -I/usr/src/php/ext/mysqli -I/usr/local/include/php -I/usr/local/include/php/main -I/usr/local/include/php/TSRM -I/usr/local/include/php/Zend -I/usr/local/include/php/ext -I/usr/local/include/php/ext/date/lib -fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -DHAVE_CONFIG_H -fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -c /usr/src/php/ext/mysqli/mysqli_prop.c  -fPIC -DPIC -o .libs/mysqli_prop.o
/bin/bash /usr/src/php/ext/mysqli/libtool --mode=compile cc -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -I. -I/usr/src/php/ext/mysqli -DPHP_ATOM_INC -I/usr/src/php/ext/mysqli/include -I/usr/src/php/ext/mysqli/main -I/usr/src/php/ext/mysqli -I/usr/local/include/php -I/usr/local/include/php/main -I/usr/local/include/php/TSRM -I/usr/local/include/php/Zend -I/usr/local/include/php/ext -I/usr/local/include/php/ext/date/lib  -fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -DHAVE_CONFIG_H  -fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64   -c /usr/src/php/ext/mysqli/mysqli_nonapi.c -o mysqli_nonapi.lo
 cc -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -I. -I/usr/src/php/ext/mysqli -DPHP_ATOM_INC -I/usr/src/php/ext/mysqli/include -I/usr/src/php/ext/mysqli/main -I/usr/src/php/ext/mysqli -I/usr/local/include/php -I/usr/local/include/php/main -I/usr/local/include/php/TSRM -I/usr/local/include/php/Zend -I/usr/local/include/php/ext -I/usr/local/include/php/ext/date/lib -fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -DHAVE_CONFIG_H -fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -c /usr/src/php/ext/mysqli/mysqli_nonapi.c  -fPIC -DPIC -o .libs/mysqli_nonapi.o
/bin/bash /usr/src/php/ext/mysqli/libtool --mode=compile cc -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -I. -I/usr/src/php/ext/mysqli -DPHP_ATOM_INC -I/usr/src/php/ext/mysqli/include -I/usr/src/php/ext/mysqli/main -I/usr/src/php/ext/mysqli -I/usr/local/include/php -I/usr/local/include/php/main -I/usr/local/include/php/TSRM -I/usr/local/include/php/Zend -I/usr/local/include/php/ext -I/usr/local/include/php/ext/date/lib  -fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -DHAVE_CONFIG_H  -fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64   -c /usr/src/php/ext/mysqli/mysqli_fe.c -o mysqli_fe.lo
 cc -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -I. -I/usr/src/php/ext/mysqli -DPHP_ATOM_INC -I/usr/src/php/ext/mysqli/include -I/usr/src/php/ext/mysqli/main -I/usr/src/php/ext/mysqli -I/usr/local/include/php -I/usr/local/include/php/main -I/usr/local/include/php/TSRM -I/usr/local/include/php/Zend -I/usr/local/include/php/ext -I/usr/local/include/php/ext/date/lib -fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -DHAVE_CONFIG_H -fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -c /usr/src/php/ext/mysqli/mysqli_fe.c  -fPIC -DPIC -o .libs/mysqli_fe.o
/bin/bash /usr/src/php/ext/mysqli/libtool --mode=compile cc -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -I. -I/usr/src/php/ext/mysqli -DPHP_ATOM_INC -I/usr/src/php/ext/mysqli/include -I/usr/src/php/ext/mysqli/main -I/usr/src/php/ext/mysqli -I/usr/local/include/php -I/usr/local/include/php/main -I/usr/local/include/php/TSRM -I/usr/local/include/php/Zend -I/usr/local/include/php/ext -I/usr/local/include/php/ext/date/lib  -fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -DHAVE_CONFIG_H  -fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64   -c /usr/src/php/ext/mysqli/mysqli_report.c -o mysqli_report.lo
 cc -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -I. -I/usr/src/php/ext/mysqli -DPHP_ATOM_INC -I/usr/src/php/ext/mysqli/include -I/usr/src/php/ext/mysqli/main -I/usr/src/php/ext/mysqli -I/usr/local/include/php -I/usr/local/include/php/main -I/usr/local/include/php/TSRM -I/usr/local/include/php/Zend -I/usr/local/include/php/ext -I/usr/local/include/php/ext/date/lib -fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -DHAVE_CONFIG_H -fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -c /usr/src/php/ext/mysqli/mysqli_report.c  -fPIC -DPIC -o .libs/mysqli_report.o
/bin/bash /usr/src/php/ext/mysqli/libtool --mode=compile cc -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -I. -I/usr/src/php/ext/mysqli -DPHP_ATOM_INC -I/usr/src/php/ext/mysqli/include -I/usr/src/php/ext/mysqli/main -I/usr/src/php/ext/mysqli -I/usr/local/include/php -I/usr/local/include/php/main -I/usr/local/include/php/TSRM -I/usr/local/include/php/Zend -I/usr/local/include/php/ext -I/usr/local/include/php/ext/date/lib  -fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -DHAVE_CONFIG_H  -fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64   -c /usr/src/php/ext/mysqli/mysqli_driver.c -o mysqli_driver.lo
 cc -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -I. -I/usr/src/php/ext/mysqli -DPHP_ATOM_INC -I/usr/src/php/ext/mysqli/include -I/usr/src/php/ext/mysqli/main -I/usr/src/php/ext/mysqli -I/usr/local/include/php -I/usr/local/include/php/main -I/usr/local/include/php/TSRM -I/usr/local/include/php/Zend -I/usr/local/include/php/ext -I/usr/local/include/php/ext/date/lib -fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -DHAVE_CONFIG_H -fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -c /usr/src/php/ext/mysqli/mysqli_driver.c  -fPIC -DPIC -o .libs/mysqli_driver.o
/bin/bash /usr/src/php/ext/mysqli/libtool --mode=compile cc -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -I. -I/usr/src/php/ext/mysqli -DPHP_ATOM_INC -I/usr/src/php/ext/mysqli/include -I/usr/src/php/ext/mysqli/main -I/usr/src/php/ext/mysqli -I/usr/local/include/php -I/usr/local/include/php/main -I/usr/local/include/php/TSRM -I/usr/local/include/php/Zend -I/usr/local/include/php/ext -I/usr/local/include/php/ext/date/lib  -fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -DHAVE_CONFIG_H  -fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64   -c /usr/src/php/ext/mysqli/mysqli_warning.c -o mysqli_warning.lo
 cc -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -I. -I/usr/src/php/ext/mysqli -DPHP_ATOM_INC -I/usr/src/php/ext/mysqli/include -I/usr/src/php/ext/mysqli/main -I/usr/src/php/ext/mysqli -I/usr/local/include/php -I/usr/local/include/php/main -I/usr/local/include/php/TSRM -I/usr/local/include/php/Zend -I/usr/local/include/php/ext -I/usr/local/include/php/ext/date/lib -fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -DHAVE_CONFIG_H -fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -c /usr/src/php/ext/mysqli/mysqli_warning.c  -fPIC -DPIC -o .libs/mysqli_warning.o
/bin/bash /usr/src/php/ext/mysqli/libtool --mode=compile cc -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -I. -I/usr/src/php/ext/mysqli -DPHP_ATOM_INC -I/usr/src/php/ext/mysqli/include -I/usr/src/php/ext/mysqli/main -I/usr/src/php/ext/mysqli -I/usr/local/include/php -I/usr/local/include/php/main -I/usr/local/include/php/TSRM -I/usr/local/include/php/Zend -I/usr/local/include/php/ext -I/usr/local/include/php/ext/date/lib  -fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -DHAVE_CONFIG_H  -fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64   -c /usr/src/php/ext/mysqli/mysqli_exception.c -o mysqli_exception.lo
 cc -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -I. -I/usr/src/php/ext/mysqli -DPHP_ATOM_INC -I/usr/src/php/ext/mysqli/include -I/usr/src/php/ext/mysqli/main -I/usr/src/php/ext/mysqli -I/usr/local/include/php -I/usr/local/include/php/main -I/usr/local/include/php/TSRM -I/usr/local/include/php/Zend -I/usr/local/include/php/ext -I/usr/local/include/php/ext/date/lib -fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -DHAVE_CONFIG_H -fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -c /usr/src/php/ext/mysqli/mysqli_exception.c  -fPIC -DPIC -o .libs/mysqli_exception.o
/bin/bash /usr/src/php/ext/mysqli/libtool --mode=compile cc -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -I. -I/usr/src/php/ext/mysqli -DPHP_ATOM_INC -I/usr/src/php/ext/mysqli/include -I/usr/src/php/ext/mysqli/main -I/usr/src/php/ext/mysqli -I/usr/local/include/php -I/usr/local/include/php/main -I/usr/local/include/php/TSRM -I/usr/local/include/php/Zend -I/usr/local/include/php/ext -I/usr/local/include/php/ext/date/lib  -fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -DHAVE_CONFIG_H  -fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64   -c /usr/src/php/ext/mysqli/mysqli_result_iterator.c -o mysqli_result_iterator.lo
 cc -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -I. -I/usr/src/php/ext/mysqli -DPHP_ATOM_INC -I/usr/src/php/ext/mysqli/include -I/usr/src/php/ext/mysqli/main -I/usr/src/php/ext/mysqli -I/usr/local/include/php -I/usr/local/include/php/main -I/usr/local/include/php/TSRM -I/usr/local/include/php/Zend -I/usr/local/include/php/ext -I/usr/local/include/php/ext/date/lib -fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -DHAVE_CONFIG_H -fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -c /usr/src/php/ext/mysqli/mysqli_result_iterator.c  -fPIC -DPIC -o .libs/mysqli_result_iterator.o
/bin/bash /usr/src/php/ext/mysqli/libtool --mode=link cc -DPHP_ATOM_INC -I/usr/src/php/ext/mysqli/include -I/usr/src/php/ext/mysqli/main -I/usr/src/php/ext/mysqli -I/usr/local/include/php -I/usr/local/include/php/main -I/usr/local/include/php/TSRM -I/usr/local/include/php/Zend -I/usr/local/include/php/ext -I/usr/local/include/php/ext/date/lib  -fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -DHAVE_CONFIG_H  -fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64  -Wl,-O1 -pie  -o mysqli.la -export-dynamic -avoid-version -prefer-pic -module -rpath /usr/src/php/ext/mysqli/modules  mysqli.lo mysqli_api.lo mysqli_prop.lo mysqli_nonapi.lo mysqli_fe.lo mysqli_report.lo mysqli_driver.lo mysqli_warning.lo mysqli_exception.lo mysqli_result_iterator.lo
cc -shared  .libs/mysqli.o .libs/mysqli_api.o .libs/mysqli_prop.o .libs/mysqli_nonapi.o .libs/mysqli_fe.o .libs/mysqli_report.o .libs/mysqli_driver.o .libs/mysqli_warning.o .libs/mysqli_exception.o .libs/mysqli_result_iterator.o   -Wl,-O1 -Wl,-soname -Wl,mysqli.so -o .libs/mysqli.so
creating mysqli.la
(cd .libs && rm -f mysqli.la && ln -s ../mysqli.la mysqli.la)
/bin/bash /usr/src/php/ext/mysqli/libtool --mode=install cp ./mysqli.la /usr/src/php/ext/mysqli/modules
cp ./.libs/mysqli.so /usr/src/php/ext/mysqli/modules/mysqli.so
cp ./.libs/mysqli.lai /usr/src/php/ext/mysqli/modules/mysqli.la
PATH="$PATH:/sbin" ldconfig -n /usr/src/php/ext/mysqli/modules
----------------------------------------------------------------------
Libraries have been installed in:
   /usr/src/php/ext/mysqli/modules

If you ever happen to want to link against installed libraries
in a given directory, LIBDIR, you must either use libtool, and
specify the full pathname of the library, or use the `-LLIBDIR'
flag during linking and do at least one of the following:
   - add LIBDIR to the `LD_LIBRARY_PATH' environment variable
     during execution
   - add LIBDIR to the `LD_RUN_PATH' environment variable
     during linking
   - use the `-Wl,--rpath -Wl,LIBDIR' linker flag
   - have your system administrator add LIBDIR to `/etc/ld.so.conf'

See any operating system documentation about shared libraries for
more information, such as the ld(1) and ld.so(8) manual pages.
----------------------------------------------------------------------

Build complete.
Don't forget to run 'make test'.
````

````
+ strip --strip-all modules/mysqli.so
Installing shared extensions:     /usr/local/lib/php/extensions/no-debug-non-zts-20190902/
Installing header files:          /usr/local/include/php/
find . -name \*.gcno -o -name \*.gcda | xargs rm -f
find . -name \*.lo -o -name \*.o | xargs rm -f
find . -name \*.la -o -name \*.a | xargs rm -f
find . -name \*.so | xargs rm -f
find . -name .libs -a -type d|xargs rm -rf
rm -f libphp.la      modules/* libs/*
 ---> Removed intermediate container c186678ec70b
 ---> 430121f95ecd
Successfully built 430121f95ecd
Successfully tagged dckr_web:latest
Creating dckr_db_1 ... done
Creating dckr_web_1 ... done
Attaching to dckr_db_1, dckr_web_1
db_1   | 2025-04-15 09:03:37+00:00 [Note] [Entrypoint]: Entrypoint script for MySQL Server 5.7.44-1.el7 started.
db_1   | 2025-04-15 09:03:38+00:00 [Note] [Entrypoint]: Switching to dedicated user 'mysql'
db_1   | 2025-04-15 09:03:38+00:00 [Note] [Entrypoint]: Entrypoint script for MySQL Server 5.7.44-1.el7 started.
db_1   | 2025-04-15 09:03:38+00:00 [Note] [Entrypoint]: Initializing database files
db_1   | 2025-04-15T09:03:38.892109Z 0 [Warning] TIMESTAMP with implicit DEFAULT value is deprecated. Please use --explicit_defaults_for_timestamp server option (see documentation for more details).
web_1  | AH00558: apache2: Could not reliably determine the server's fully qualified domain name, using 172.18.0.3. Set the 'ServerName' directive globally to suppress this message
web_1  | AH00558: apache2: Could not reliably determine the server's fully qualified domain name, using 172.18.0.3. Set the 'ServerName' directive globally to suppress this message
web_1  | [Tue Apr 15 09:03:39.015152 2025] [mpm_prefork:notice] [pid 1] AH00163: Apache/2.4.54 (Debian) PHP/7.4.33 configured -- resuming normal operations
web_1  | [Tue Apr 15 09:03:39.015214 2025] [core:notice] [pid 1] AH00094: Command line: 'apache2 -D FOREGROUND'
db_1   | 2025-04-15T09:03:39.272869Z 0 [Warning] InnoDB: New log files created, LSN=45790
db_1   | 2025-04-15T09:03:39.319156Z 0 [Warning] InnoDB: Creating foreign key constraint system tables.
db_1   | 2025-04-15T09:03:39.379058Z 0 [Warning] No existing UUID has been found, so we assume that this is the first time that this server has been started. Generating a new UUID: 859d3dbc-19d8-11f0-bf7b-0242ac120002.
db_1   | 2025-04-15T09:03:39.382408Z 0 [Warning] Gtid table is not ready to be used. Table 'mysql.gtid_executed' cannot be opened.
db_1   | 2025-04-15T09:03:39.650173Z 0 [Warning] A deprecated TLS version TLSv1 is enabled. Please use TLSv1.2 or higher.
db_1   | 2025-04-15T09:03:39.650215Z 0 [Warning] A deprecated TLS version TLSv1.1 is enabled. Please use TLSv1.2 or higher.
db_1   | 2025-04-15T09:03:39.652158Z 0 [Warning] CA certificate ca.pem is self signed.
db_1   | 2025-04-15T09:03:39.689453Z 1 [Warning] root@localhost is created with an empty password ! Please consider switching off the --initialize-insecure option.
db_1   | 2025-04-15 09:03:41+00:00 [Note] [Entrypoint]: Database files initialized
db_1   | 2025-04-15 09:03:41+00:00 [Note] [Entrypoint]: Starting temporary server
db_1   | 2025-04-15 09:03:41+00:00 [Note] [Entrypoint]: Waiting for server startup
db_1   | 2025-04-15T09:03:42.841803Z 0 [Warning] TIMESTAMP with implicit DEFAULT value is deprecated. Please use --explicit_defaults_for_timestamp server option (see documentation for more details).
db_1   | 2025-04-15T09:03:42.865495Z 0 [Note] mysqld (mysqld 5.7.44) starting as process 124 ...
db_1   | 2025-04-15T09:03:42.886504Z 0 [Note] InnoDB: PUNCH HOLE support available
db_1   | 2025-04-15T09:03:42.886721Z 0 [Note] InnoDB: Mutexes and rw_locks use GCC atomic builtins
db_1   | 2025-04-15T09:03:42.886795Z 0 [Note] InnoDB: Uses event mutexes
db_1   | 2025-04-15T09:03:42.886897Z 0 [Note] InnoDB: GCC builtin __atomic_thread_fence() is used for memory barrier
db_1   | 2025-04-15T09:03:42.886961Z 0 [Note] InnoDB: Compressed tables use zlib 1.2.13
db_1   | 2025-04-15T09:03:42.887005Z 0 [Note] InnoDB: Using Linux native AIO
db_1   | 2025-04-15T09:03:42.889646Z 0 [Note] InnoDB: Number of pools: 1
db_1   | 2025-04-15T09:03:42.890958Z 0 [Note] InnoDB: Using CPU crc32 instructions
db_1   | 2025-04-15T09:03:42.910271Z 0 [Note] InnoDB: Initializing buffer pool, total size = 128M, instances = 1, chunk size = 128M
db_1   | 2025-04-15T09:03:42.953157Z 0 [Note] InnoDB: Completed initialization of buffer pool
db_1   | 2025-04-15T09:03:42.957366Z 0 [Note] InnoDB: If the mysqld execution user is authorized, page cleaner thread priority can be changed. See the man page of setpriority().
db_1   | 2025-04-15T09:03:42.969004Z 0 [Note] InnoDB: Highest supported file format is Barracuda.
db_1   | 2025-04-15T09:03:42.979149Z 0 [Note] InnoDB: Creating shared tablespace for temporary tables
db_1   | 2025-04-15T09:03:42.979298Z 0 [Note] InnoDB: Setting file './ibtmp1' size to 12 MB. Physically writing the file full; Please wait ...
db_1   | 2025-04-15T09:03:43.012028Z 0 [Note] InnoDB: File './ibtmp1' size is now 12 MB.
db_1   | 2025-04-15T09:03:43.013115Z 0 [Note] InnoDB: 96 redo rollback segment(s) found. 96 redo rollback segment(s) are active.
db_1   | 2025-04-15T09:03:43.013152Z 0 [Note] InnoDB: 32 non-redo rollback segment(s) are active.
db_1   | 2025-04-15T09:03:43.014090Z 0 [Note] InnoDB: 5.7.44 started; log sequence number 2768291
db_1   | 2025-04-15T09:03:43.014328Z 0 [Note] InnoDB: Loading buffer pool(s) from /var/lib/mysql/ib_buffer_pool
db_1   | 2025-04-15T09:03:43.015668Z 0 [Note] Plugin 'FEDERATED' is disabled.
db_1   | 2025-04-15T09:03:43.016930Z 0 [Note] InnoDB: Buffer pool(s) load completed at 250415  9:03:43
db_1   | 2025-04-15T09:03:43.024155Z 0 [Note] Found ca.pem, server-cert.pem and server-key.pem in data directory. Trying to enable SSL support using them.
db_1   | 2025-04-15T09:03:43.024205Z 0 [Note] Skipping generation of SSL certificates as certificate files are present in data directory.
db_1   | 2025-04-15T09:03:43.024211Z 0 [Warning] A deprecated TLS version TLSv1 is enabled. Please use TLSv1.2 or higher.
db_1   | 2025-04-15T09:03:43.024213Z 0 [Warning] A deprecated TLS version TLSv1.1 is enabled. Please use TLSv1.2 or higher.
db_1   | 2025-04-15T09:03:43.024848Z 0 [Warning] CA certificate ca.pem is self signed.
db_1   | 2025-04-15T09:03:43.025027Z 0 [Note] Skipping generation of RSA key pair as key files are present in data directory.
db_1   | 2025-04-15T09:03:43.028677Z 0 [Warning] Insecure configuration for --pid-file: Location '/var/run/mysqld' in the path is accessible to all OS users. Consider choosing a different directory.
db_1   | 2025-04-15T09:03:43.039779Z 0 [Note] Event Scheduler: Loaded 0 events
db_1   | 2025-04-15T09:03:43.040487Z 0 [Note] mysqld: ready for connections.
db_1   | Version: '5.7.44'  socket: '/var/run/mysqld/mysqld.sock'  port: 0  MySQL Community Server (GPL)
db_1   | 2025-04-15 09:03:43+00:00 [Note] [Entrypoint]: Temporary server started.
db_1   | '/var/lib/mysql/mysql.sock' -> '/var/run/mysqld/mysqld.sock'
db_1   | 2025-04-15T09:03:44.076567Z 3 [Note] InnoDB: Stopping purge
db_1   | 2025-04-15T09:03:44.082476Z 3 [Note] InnoDB: Resuming purge
db_1   | 2025-04-15T09:03:44.084207Z 3 [Note] InnoDB: Stopping purge
db_1   | 2025-04-15T09:03:44.088225Z 3 [Note] InnoDB: Resuming purge
db_1   | 2025-04-15T09:03:44.091288Z 3 [Note] InnoDB: Stopping purge
db_1   | 2025-04-15T09:03:44.094811Z 3 [Note] InnoDB: Resuming purge
db_1   | 2025-04-15T09:03:44.097411Z 3 [Note] InnoDB: Stopping purge
db_1   | 2025-04-15T09:03:44.101296Z 3 [Note] InnoDB: Resuming purge
db_1   | Warning: Unable to load '/usr/share/zoneinfo/iso3166.tab' as time zone. Skipping it.
db_1   | Warning: Unable to load '/usr/share/zoneinfo/leapseconds' as time zone. Skipping it.
db_1   | Warning: Unable to load '/usr/share/zoneinfo/tzdata.zi' as time zone. Skipping it.
db_1   | Warning: Unable to load '/usr/share/zoneinfo/zone.tab' as time zone. Skipping it.
db_1   | Warning: Unable to load '/usr/share/zoneinfo/zone1970.tab' as time zone. Skipping it.
db_1   | 2025-04-15 09:03:46+00:00 [Note] [Entrypoint]: Creating database testdb
db_1   | 2025-04-15 09:03:46+00:00 [Note] [Entrypoint]: Creating user user
db_1   | 2025-04-15 09:03:46+00:00 [Note] [Entrypoint]: Giving user user access to schema testdb
db_1   |
db_1   | 2025-04-15 09:03:46+00:00 [Note] [Entrypoint]: /usr/local/bin/docker-entrypoint.sh: running /docker-entrypoint-initdb.d/init.sql
db_1   |
db_1   |
db_1   | 2025-04-15 09:03:46+00:00 [Note] [Entrypoint]: Stopping temporary server
db_1   | 2025-04-15T09:03:46.892066Z 0 [Note] Giving 0 client threads a chance to die gracefully
db_1   | 2025-04-15T09:03:46.892112Z 0 [Note] Shutting down slave threads
db_1   | 2025-04-15T09:03:46.892118Z 0 [Note] Forcefully disconnecting 0 remaining clients
db_1   | 2025-04-15T09:03:46.892122Z 0 [Note] Event Scheduler: Purging the queue. 0 events
db_1   | 2025-04-15T09:03:46.892153Z 0 [Note] Binlog end
db_1   | 2025-04-15T09:03:46.897382Z 0 [Note] Shutting down plugin 'ngram'
db_1   | 2025-04-15T09:03:46.897416Z 0 [Note] Shutting down plugin 'partition'
db_1   | 2025-04-15T09:03:46.897422Z 0 [Note] Shutting down plugin 'BLACKHOLE'
db_1   | 2025-04-15T09:03:46.897425Z 0 [Note] Shutting down plugin 'ARCHIVE'
db_1   | 2025-04-15T09:03:46.897427Z 0 [Note] Shutting down plugin 'PERFORMANCE_SCHEMA'
db_1   | 2025-04-15T09:03:46.897594Z 0 [Note] Shutting down plugin 'MRG_MYISAM'
db_1   | 2025-04-15T09:03:46.897604Z 0 [Note] Shutting down plugin 'MyISAM'
db_1   | 2025-04-15T09:03:46.897611Z 0 [Note] Shutting down plugin 'INNODB_SYS_VIRTUAL'
db_1   | 2025-04-15T09:03:46.897614Z 0 [Note] Shutting down plugin 'INNODB_SYS_DATAFILES'
db_1   | 2025-04-15T09:03:46.897616Z 0 [Note] Shutting down plugin 'INNODB_SYS_TABLESPACES'
db_1   | 2025-04-15T09:03:46.897618Z 0 [Note] Shutting down plugin 'INNODB_SYS_FOREIGN_COLS'
db_1   | 2025-04-15T09:03:46.897620Z 0 [Note] Shutting down plugin 'INNODB_SYS_FOREIGN'
db_1   | 2025-04-15T09:03:46.897622Z 0 [Note] Shutting down plugin 'INNODB_SYS_FIELDS'
db_1   | 2025-04-15T09:03:46.897624Z 0 [Note] Shutting down plugin 'INNODB_SYS_COLUMNS'
db_1   | 2025-04-15T09:03:46.897626Z 0 [Note] Shutting down plugin 'INNODB_SYS_INDEXES'
db_1   | 2025-04-15T09:03:46.897628Z 0 [Note] Shutting down plugin 'INNODB_SYS_TABLESTATS'
db_1   | 2025-04-15T09:03:46.897630Z 0 [Note] Shutting down plugin 'INNODB_SYS_TABLES'
db_1   | 2025-04-15T09:03:46.897632Z 0 [Note] Shutting down plugin 'INNODB_FT_INDEX_TABLE'
db_1   | 2025-04-15T09:03:46.897651Z 0 [Note] Shutting down plugin 'INNODB_FT_INDEX_CACHE'
db_1   | 2025-04-15T09:03:46.897653Z 0 [Note] Shutting down plugin 'INNODB_FT_CONFIG'
db_1   | 2025-04-15T09:03:46.897655Z 0 [Note] Shutting down plugin 'INNODB_FT_BEING_DELETED'
db_1   | 2025-04-15T09:03:46.897657Z 0 [Note] Shutting down plugin 'INNODB_FT_DELETED'
db_1   | 2025-04-15T09:03:46.897659Z 0 [Note] Shutting down plugin 'INNODB_FT_DEFAULT_STOPWORD'
db_1   | 2025-04-15T09:03:46.897661Z 0 [Note] Shutting down plugin 'INNODB_METRICS'
db_1   | 2025-04-15T09:03:46.897663Z 0 [Note] Shutting down plugin 'INNODB_TEMP_TABLE_INFO'
db_1   | 2025-04-15T09:03:46.897665Z 0 [Note] Shutting down plugin 'INNODB_BUFFER_POOL_STATS'
db_1   | 2025-04-15T09:03:46.897667Z 0 [Note] Shutting down plugin 'INNODB_BUFFER_PAGE_LRU'
db_1   | 2025-04-15T09:03:46.897669Z 0 [Note] Shutting down plugin 'INNODB_BUFFER_PAGE'
db_1   | 2025-04-15T09:03:46.897671Z 0 [Note] Shutting down plugin 'INNODB_CMP_PER_INDEX_RESET'
db_1   | 2025-04-15T09:03:46.897673Z 0 [Note] Shutting down plugin 'INNODB_CMP_PER_INDEX'
db_1   | 2025-04-15T09:03:46.897675Z 0 [Note] Shutting down plugin 'INNODB_CMPMEM_RESET'
db_1   | 2025-04-15T09:03:46.897677Z 0 [Note] Shutting down plugin 'INNODB_CMPMEM'
db_1   | 2025-04-15T09:03:46.897679Z 0 [Note] Shutting down plugin 'INNODB_CMP_RESET'
db_1   | 2025-04-15T09:03:46.897681Z 0 [Note] Shutting down plugin 'INNODB_CMP'
db_1   | 2025-04-15T09:03:46.897684Z 0 [Note] Shutting down plugin 'INNODB_LOCK_WAITS'
db_1   | 2025-04-15T09:03:46.897685Z 0 [Note] Shutting down plugin 'INNODB_LOCKS'
db_1   | 2025-04-15T09:03:46.897688Z 0 [Note] Shutting down plugin 'INNODB_TRX'
db_1   | 2025-04-15T09:03:46.897690Z 0 [Note] Shutting down plugin 'InnoDB'
db_1   | 2025-04-15T09:03:46.897891Z 0 [Note] InnoDB: FTS optimize thread exiting.
db_1   | 2025-04-15T09:03:46.898199Z 0 [Note] InnoDB: Starting shutdown...
db_1   | 2025-04-15T09:03:46.998386Z 0 [Note] InnoDB: Dumping buffer pool(s) to /var/lib/mysql/ib_buffer_pool
db_1   | 2025-04-15T09:03:46.998990Z 0 [Note] InnoDB: Buffer pool(s) dump completed at 250415  9:03:46
db_1   | 2025-04-15T09:03:47.925677Z 0 [Note] InnoDB: Shutdown completed; log sequence number 12226670
db_1   | 2025-04-15T09:03:47.930719Z 0 [Note] InnoDB: Removed temporary tablespace data file: "ibtmp1"
db_1   | 2025-04-15T09:03:47.930797Z 0 [Note] Shutting down plugin 'MEMORY'
db_1   | 2025-04-15T09:03:47.930809Z 0 [Note] Shutting down plugin 'CSV'
db_1   | 2025-04-15T09:03:47.930816Z 0 [Note] Shutting down plugin 'sha256_password'
db_1   | 2025-04-15T09:03:47.930820Z 0 [Note] Shutting down plugin 'mysql_native_password'
db_1   | 2025-04-15T09:03:47.931917Z 0 [Note] Shutting down plugin 'binlog'
db_1   | 2025-04-15T09:03:47.934762Z 0 [Note] mysqld: Shutdown complete
db_1   |
db_1   | 2025-04-15 09:03:48+00:00 [Note] [Entrypoint]: Temporary server stopped
db_1   |
db_1   | 2025-04-15 09:03:48+00:00 [Note] [Entrypoint]: MySQL init process done. Ready for start up.
db_1   |
db_1   | 2025-04-15T09:03:49.158569Z 0 [Warning] TIMESTAMP with implicit DEFAULT value is deprecated. Please use --explicit_defaults_for_timestamp server option (see documentation for more details).
db_1   | 2025-04-15T09:03:49.160806Z 0 [Note] mysqld (mysqld 5.7.44) starting as process 1 ...
db_1   | 2025-04-15T09:03:49.164867Z 0 [Note] InnoDB: PUNCH HOLE support available
db_1   | 2025-04-15T09:03:49.164907Z 0 [Note] InnoDB: Mutexes and rw_locks use GCC atomic builtins
db_1   | 2025-04-15T09:03:49.164928Z 0 [Note] InnoDB: Uses event mutexes
db_1   | 2025-04-15T09:03:49.164935Z 0 [Note] InnoDB: GCC builtin __atomic_thread_fence() is used for memory barrier
db_1   | 2025-04-15T09:03:49.164952Z 0 [Note] InnoDB: Compressed tables use zlib 1.2.13
db_1   | 2025-04-15T09:03:49.164954Z 0 [Note] InnoDB: Using Linux native AIO
db_1   | 2025-04-15T09:03:49.165379Z 0 [Note] InnoDB: Number of pools: 1
db_1   | 2025-04-15T09:03:49.165538Z 0 [Note] InnoDB: Using CPU crc32 instructions
db_1   | 2025-04-15T09:03:49.167765Z 0 [Note] InnoDB: Initializing buffer pool, total size = 128M, instances = 1, chunk size = 128M
db_1   | 2025-04-15T09:03:49.177645Z 0 [Note] InnoDB: Completed initialization of buffer pool
db_1   | 2025-04-15T09:03:49.181561Z 0 [Note] InnoDB: If the mysqld execution user is authorized, page cleaner thread priority can be changed. See the man page of setpriority().
db_1   | 2025-04-15T09:03:49.193188Z 0 [Note] InnoDB: Highest supported file format is Barracuda.
db_1   | 2025-04-15T09:03:49.202260Z 0 [Note] InnoDB: Creating shared tablespace for temporary tables
db_1   | 2025-04-15T09:03:49.202335Z 0 [Note] InnoDB: Setting file './ibtmp1' size to 12 MB. Physically writing the file full; Please wait ...
db_1   | 2025-04-15T09:03:49.223924Z 0 [Note] InnoDB: File './ibtmp1' size is now 12 MB.
db_1   | 2025-04-15T09:03:49.224687Z 0 [Note] InnoDB: 96 redo rollback segment(s) found. 96 redo rollback segment(s) are active.
db_1   | 2025-04-15T09:03:49.224697Z 0 [Note] InnoDB: 32 non-redo rollback segment(s) are active.
db_1   | 2025-04-15T09:03:49.225051Z 0 [Note] InnoDB: Waiting for purge to start
db_1   | 2025-04-15T09:03:49.275496Z 0 [Note] InnoDB: 5.7.44 started; log sequence number 12226670
db_1   | 2025-04-15T09:03:49.275946Z 0 [Note] InnoDB: Loading buffer pool(s) from /var/lib/mysql/ib_buffer_pool
db_1   | 2025-04-15T09:03:49.276186Z 0 [Note] Plugin 'FEDERATED' is disabled.
db_1   | 2025-04-15T09:03:49.281754Z 0 [Note] InnoDB: Buffer pool(s) load completed at 250415  9:03:49
db_1   | 2025-04-15T09:03:49.284754Z 0 [Note] Found ca.pem, server-cert.pem and server-key.pem in data directory. Trying to enable SSL support using them.
db_1   | 2025-04-15T09:03:49.284788Z 0 [Note] Skipping generation of SSL certificates as certificate files are present in data directory.
db_1   | 2025-04-15T09:03:49.284794Z 0 [Warning] A deprecated TLS version TLSv1 is enabled. Please use TLSv1.2 or higher.
db_1   | 2025-04-15T09:03:49.284797Z 0 [Warning] A deprecated TLS version TLSv1.1 is enabled. Please use TLSv1.2 or higher.
db_1   | 2025-04-15T09:03:49.285441Z 0 [Warning] CA certificate ca.pem is self signed.
db_1   | 2025-04-15T09:03:49.285484Z 0 [Note] Skipping generation of RSA key pair as key files are present in data directory.
db_1   | 2025-04-15T09:03:49.285855Z 0 [Note] Server hostname (bind-address): '*'; port: 3306
db_1   | 2025-04-15T09:03:49.285896Z 0 [Note] IPv6 is available.
db_1   | 2025-04-15T09:03:49.285910Z 0 [Note]   - '::' resolves to '::';
db_1   | 2025-04-15T09:03:49.285941Z 0 [Note] Server socket created on IP: '::'.
db_1   | 2025-04-15T09:03:49.288378Z 0 [Warning] Insecure configuration for --pid-file: Location '/var/run/mysqld' in the path is accessible to all OS users. Consider choosing a different directory.
db_1   | 2025-04-15T09:03:49.298312Z 0 [Note] Event Scheduler: Loaded 0 events
db_1   | 2025-04-15T09:03:49.298645Z 0 [Note] mysqld: ready for connections.
db_1   | Version: '5.7.44'  socket: '/var/run/mysqld/mysqld.sock'  port: 3306  MySQL Community Server (GPL)
web_1  | 192.168.80.1 - - [15/Apr/2025:09:04:23 +0000] "GET /index.php HTTP/1.1" 200 455 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36"
web_1  | 192.168.80.1 - - [15/Apr/2025:09:04:36 +0000] "GET /about.php HTTP/1.1" 200 456 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36"
web_1  | 192.168.80.1 - - [15/Apr/2025:09:04:48 +0000] "GET /dynamique.php HTTP/1.1" 200 402 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36"
Gracefully stopping... (press Ctrl+C again to force)
````
### Modification des messages
````

stage@srv24vide:~/dckr$ cat db/init.sql
CREATE TABLE messages (
  id INT AUTO_INCREMENT PRIMARY KEY,
  message VARCHAR(255) NOT NULL
);

INSERT INTO messages (message) VALUES ('Bonjour du conteneur MySQL!');
INSERT INTO messages (message) VALUES ('PHP connecté avec succès !');
INSERT INTO messages (message) VALUES ('En cas de panne: cass@tet.net');
stage@srv24vide:~/dckr$ cat apaphp/www/index.php
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Bienvenue</title>
</head>
<body>
    <h1>Bienvenue sur mon site !</h1>
    <p>Ce message est généré avec PHP</p>
    <p>Mais il ne contient que du html!</p>
</body>
</html>

````

### Validation des changements
````
stage@srv24vide:~/dckr$ docker-compose start -d
Start existing containers.

Usage: start [SERVICE...]
stage@srv24vide:~/dckr$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
stage@srv24vide:~/dckr$ docker-compose stop
stage@srv24vide:~/dckr$ docker-compose start
Starting db  ... done
Starting web ... done
stage@srv24vide:~/dckr$ docker ps
CONTAINER ID   IMAGE       COMMAND                  CREATED          STATUS          PORTS                                   NAMES
170e835610e1   dckr_web    "docker-php-entrypoi…"   39 minutes ago   Up 30 seconds   0.0.0.0:8080->80/tcp, :::8080->80/tcp   dckr_web_1
86c7b624f5e8   mysql:5.7   "docker-entrypoint.s…"   39 minutes ago   Up 31 seconds   3306/tcp, 33060/tcp                     dckr_db_1
stage@srv24vide:~/dckr$ docker-compose stop
Stopping dckr_web_1 ... done
Stopping dckr_db_1  ... done
````
### Refabrication des conteneurs pour mise à jour BDD
````
stage@srv24vide:~/dckr$ docker-compose down -v
Removing dckr_web_1 ... done
Removing dckr_db_1  ... done
Removing network dckr_default
stage@srv24vide:~/dckr$ docker-compose up --build
Creating network "dckr_default" with the default driver
Building web
DEPRECATED: The legacy builder is deprecated and will be removed in a future release.
            Install the buildx component to build images with BuildKit:
            https://docs.docker.com/go/buildx/

Sending build context to Docker daemon  5.632kB
Step 1/3 : FROM php:7.4-apache
 ---> 20a3732f422b
Step 2/3 : RUN a2enmod rewrite
 ---> Using cache
 ---> 87f77400a35c
Step 3/3 : RUN docker-php-ext-install mysqli
 ---> Using cache
 ---> 430121f95ecd
Successfully built 430121f95ecd
Successfully tagged dckr_web:latest
Creating dckr_db_1 ... done
Creating dckr_web_1 ... done
Attaching to dckr_db_1, dckr_web_1

````


````
blabla
````
