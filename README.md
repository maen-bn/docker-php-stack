# elephant-whale
## Dockerized PHP, NGINX, MySQL based environment

### What is provided

* PHP (7.1)
  - FPM & CLI
* NGINX
* MySQL
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

Run the following within the root of the directory

```bash
$ docker-compose up --build -d
```

### Helper scripts

There are some helper scripts available so you can run the cli of ```php```,  ```composer```, and ```yarn``` via the containers that are made available e.g.

```bash
$ ./php.sh my-script.php
$ ./composer.sh update
$ ./yarn.sh add vue --save
```

