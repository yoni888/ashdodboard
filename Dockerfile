# ---- Base image ----
FROM php:8.2-apache

# ---- System dependencies ----
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    zip \
    curl \
    && docker-php-ext-install \
    pdo \
    pdo_mysql \
    mbstring \
    exif \
    pcntl \
    bcmath \
    gd \
    zip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# ---- Enable Apache rewrite ----
RUN a2enmod rewrite

# ---- Set working directory ----
WORKDIR /var/www/html

# ---- Copy project ----
COPY . /var/www/html

# ---- Apache config for Laravel ----
RUN sed -i 's|/var/www/html|/var/www/html/public|g' /etc/apache2/sites-available/000-default.conf

# ---- Permissions ----
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# ---- Expose port ----
EXPOSE 80

# ---- Start Apache ----
CMD ["apache2-foreground"]
