#!/bin/bash

# This script fetches the ETag (MD5 hash) of a file present in an S3 bucket
# and prints it in a JSON format.

# It expects two arguments: the S3 bucket name and the key of the file
# present in that bucket.

# Check if two arguments are provided.
# If not, print the usage and exit.
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <BUCKET_NAME> <ZIP_FILE_KEY>"
    exit 0
fi

BUCKET_NAME="$1"
ZIP_FILE_KEY="$2"

# Check if ZIP file exists
output=$(aws s3api head-object --bucket "${BUCKET_NAME}" --key "${ZIP_FILE_KEY}" 2>&1)
if echo "$output" | grep -q "Not Found"; then
  echo "{\"source_code_hash\":\"\"}"
  exit 0
fi

# The `aws s3api head-object` command fetches the metadata of an object
# in S3. The `--query 'ETag'` option is used to retrieve only the ETag
# of the object.
# The ETag of an S3 object is the MD5 hash of the object and is wrapped
# in double quotes. We save this to the `etag` variable.
etag=$(aws s3api head-object --bucket "$BUCKET_NAME" --key "$ZIP_FILE_KEY" --query 'ETag' --output text)
# We then remove the double quotes from `etag` and save this to the
# `source_code_hash` variable.
source_code_hash=$(echo -n "$etag" | tr -d '"')

# Finally we print the source code hash in a JSON format.
echo "{\"source_code_hash\":\"$source_code_hash\"}"