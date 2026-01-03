FROM php:8.2-apache

# Системные зависимости
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libzip-dev \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    && docker-php-ext-install pdo pdo_mysql zip mbstring exif pcntl bcmath gd

# Apache rewrite
RUN a2enmod rewrite

# Рабочая папка
WORKDIR /var/www/html

# Копируем проект
COPY . /var/www/html

# Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# 🔴 ВАЖНО: запрещаем запуск artisan во время composer install
ENV COMPOSER_ALLOW_SUPERUSER=1
RUN composer install --no-dev --no-scripts --optimize-autoloader

# Права (без chown — Render не разрешает)
RUN chmod -R 775 storage bootstrap/cache || true

# Apache public
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri 's!/var/www/html!/var/www/html/public!g' /etc/apache2/sites-available/*.conf

EXPOSE 10000
CMD ["apache2-foreground"]
