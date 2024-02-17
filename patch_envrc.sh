#!/bin/bash

# Check if key and value are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <key> <value>"
    exit 1
fi

# Assign key and value from parameters
key=$1
value=$2

# Check if .envrc file exists
envrc_file=".envrc"
if [ ! -f "$envrc_file" ]; then
    echo "$envrc_file not found. Creating a new file..."
    echo "export $key=$value" > "$envrc_file"
    exit 0
fi

# Update or add key-value pair in .envrc file
if grep -q "^export $key=" "$envrc_file"; then
    # Key found, update the value
    sed -i "s/^export $key=.*/export $key=$value/" "$envrc_file"
    echo "Updated $key in $envrc_file"
else
    # Key not found, add a new line
    echo "export $key=$value" >> "$envrc_file"
    echo "Added $key to $envrc_file"
fi

direnv allow

exit 0