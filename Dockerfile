# Base image: PHP with Drupal and FPM
FROM drupal:php8.3-fpm

# Set the PHP version as an environment variable
ENV PHP_VERSION=8.3

# Update and install required packages, including MariaDB client and PHP extensions
RUN apt-get update && apt-get install -y \
    rsync \
    git \
    libpng-dev \
    libjpeg-dev \
    libxml2-dev \
    zlib1g-dev \
    libzip-dev \
    zip \
    unzip \
    mariadb-client \
    build-essential \
    python3 \
    curl \
    && docker-php-ext-install soap gd zip \
    && apt-get clean

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Node.js (using the official Node.js binary distribution for the latest version)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

# Ensure Node.js and npm are available
RUN npm install -g npm

# Copy the project files into the container (if required)
# COPY . /app

# Example: If there's a composer.json, run Composer install (PHP dependencies)
# RUN composer install

# Example: If there's a package.json, run npm install (Node.js dependencies)
# COPY package*.json ./
# RUN npm install

# Expose the port used by PHP-FPM
EXPOSE 9000

# Define the default command (if you want to run a specific PHP/Node command)
CMD ["php"]
