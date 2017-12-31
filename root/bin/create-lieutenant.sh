#!/bin/sh

aws \
    ec2 \
    wait \
    instance-running \
    --instance-ids $(aws \
        ec2 \
        run-instances \
        --image-id ami-55ef662f \
        --security-group-ids $(aws ec2 create-security-group --group-name $(uuidgen) --description "security group for the lieutenant environment in EC2" --query "GroupId" --output text) \
        --count 1 \
        --instance-type t2.micro \
        --key-name $(aws ec2 import-key-pair --key-name $(uuidgen) --public-key-material "${LIEUTENANT_AWS_PUBLIC_KEY}" --query "KeyName" --output text) \
        --tag-specifications "ResourceType=instance,Tags=[{Key=moniker,Value=lieutenant}]" \
        --query "Instances[0].InstanceId" \
        --output text)