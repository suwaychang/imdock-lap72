FROM centos:centos7
MAINTAINER Suwy Chang<solzxeramdj@gmail.com>

ENV SSH_PASSWORD=P@ssw0rd

# Setting DateTime Zone
RUN cp -p /usr/share/zoneinfo/Asia/Taipei /etc/localtime

#import Key
RUN rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY*

#Install Tools
RUN yum -y install nano wget tar epel-release
RUN yum -y groupinstall development
RUN yum -y install perl-CPAN zlib zlib-devel curl-devel

#Install php 7.2.0
RUN rpm -Uvh http://rpms.remirepo.net/enterprise/remi-release-7.rpm
RUN yum -y install yum-utils
RUN yum -y update
RUN yum-config-manager --enable remi-php72
RUN yum -y install php php-opcache php-fpm php-mbstring php-xml php-mysql php-pdo php-gd php-pecl-imagick php-pecl-memcache php-intl php-pecl-xdebug php-mssql php-mcrypt  php-pecl-zip

# Install Apache
RUN yum -y install httpd

# Ensure that PHP7 FPM is run as root.
RUN sed -i -e 's/user = apache/user = nginx/' /etc/php-fpm.d/www.conf
RUN sed -i -e 's/group = apache/group = nginx/' /etc/php-fpm.d/www.conf
RUN mv /etc/php.d/15-xdebug.ini /etc/php.d/15-xdebug.ini.disable

# Setting Composer
RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer && \
    echo 'export PATH="/root/.composer/vendor/bin:$PATH"' >> /root/.bashrc

# Install Supervisor
RUN yum -y install supervisor

# Install crontab service
RUN yum -y install vixie-cron crontabs
RUN sed -ie '/pam_loginuid/d' /etc/pam.d/crond


# Install SSH Service
RUN yum install -y openssh-server passwd
RUN sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config && \
    echo "${SSH_PASSWORD}" | passwd "root" --stdin && \
    ssh-keygen -q -t rsa -N '' -f /etc/ssh/ssh_host_rsa_key && \
    ssh-keygen -q -t dsa -N '' -f  /etc/ssh/ssh_host_dsa_key && \
    ssh-keygen -q -t ecdsa -N '' -f /etc/ssh/ssh_host_ecdsa_key


# Install Git
RUN wget https://www.kernel.org/pub/software/scm/git/git-2.12.3.tar.gz && \
    tar zxf git-2.12.3.tar.gz && \
    cd git-2.12.3 && \
    ./configure && \
    make && \
    make prefix=/usr/local install && \
    echo "export PATH=$PATH:/usr/local/git/bin" >> /etc/bashrc && \
    source /etc/bashrc


# Delete Install data-info
RUN yum clean all && rm -f /var/log/yum.log


# Add configuration files
COPY conf/supervisord.conf /etc/supervisor/supervisord.conf
COPY conf/www.conf /etc/php-fpm.d/www.conf


VOLUME ["/var/www"]

EXPOSE 22 80 443 9000

# Executing supervisord
# -n / --nodaemon : runs in foreground ( required for docker )
# -c <configfile> : specifies the config file
ENTRYPOINT /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
