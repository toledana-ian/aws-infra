#!/bin/bash

# Check if two arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <BUCKET_NAME> <ZIP_FILE_KEY>"
    exit 1
fi

BUCKET_NAME="$1"
ZIP_FILE_KEY="$2"

# Get the ETag (MD5 hash) of the uploaded zip file in S3
etag=$(aws s3api head-object --bucket $BUCKET_NAME --key $ZIP_FILE_KEY --query 'ETag' --output text)

# Calculate the source_code_hash
source_code_hash=$(echo -n $etag | tr -d '"')

echo "{\"source_code_hash\":\"$source_code_hash\"}"
