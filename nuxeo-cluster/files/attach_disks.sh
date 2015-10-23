#!/bin/bash

mkfs.ext4 /dev/xvdf || exit 1
printf '\n/dev/xvdf               /opt     ext4   defaults,noatime 0 1\n' >> /etc/fstab
mkdir -p /opt
mount -a
instance_id=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
volumes_ids=$(aws ec2 describe-volumes --filters Name=attachment.instance-id,Values=${instance_id} --region $REGION | grep VolumeId | tr -d ' ' | sort -u | tr '\"' ' ' | awk '{print $3}')
for v in ${volumes_ids}; do
    aws ec2 create-tags --resources $v --tags Key=Name,Value=${STACKNAME}-nuxeo --region $REGION
    aws ec2 create-tags --resources $v --tags Key=Type,Value=Nuxeo --region $REGION
done

