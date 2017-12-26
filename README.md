imdock-lap72
====================================================

## What's this:

Centos(Apache2.4.6 + PHP7.2)

  * you can easy install PHP Framework (ex: Laravel、Synfony)

  * this project use management by docker-compose

  * you can use this for Laravel-5 PHP Framework


## How to install:

    ~ $ mkdir {project-name}
    ~ $ cd {project-name}
    ~/{project-name} $ git clone https://github.com/suwaychang/imdock-lap72.git
    ~/{project-name} $ cd imdock-lap72


#### change your custom settting (container_name: {project-name})

    ~/{project-name}/imdock-lap72 $ vim ./docker-compose-yml
    ~/{project-name}/imdock-lap72 $ docker-compose up

#### open browser, testing your host-ip, see the phpinfo is success! ctrl+c close this
#### now, you can move the your project to website dir

    ~/{project-name}/imdock-cap56 $ vim ./site-enable/default.conf

#### setting your custom apache config (volumes: ./website:/var/www → ../{project-dir}:/var/www)

    ~/{project-name}/imdock-lap72 $ vim ./docker-compose-yml
    ~/{project-name}/imdock-lap72 $ vim ./conf/apache.conf
    ~/{project-name}/imdock-lap72 $ docker-compose up -d


## Reference architecture:

```txt
{project-name}
├── imdock-lap72
│   ├── conf/
│   ├── sites-enable/(apache website setting)
│   ├── website(sample phpinfo)
│   ├── Dockerfile
│   └── docker-compose.yml
└── {project-dir}
    └── ...
```

## How to and other docker-compose use the same network :

    #if you not have group network, you can create this, and other docker-compose use this network setting
    ~ $ docker network create --driver bridge imdockgroup


## How to change setting:

  * You just look at this directory you will understand (config/*)

  * When the settings are complete, restart the container

## PHP Extend:
- [x] PHP7.2
  - [x] mbstring
  - [x] mcrypt
  - [x] php-dom, php-domxml, php-wddx, php-xsl
  - [x] php-mysqli, php_database
  - [ ] mongodb
  - [ ] redis
  - [ ] pgsql
  - [x] php-mssql
  - [x] php-pdo_sqlite, php-sqlite3
  - [ ] apcu
  - [x] gd
  - [ ] imap
  - [x] imagick
  - [x] zend-opcache
  - [x] memcache
  - [x] xdebug
