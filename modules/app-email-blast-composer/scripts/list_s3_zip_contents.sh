#!/bin/bash

# Check if two arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <BUCKET_NAME> <ZIP_FILE_KEY>"
    exit 1
fi

BUCKET_NAME="$1"
ZIP_FILE_KEY="$2"

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

TMP_ZIP_FILE=$(mktemp)
aws s3 cp "s3://${BUCKET_NAME}/${ZIP_FILE_KEY}" "${TMP_ZIP_FILE}" --quiet
unzip -l "${TMP_ZIP_FILE}" | filenames_to_json
rm "${TMP_ZIP_FILE}"
