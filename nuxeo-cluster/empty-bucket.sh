#!/bin/bash

cd $(dirname $0)

TSTAMP=$(date +"%Y%m%d%H%MS")
BUCKET="nuxeo-cfn-test"
REGION="eu-west-1"

mkdir empty$TSTAMP
aws s3 sync empty$TSTAMP/ s3://$BUCKET/ --region $REGION --delete
rmdir empty$TSTAMP

