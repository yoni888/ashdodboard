FROM php:8.2-apache

# Устанавливаем системные зависимости
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    zip \
    unzip \
    curl \
    git \
    && docker-php-ext-install pdo pdo_mysql mbstring xml zip \
    && a2enmod rewrite

# Устанавливаем рабочую директорию
WORKDIR /var/www/html

# Копируем проект
COPY . /var/www/html

# Создаём нужные папки Laravel (ВАЖНО)
RUN mkdir -p storage bootstrap/cache

# Назначаем права ПОСЛЕ копирования
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 775 storage bootstrap/cache

# Настраиваем Apache под Laravel public
RUN sed -i 's|/var/www/html|/var/www/html/public|g' /etc/apache2/sites-available/000-default.conf

EXPOSE 80
