#!/bin/bash

# This script is used to download a zip file from an S3 bucket, list its contents and convert the filenames into a JSON object.

# Check if two arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <BUCKET_NAME> <ZIP_FILE_KEY>"
    exit 1
fi

BUCKET_NAME="$1"
ZIP_FILE_KEY="$2"

# Function to convert filenames into a JSON object.
# It receives the filenames one by one from the while loop and constructs a JSON object.
# If the filename is not empty, it removes the file extension and adds an entry into the JSON object.
function filenames_to_json {
    local json="{"
    local first=true
    while IFS= read -r line; do
        if [[ $line =~ ^[[:space:]]+[0-9]+ ]]; then
            local filename

            filename=$(echo "$line" | awk '{print $4}')
            if [ -n "$filename" ]; then
                # Remove file extension using parameter expansion
                filename="${filename%.*}"
                if [ "$first" = true ]; then
                    first=false
                else
                    json+=","
                fi
                json+="\"$filename\": \"true\""
            fi
        fi
    done
    json+='}'
    echo "$json"
}

# Temporarily stores the downloaded zip file
TMP_ZIP_FILE=$(mktemp)

# Download the zip file from the S3 bucket and store it in the temporary location
aws s3 cp "s3://${BUCKET_NAME}/${ZIP_FILE_KEY}" "${TMP_ZIP_FILE}" --quiet

# List the contents of the zip file and convert the filenames into a JSON object
unzip -l "${TMP_ZIP_FILE}" | filenames_to_json

# Remove the temporary zip file
rm "${TMP_ZIP_FILE}"