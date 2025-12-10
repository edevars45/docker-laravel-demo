FROM php:8.4-apache

# 1) Paquets système : git, unzip, client MySQL, dépendances pour zip, xml, et mbstring
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    default-mysql-client \
    libzip-dev \
    libxml2-dev \
    libonig-dev \
    && rm -rf /var/lib/apt/lists/*

# 2) Extensions PHP utiles pour Laravel
RUN docker-php-ext-install \
    bcmath \
    ctype \
    fileinfo \
    pdo \
    pdo_mysql \
    xml \
    mbstring \
    zip

# 3) Node.js + npm (Node 24)
RUN apt-get update && apt-get install -y curl \
    && curl -fsSL https://deb.nodesource.com/setup_24.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# 4) Module rewrite d'Apache
RUN a2enmod rewrite

# 5) VirtualHost pour Laravel
COPY vhost.conf /etc/apache2/sites-available/000-default.conf

# 6) Installer Composer depuis l'image officielle
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 7) Dossier de travail (bind mount avec ./src)
WORKDIR /var/www/html

# 8) Entrypoint
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]