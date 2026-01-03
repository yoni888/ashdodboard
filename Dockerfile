FROM php:8.2-apache

# Включаем mod_rewrite (нужно для Laravel)
RUN a2enmod rewrite

# Устанавливаем системные зависимости
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libzip-dev \
    && docker-php-ext-install zip pdo pdo_mysql

# Устанавливаем Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Рабочая папка
WORKDIR /var/www/html

# Копируем проект
COPY . .

# Устанавливаем зависимости Laravel
RUN composer install --no-dev --optimize-autoloader

# Права
RUN chown -R www-data:www-data /var/www/html \
    &&
