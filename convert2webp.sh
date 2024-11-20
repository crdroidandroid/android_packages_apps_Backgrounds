#!/bin/bash

TARGET_DIR="./res/drawable-nodpi"

SUPPORTED_EXTENSIONS="png jpg jpeg"

if [ ! -d "$TARGET_DIR" ]; then
    echo "Directory $TARGET_DIR does not exist. Please check the path."
    exit 1
fi

FILES=()
for ext in $SUPPORTED_EXTENSIONS; do
    FILES+=($(find "$TARGET_DIR" -maxdepth 1 -type f -iname "*.$ext"))
done

if [ ${#FILES[@]} -eq 0 ]; then
    echo "No supported image files found in $TARGET_DIR."
    exit 0
fi

echo "Converting images in $TARGET_DIR to WEBP format..."
printf "%s\n" "${FILES[@]}" | parallel -eta 'cwebp {} -o {.}.webp && rm {}'

if [ $? -eq 0 ]; then
    echo "Conversion completed. Non-WEBP files have been deleted."
else
    echo "An error occurred during conversion or deletion."
fi
