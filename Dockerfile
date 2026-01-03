FROM php:8.2-apache

# Устанавливаем системные зависимости
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libzip-dev \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    && docker-php-ext-install pdo pdo_mysql zip mbstring exif pcntl bcmath gd

# Включаем mod_rewrite
RUN a2enmod rewrite

# Рабочая папка
WORKDIR /var/www/html

# Копируем ВСЁ из репозитория
COPY . /var/www/html

# Устанавливаем Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Устанавливаем зависимости Laravel
RUN composer install --no-dev --optimize-autoloader

# Права доступа (БЕЗ chown — важно для Render)
RUN chmod -R 775 storage bootstrap/cache || true

# DocumentRoot → public
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri 's!/var/www/html!/var/www/html/public!g' /etc/apache2/sites-available/*.conf

# Порт Render
EXPOSE 10000

# Запуск Apache
CMD ["apache2-foreground"]
