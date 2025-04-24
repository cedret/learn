
https://www.youtube.com/watch?v=7e_mjVUV-zA

https://www.youtube.com/watch?v=V9VNQBEPFn0

https://www.youtube.com/watch?v=jswJLTm8FOo

### Node.js
https://www.youtube.com/watch?v=bKSh1gEZe2I&list=PL5dpzLb9u7J2QpigtDDfhs3ziUhrM3b-l&index=6

https://www.youtube.com/watch?v=i5oU38ejlfI

### Github's ssh
https://www.youtube.com/watch?v=P56Kuk6XePY

### IAM
testeur//

### Site EC2
http://51.21.249.195/

### Site S3
https://cedrik1bucket.s3.eu-north-1.amazonaws.com/index.html

north europe 1c

identifiant:
admin//
4zcWLJHsYxy1tsYVkoko

endpoint:
myapp1database.cfsqamwuwe6v.eu-north-1.rds.amazonaws.com

myapp1database.cfsqamwuwe6v.eu-north-1.rds.amazonaws.com

port 3306

vpc-0f478a12b7036a247

https://www.youtube.com/watch?v=jswJLTm8FOo

mysql -h [VOTRE-ENDPOINT-RDS] -P 3306 -u admin -p

mysql -h myapp1database.cfsqamwuwe6v.eu-north-1.rds.amazonaws.com -P 3306 -u admin -p

````
   ,     #_
   ~\_  ####_        Amazon Linux 2023
  ~~  \_#####\
  ~~     \###|
  ~~       \#/ ___   https://aws.amazon.com/linux/amazon-linux-2023
   ~~       V~' '->
    ~~~         /
      ~~._.   _/
         _/ _/
       _/m/'
Last login: Wed Apr 23 12:20:54 2025 from 94.247.164.57
[ec2-user@ip-172-31-31-2 ~]$ ls
[ec2-user@ip-172-31-31-2 ~]$ sudo su - root
Last login: Wed Apr 23 12:26:41 UTC 2025 on pts/1
[root@ip-172-31-31-2 ~]# yum update
Last metadata expiration check: 6:50:44 ago on Wed Apr 23 12:26:20 2025.
Dependencies resolved.
Nothing to do.
Complete!
[root@ip-172-31-31-2 ~]# yum install mariadb105 -y
Last metadata expiration check: 6:51:21 ago on Wed Apr 23 12:26:20 2025.
Dependencies resolved.
[root@ip-172-31-31-2 ~]# mysql -h myapp1database.cfsqamwuwe6v.eu-north-1.rds.amazonaws.com -P 3306 -u admin -p
Enter password: 
ERROR 2002 (HY000): Can't connect to MySQL server on 'myapp1database.cfsqamwuwe6v.eu-north-1.rds.amazonaws.com' (115)
[root@ip-172-31-31-2 ~]# mysql -h myapp1database.cfsqamwuwe6v.eu-north-1.rds.amazonaws.com -P 3306 -u admin -p
Enter password: 
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MySQL connection id is 33
Server version: 8.0.32 Source distribution

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MySQL [(none)]> 
````
CREATE TABLE users ( id INT AUTO_INCREMENT PRIMARY KEY, username VARCHAR(50) NOT NULL, email VARCHAR(100) NOT NULL, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);

INSERT INTO users (username, email) VALUES ('john_doe', 'john@example.com'), ('jane_doe', 'jane@example.com'), ('bob_smith', 'bob@example.com');
````
[root@ip-172-31-31-2 ~]# mysql -h myapp1database.cfsqamwuwe6v.eu-north-1.rds.amazonaws.com -P 3306 -u admin -p
Enter password: 
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MySQL connection id is 232
Server version: 8.0.32 Source distribution

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MySQL [(none)]> CREATE DATABASE webappdb;
Query OK, 1 row affected (0.030 sec)

MySQL [(none)]> USE webappdb;
Database changed
MySQL [webappdb]> CREATE TABLE users ( id INT AUTO_INCREMENT PRIMARY KEY, username VARCHAR(50) NOT NULL, email VARCHAR(100) NOT NULL, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
Query OK, 0 rows affected (0.086 sec)

MySQL [webappdb]> INSERT INTO users (username, email) VALUES ('john_doe', 'john@example.com'), ('jane_doe', 'jane@example.com'), ('bob_smith', 'bob@example.com');
Query OK, 3 rows affected (0.009 sec)
Records: 3  Duplicates: 0  Warnings: 0

MySQL [webappdb]> SELECT * FROM users;
+----+-----------+------------------+---------------------+
| id | username  | email            | created_at          |
+----+-----------+------------------+---------------------+
|  1 | john_doe  | john@example.com | 2025-04-24 12:59:43 |
|  2 | jane_doe  | jane@example.com | 2025-04-24 12:59:43 |
|  3 | bob_smith | bob@example.com  | 2025-04-24 12:59:43 |
+----+-----------+------------------+---------------------+
3 rows in set (0.001 sec)

MySQL [webappdb]> exit
Bye
````
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

. ~/.nvm/nvm.sh
```
[root@ip-172-31-31-2 ~]# curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 14984  100 14984    0     0  82329      0 --:--:-- --:--:-- --:--:-- 82784
=> Downloading nvm as script to '/root/.nvm'

=> Appending nvm source string to /root/.bashrc
=> Appending bash_completion source string to /root/.bashrc
=> Close and reopen your terminal to start using nvm or run the following to use it now:

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
[root@ip-172-31-31-2 ~]# . ~/.nvm/nvm.sh
[root@ip-172-31-31-2 ~]# nvm install 16
Downloading and installing node v16.20.2...
Downloading https://nodejs.org/dist/v16.20.2/node-v16.20.2-linux-x64.tar.xz...
###################################################################################################################################### 100.0%
Computing checksum with sha256sum
Checksums matched!
Now using node v16.20.2 (npm v8.19.4)
Creating default alias: default -> 16 (-> v16.20.2)
[root@ip-172-31-31-2 ~]# nvm use 16
Now using node v16.20.2 (npm v8.19.4)
````
````
[root@ip-172-31-31-2 ~]# mkdir myapp
[root@ip-172-31-31-2 ~]# cd myapp
[root@ip-172-31-31-2 myapp]# npm init
This utility will walk you through creating a package.json file.
It only covers the most common items, and tries to guess sensible defaults.

See `npm help init` for definitive documentation on these fields
and exactly what they do.

Use `npm install <pkg>` afterwards to install a package and
save it as a dependency in the package.json file.

Press ^C at any time to quit.
package name: (myapp) 
version: (1.0.0) 
description: 
entry point: (index.js) 
test command: 
git repository: 
keywords: 
author: 
license: (ISC) 
About to write to /root/myapp/package.json:

{
  "name": "myapp",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "author": "",
  "license": "ISC"
}


Is this OK? (yes) yes
npm notice 
npm notice New major version of npm available! 8.19.4 -> 11.3.0
npm notice Changelog: https://github.com/npm/cli/releases/tag/v11.3.0
npm notice Run npm install -g npm@11.3.0 to update!
npm notice 
[root@ip-172-31-31-2 myapp]# npm init -y
Wrote to /root/myapp/package.json:

{
  "name": "myapp",
  "version": "1.0.0",
  "main": "index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "author": "",
  "license": "ISC",
  "keywords": [],
  "description": ""
}

[root@ip-172-31-31-2 myapp]# npm install express mysql2 dotenv
npm WARN EBADENGINE Unsupported engine {
npm WARN EBADENGINE   package: 'express@5.1.0',
npm WARN EBADENGINE   required: { node: '>= 18' },
npm WARN EBADENGINE   current: { node: 'v16.20.2', npm: '8.19.4' }
npm WARN EBADENGINE }
npm WARN EBADENGINE Unsupported engine {
npm WARN EBADENGINE   package: 'body-parser@2.2.0',
npm WARN EBADENGINE   required: { node: '>=18' },
npm WARN EBADENGINE   current: { node: 'v16.20.2', npm: '8.19.4' }
npm WARN EBADENGINE }
npm WARN EBADENGINE Unsupported engine {
npm WARN EBADENGINE   package: 'merge-descriptors@2.0.0',
npm WARN EBADENGINE   required: { node: '>=18' },
npm WARN EBADENGINE   current: { node: 'v16.20.2', npm: '8.19.4' }
npm WARN EBADENGINE }
npm WARN EBADENGINE Unsupported engine {
npm WARN EBADENGINE   package: 'router@2.2.0',
npm WARN EBADENGINE   required: { node: '>= 18' },
npm WARN EBADENGINE   current: { node: 'v16.20.2', npm: '8.19.4' }
npm WARN EBADENGINE }
npm WARN EBADENGINE Unsupported engine {
npm WARN EBADENGINE   package: 'send@1.2.0',
npm WARN EBADENGINE   required: { node: '>= 18' },
npm WARN EBADENGINE   current: { node: 'v16.20.2', npm: '8.19.4' }
npm WARN EBADENGINE }
npm WARN EBADENGINE Unsupported engine {
npm WARN EBADENGINE   package: 'serve-static@2.2.0',
npm WARN EBADENGINE   required: { node: '>= 18' },
npm WARN EBADENGINE   current: { node: 'v16.20.2', npm: '8.19.4' }
npm WARN EBADENGINE }

added 78 packages, and audited 79 packages in 3s

16 packages are looking for funding
  run `npm fund` for details

found 0 vulnerabilities
[root@ip-172-31-31-2 myapp]# cat server.js 
require('dotenv').config();
const express = require('express');
const mysql = require('mysql2/promise');
const app = express();

const pool = mysql.createPool({
 host: 'myapp1database.cfsqamwuwe6v.eu-north-1.rds.amazonaws.com',
 user: 'admin',
 password: 'cp4zcWLJHsYxy1tsYV5o',
 database: 'webappdb'
});

app.get('/', async (req, res) => {
 try {
 const [rows] = await pool.query('SELECT * FROM users');
 res.send(`
 <h1>Liste des utilisateurs</h1>
 ${rows.map(user => `
 <div>
 <p>Utilisateur : ${user.username}</p>
 <p>Email : ${user.email}</p>
 </div>
 `).join('')}
 `);
 } catch (error) {
 console.error(error);
 res.status(500).send('Erreur serveur');
 }
});

app.listen(3000, () => {
 console.log('Serveur en cours d\'exécution sur le port 3000');
});
[root@ip-172-31-31-2 myapp]# node server.js &
[1] 68277
[root@ip-172-31-31-2 myapp]# Serveur en cours d'exécution sur le port 3000
````
### Depuis second terminal

````
   ,     #_
   ~\_  ####_        Amazon Linux 2023
  ~~  \_#####\
  ~~     \###|
  ~~       \#/ ___   https://aws.amazon.com/linux/amazon-linux-2023
   ~~       V~' '->
    ~~~         /
      ~~._.   _/
         _/ _/
       _/m/'
Last login: Thu Apr 24 12:56:12 2025 from 13.48.4.202
[ec2-user@ip-172-31-31-2 ~]$ 
[ec2-user@ip-172-31-31-2 ~]$ sudo su - root
Last login: Thu Apr 24 12:56:26 UTC 2025 on pts/1
[root@ip-172-31-31-2 ~]# ps aux | grep node
root         777  0.0  0.0      0     0 ?        I<   Apr23   0:00 [xfs-inodegc/nvm]
root       68277  0.0  5.5 698104 51248 pts/1    Sl   13:21   0:00 node server.js
root       69390  0.0  0.2 222316  2196 pts/3    S+   13:29   0:00 grep --color=auto node
[root@ip-172-31-31-2 ~]# kill 68277
[root@ip-172-31-31-2 ~]# poweroff

Broadcast message from root@ip-172-31-31-2.eu-north-1.compute.internal on pts/3 (Thu 2025-04-24 13:32:05 UTC):

The system will power off now!
````
