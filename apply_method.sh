#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <target_directory>"
    exit 1
fi

TARGET_DIR="$1"

# Directories to copy
DIRS_TO_COPY=("ai" "custom-modes" "docs" "prompts")

# Check if source directories exist and build a list of existing dirs
EXISTING_DIRS=()
for dir in "${DIRS_TO_COPY[@]}"; do
    if [ -d "./$dir" ]; then
        EXISTING_DIRS+=("./$dir")
    else
        echo "Warning: Source directory './$dir' not found. Skipping."
    fi
done

# Exit if no valid source directories were found
if [ ${#EXISTING_DIRS[@]} -eq 0 ]; then
    echo "Error: None of the specified source directories exist. Nothing to copy."
    exit 1
fi

# Ensure target directory exists (create if it doesn't)
mkdir -p "$TARGET_DIR"

# Copy specified directories preserving structure using rsync
echo "Copying specified directories to '$TARGET_DIR'..."
rsync -avh --progress "${EXISTING_DIRS[@]}" "$TARGET_DIR/"

# Check rsync exit status
if [ $? -eq 0 ]; then
    echo "Successfully copied contents."
else
    echo "Error during copy operation."
    exit 1
fi

exit 0 