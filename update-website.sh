#!/bin/bash

# Set variables
REPO_URL="https://github.com/LtFubuki/site-1/archive/refs/heads/main.zip"
TEMP_DIR="temp_update"
NGINX_HTML_DIR="html"

# Create the temp directory if it doesn't exist
mkdir -p ${TEMP_DIR}

# Download the repository zip file
wget -q --show-progress --no-check-certificate -O ${TEMP_DIR}/main.zip ${REPO_URL}

# Unzip the repository files
unzip -qo ${TEMP_DIR}/main.zip -d ${TEMP_DIR}

# Compare and update the web files if there's a change
if ! rsync -rucn --exclude '.git' ${TEMP_DIR}/site-1-main/web/ ${NGINX_HTML_DIR}/ | grep -q '^'; then
    echo "Updating website..."
    
    # Update the web files
    rsync -ruc --exclude '.git' ${TEMP_DIR}/site-1-main/web/ ${NGINX_HTML_DIR}/

    # Restart the web container to apply the changes
    docker-compose restart web
else
    echo "Website is up to date."
fi

# Remove the temp directory
rm -rf ${TEMP_DIR}
