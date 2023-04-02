#!/bin/bash

# Set variables
LOCAL_DIR="/path/to/local/repo"
NGINX_HTML_DIR="./html"

# Check for updates
cd \$LOCAL_DIR
git remote update

if ! git status -uno | grep -q 'Your branch is up to date'; then
    echo "Updating website..."
    git pull

    # Copy the updated files to the Nginx HTML directory
    cp -R \$LOCAL_DIR/html/* \$NGINX_HTML_DIR

    # Restart the web container to apply the changes
    docker-compose restart web
else
    echo "Website is up to date."
fi