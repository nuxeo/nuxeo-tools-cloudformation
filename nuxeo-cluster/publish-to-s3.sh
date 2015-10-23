#!/bin/bash

cd $(dirname $0)

TSTAMP=$(date +"%Y%m%d-%H%M")
BUCKET="nuxeo-cfn-test" # Temporary test bucket
REGION="eu-west-1"

rm -rf target

mkdir -p target/$TSTAMP target/latest

# Upload templates with a timestamp, but keep a "latest" version of the files for when using the template file directly
cp -a files target/latest/
cp -a files target/$TSTAMP/

for dest in latest $TSTAMP; do
    mkdir -p target/$dest/templates
    for f in $(/bin/ls templates/*.template | sed "s,templates/,,g"); do
        sed "s,/$BUCKET/latest/files/,/$BUCKET/$TSTAMP/files/,g" templates/$f | \
            sed "s,/$BUCKET/latest/templates/,/$BUCKET/$TSTAMP/templates/,g" > target/$dest/templates/$f
    done
done

cd target
aws s3 sync $TSTAMP s3://$BUCKET/$TSTAMP --region=$REGION --grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers
aws s3 sync latest s3://$BUCKET/latest --region=$REGION --grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers --delete

