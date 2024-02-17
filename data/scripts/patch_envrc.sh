#!/bin/bash

# Check if correct number of parameters are provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <envrc_file_path> <key> <value>"
    exit 1
fi

# Assign variables from parameters
envrc_file="$1"
key="$2"
value="$3"

# Check if .envrc file exists
if [ ! -f "$envrc_file" ]; then
    echo "$envrc_file not found. Please create the file first."
    exit 1
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

exit 0