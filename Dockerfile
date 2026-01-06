
FROM php:8.2-apache

# Системные пакеты
RUN apt-get update && apt-get install -y \
    git unzip libzip-dev libpng-dev libonig-dev libxml2-dev \
    && docker-php-ext-install pdo_mysql zip mbstring exif pcntl bcmath gd

# Apache
RUN a2enmod rewrite

# Рабочая директория
WORKDIR /var/www/html

# Копируем проект
COPY . /var/www/html

# Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Устанавливаем зависимости БЕЗ artisan
RUN composer install --no-dev --no-interaction --prefer-dist || true

# Права (БЕЗ chmod storage!)
RUN chown -R www-data:www-data /var/www/html

# Apache config
RUN sed -i 's|/var/www/html|/var/www/html/public|g' /etc/apache2/sites-available/000-default.conf

EXPOSE 80
