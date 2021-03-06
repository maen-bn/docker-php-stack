# elephant-whale
## A tool to help your PHP, NGINX, MariaDB based application into Docker

### What is provided

* PHP (7.1 & 5.6)
  - FPM & CLI
* NGINX
* MariaDB 10.1 or MySQL 5.7
* Redis
* Beanstalkd
* Composer
* Node
  - With NPM and Yarn

### Requirements

* Docker
* Docker Compose

The helper shell scripts require having bash. This is available with most OSs e.g. Linux, macOS, Windows 10 etc. If you're running an older version of Windows, using something like Git Bash can work too.

### Setup

First grab and extract the latest [release](https://github.com/maen-bn/elephant-whale/releases).

The run the setup script and then bring up the containers e.g.

```bash
$ ./setup.sh
$ docker-compose up -d
```

### Helper scripts

There are some helper scripts available so you can run the cli of ```php```,  ```composer```, and ```yarn``` via the containers that are made available e.g.

```bash
$ ./php.sh my-script.php
$ ./composer.sh update
$ ./yarn.sh add vue --save
```

You can also add these scripts contents to your .bashrc file so it can be used globally