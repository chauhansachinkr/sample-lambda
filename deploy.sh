#!/bin/bash

# A sample template file to deploy your sam application to the cloudformation directly during the development phase. 
# Alternatively use Jenkins pipeline for your deployment. 

#CHANGE ME
GLOBAL_SG_NAME=sg-0c509d5382a4e067c
REGION_SG_NAME=sg-0d94af7ace021279a

ENV='dev'
UNIQUENAME="cf-sg-update-${ENV}"
TEMPLATE_FILE_NAME='template.yaml'
STACK_NAME="${UNIQUENAME}"
TIME=`date +%s`
ZIPNAME=${UNIQUENAME}-samapp-${TIME}.zip

rm -f *.zip

ACCOUNT_ID=`aws sts get-caller-identity --query 'Account' --output=text`
REGION=`aws configure get region`
BUCKET_NAME="${UNIQUENAME}-${ACCOUNT_ID}-${REGION}"

# Try to create the bucket
aws s3 mb s3://${BUCKET_NAME} >/dev/null

zip  -x=*.nyc_output* -x=*coverage* -x=*tests* ${ZIPNAME} ./index.py
aws s3 cp "${ZIPNAME}" s3://${BUCKET_NAME}

# Try to deploy the package with parameters for dev testing 

aws cloudformation deploy --template-file ${TEMPLATE_FILE_NAME} \
--stack-name ${STACK_NAME} \
--capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM \
--parameter-overrides \
S3Bucket=${BUCKET_NAME} \
S3Path=${ZIPNAME} \
globalSGName=${GLOBAL_SG_NAME} \
regionalSGName=${REGION_SG_NAME} \