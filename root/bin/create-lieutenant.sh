#!/bin/sh

aws \
    ec2 \
    wait \
    instance-running \
    --instance-ids $(aws \
        ec2 \
        run-instances \
        --image-id ami-f0ea638a \
        --security-group-ids $(aws ec2 create-security-group --group-name ${VOLUMES_BACKUP_SECURITY_GROUP} --description "security group for the volumes backup environment in EC2" --query "GroupId" --output text) \
        --count 1 \
        --instance-type t2.micro \
        --key-name $(aws ec2 import-key-pair --key-name ${VOLUMES_BACKUP_KEYPAIR} --public-key-material "${VOLUMES_BACKUP_PUBLIC_KEY}" --query "KeyName" --output text) \
        --tag-specifications "ResourceType=instance,Tags=[{Key=moniker,Value=lieutenant}]" \
        --query "Instances[0].InstanceId" \
        --output text)