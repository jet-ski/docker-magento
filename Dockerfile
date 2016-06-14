FROM php:7-fpm-alpine


RUN apk upgrade --update && apk add \
  autoconf file g++ gcc binutils isl libatomic libc-dev musl-dev make re2c libstdc++ libgcc binutils-libs mpc1 mpfr3 gmp libgomp \
  coreutils freetype-dev libjpeg-turbo-dev libltdl libmcrypt-dev libpng-dev icu-dev libxslt-dev 

RUN docker-php-ext-install iconv mcrypt iconv intl mcrypt mysqli mysqlnd pdo pdo_mysql xsl zip \
  && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
  && docker-php-ext-install gd \
  && apk del autoconf file g++ gcc binutils isl libatomic libc-dev musl-dev make re2c libstdc++ libgcc binutils-libs mpc1 mpfr3 gmp libgomp \
  && rm -rf /var/cache/apk/*



WORKDIR /tmp

ENV MAGENTO_VERSION 2.0.7
RUN curl -sS https://codeload.github.com/magento/magento2/tar.gz/${MAGENTO_VERSION} -o magento-${MAGENTO_VERSION}.tar.gz \
    && mkdir -p /opt && tar -zxf magento-${MAGENTO_VERSION}.tar.gz -C /opt
  

WORKDIR /opt/magento2-${MAGENTO_VERSION}/

#rmdir magento2-2.0.0/
#touch auth.json
#[ edit with auth.json ]
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer  && composer install
RUN php bin/magento sampledata:deploy
#php bin/magento setup:upgrade <-- may not work due to missing app/etc/config.php and env.php

RUN php bin/magento setup:install --base-url=http://magento200.dev/ \
--db-host=localhost \
--db-name=magento200 \
--db-user=root \
--db-password=root \
--admin-firstname=Raj \
--admin-lastname=KB \
--admin-email=myemail@gmail.com \
--admin-user=admin \
--admin-password=pass123 \
--language=en_US \
--currency=USD \
--timezone=America/Chicago \
--sales-order-increment-prefix="ORD$" \
--session-save=db \
--use-rewrites=1 \
--use-sample-data \
--cleanup-database





