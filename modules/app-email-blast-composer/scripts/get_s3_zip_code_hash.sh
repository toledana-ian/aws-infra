#!/bin/bash

# This script is used to download a zip file from an S3 bucket, list its contents and convert the filenames into a JSON object.

# Check if two arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <BUCKET_NAME> <ZIP_FILE_KEY>"
    exit 1
fi

BUCKET_NAME="$1"
ZIP_FILE_KEY="$2"

# Check if ZIP file exists
output=$(aws s3api head-object --bucket "${BUCKET_NAME}" --key "${ZIP_FILE_KEY}" 2>&1)
if echo "$output" | grep -q "Not Found"; then
  echo "{\"source_code_hash\":\"\"}"
  exit 0
fi

# Temporarily stores the downloaded zip file
TMP_ZIP_FILE=$(mktemp)

# Download the zip file from the S3 bucket and store it in the temporary location
aws s3 cp "s3://${BUCKET_NAME}/${ZIP_FILE_KEY}" "${TMP_ZIP_FILE}" --quiet

# Generate the hash of the file and store it in a variable
source_code_hash=$(sha256sum $LOCAL_FILE_NAME | awk '{ print $1 }')

# Output the hash in JSON format
echo "{\"source_code_hash\":\"$source_code_hash\"}"

# Remove the temporary zip file
rm "${TMP_ZIP_FILE}"