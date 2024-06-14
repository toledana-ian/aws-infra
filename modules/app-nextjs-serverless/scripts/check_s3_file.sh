#!/bin/bash

# This script checks the existence and accessibility of a specified file in an S3 bucket.
# Usage: ./script.sh <BUCKET_NAME> <ZIP_FILE_KEY>
# BUCKET_NAME: The name of the S3 bucket
# ZIP_FILE_KEY: The key (path) to the file in the S3 bucket

# Check if the script is passed exactly 2 arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <BUCKET_NAME> <ZIP_FILE_KEY>"
    exit 1
fi

# Assign arguments to variables
BUCKET_NAME="$1"
ZIP_FILE_KEY="$2"

# Check if the specified file exists and is accessible in the S3 bucket
output=$(aws s3api head-object --bucket "${BUCKET_NAME}" --key "${ZIP_FILE_KEY}" 2>&1)
if echo "$output" | grep -q "Not Found"; then
  echo "{}"
  exit 0
# Check if access to the file is forbidden
elif echo "$output" | grep -q "Forbidden"; then
  echo "{}"
  exit 0
# If the file is found and accessible, return a success message
else
  echo "{\"success\": \"true\"}"
  exit 0
fi