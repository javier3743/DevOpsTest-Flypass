#!/bin/bash
# Upload to S3

BUCKET_NAME=<devops-test-s3-jpg>
FILE_PATH="/data/ip_address.log"
DESTINATION_PATH="outputs/ip_address_$(date +%Y-%m-%d_%H-%M-%S).log"

aws s3 cp $FILE_PATH s3://$BUCKET_NAME/$DESTINATION_PATH
