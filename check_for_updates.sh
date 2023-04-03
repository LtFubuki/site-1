#!/bin/bash

# Set repository URL and local directories
REPO_URL="https://github.com/LtFubuki/site-1/archive/refs/heads/main.zip"
LOCAL_DIR="/home/pi/site-1"
LOCAL_WEB_DIR="${LOCAL_DIR}/web"
TMP_DIR="/tmp/site-1-main"
COMPOSE_DIR="/home/pi/site-1"

# Create the local 'web' directory if it doesn't exist
mkdir -p "$LOCAL_WEB_DIR"

# Run the script in an infinite loop
while true; do
  # Download the GitHub repository to a temporary folder
  wget -q -O /tmp/main.zip "$REPO_URL"
  unzip -q -o /tmp/main.zip -d /tmp
  rm -f /tmp/main.zip

  # Compare the 'web' folder in the temporary folder with the local folder
  if ! diff -qr "$TMP_DIR/web" "$LOCAL_WEB_DIR"; then
    echo "Changes detected. Updating the local folder and restarting the static_website service."

    # Remove the existing local 'web' folder
    rm -rf "$LOCAL_WEB_DIR"

    # Copy the updated 'web' folder to the local folder
    cp -r "$TMP_DIR/web" "$LOCAL_DIR"

    # Change to the directory containing the docker-compose.yml file
    cd "$COMPOSE_DIR"

    # Restart the static_website service in Docker Compose
    docker-compose restart static_website

    # Change back to the original directory
    cd -
  else
    echo "No changes detected."
  fi

  # Clean up the temporary folder
  rm -rf "$TMP_DIR"

  # Pause for 1 minute before re-running the loop
  sleep 60
done
