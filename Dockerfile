# Stage 1: PHP base with Composer installation
FROM php:8.3-fpm AS php-stage
ENV PHP_VERSION=8.3

# Set up PHP environment and install Composer
WORKDIR /var/www/html
EXPOSE 9000
ENTRYPOINT ["docker-php-entrypoint"]
CMD ["php-fpm"]

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set up Drupal environment
ENV DRUPAL_VERSION=10.3
WORKDIR /opt/drupal
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/drupal/vendor/bin

# Stage 2: Node.js for frontend assets or additional JS functionality
FROM node:20-bullseye AS node-stage

# Ensure Node.js and npm are installed correctly
RUN node --version && npm --version

# Install necessary build tools and Node.js dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    python3 \
    curl \
    gnupg \
    && apt-get install -y nodejs \
    && apt-get clean

# Optional: Set environment variables or perform additional setup
RUN export PIPELINES_ENV=PIPELINES_ENV

# Stage 3: Combine PHP and Node.js in the final image
FROM php-stage

# Copy Node.js dependencies from the node-stage (if necessary)
COPY --from=node-stage /usr/local /usr/local

# Expose the appropriate ports
CMD ["node"]
