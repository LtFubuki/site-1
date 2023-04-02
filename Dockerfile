# Stage 1: Build the Nginx image with the website files
FROM nginx:alpine AS builder

# Set working directory
WORKDIR /usr/share/nginx/html

# Install necessary tools
RUN apk add --no-cache wget unzip

# Download the GitHub repository and extract the 'web' folder
RUN wget -q https://github.com/LtFubuki/site-1/archive/refs/heads/main.zip && \
    unzip main.zip && \
    cp -r site-1-main/web/* . && \
    rm -rf main.zip site-1-main

# Stage 2: Configure SSL using Certbot
FROM certbot/certbot:latest AS certbot

# Set the domain and email
ENV DOMAIN alicam.org
ENV EMAIL your-email@example.com

# Obtain an SSL certificate from Let's Encrypt
RUN certbot certonly --standalone --non-interactive --agree-tos --email $EMAIL -d $DOMAIN --preferred-challenges http-01

# Stage 3: Final stage, copy the necessary files from previous stages
FROM nginx:alpine

# Copy the website files from the builder stage
COPY --from=builder /usr/share/nginx/html /usr/share/nginx/html

# Copy SSL certificates from the certbot stage
COPY --from=certbot /etc/letsencrypt/live/$DOMAIN /etc/letsencrypt/live/$DOMAIN

# Set working directory
WORKDIR /etc/nginx

# Remove the default Nginx configuration file
RUN rm conf.d/default.conf

# Add the Nginx configuration file
COPY nginx.conf conf.d/

# Expose ports 80 and 443
EXPOSE 80 443

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]
