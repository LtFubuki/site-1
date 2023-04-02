#!/bin/bash

# Set repository URL and local directories
REPO_URL="https://github.com/LtFubuki/site-1/archive/refs/heads/main.zip"
LOCAL_DIR="/path/to/your/local/directory"
TMP_DIR="/tmp/site-1-main"

# Enter the local directory
cd "$LOCAL_DIR"

# Run the script in an infinite loop
while true; do
  # Download the GitHub repository to a temporary folder
  wget -q -O main.zip "$REPO_URL"
  unzip -q -o main.zip -d /tmp
  rm -f main.zip

  # Compare the 'web' folder in the temporary folder with the local folder
  if ! diff -qr "$TMP_DIR/web" "web"; then
    echo "Changes detected. Updating the local folder and restarting the static_website service."

    # Copy the updated 'web' folder to the local folder
    cp -r "$TMP_DIR/web" .

    # Restart the static_website service in Docker Compose
    docker-compose restart static_website
  else
    echo "No changes detected."
  fi

  # Clean up the temporary folder
  rm -rf "$TMP_DIR"

  # Pause for 1 minute before re-running the loop
  sleep 60
done
