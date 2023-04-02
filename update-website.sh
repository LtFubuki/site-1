#!/bin/bash

# Set variables
REPO_URL="https://github.com/LtFubuki/dads-site"
WEB_DIR="web"
TEMP_DIR="temp_update"
NGINX_HTML_DIR="html"

# Create the temp directory if it doesn't exist
mkdir -p ${TEMP_DIR}

# Download the web files to the temp dir
wget -q --show-progress --recursive --no-parent --no-clobber --no-check-certificate --directory-prefix=${TEMP_DIR} ${REPO_URL}/raw/main/${WEB_DIR}/

# Compare and update the web files if there's a change
if ! rsync -rucn --exclude '.git' ${TEMP_DIR}raw/main/${WEB_DIR}/ ${NGINX_HTML_DIR}/ | grep -q '^'; then
    echo "Updating website..."
    
    # Update the web files
    rsync -ruc --exclude '.git' ${TEMP_DIR}raw/main/${WEB_DIR}/ ${NGINX_HTML_DIR}/

    # Restart the web container to apply the changes
    docker-compose restart web
else
    echo "Website is up to date."
fi

# Remove the temp directory
rm -rf ${TEMP_DIR}
