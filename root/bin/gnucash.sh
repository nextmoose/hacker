#!/bin/sh

SECURITY_GROUP=$(uuidgen) &&
    KEY_NAME=$(uuidgen) &&
    cleanup(){
        sudo umount /opt/docker/workspace/lieutenant &&
            rm -rf /opt/docker/workspace/lieutenant &&
            aws \
                ec2 \
                wait \
                instance-terminated \
                --instance-ids $(aws \
                    ec2 \
                    terminate-instances \
                    --instance-ids $(aws ec2 describe-instances --filters Name=tag:moniker,Values=lieutenant Name=instance-state-name,Values=running --query "Reservations[*].Instances[*].InstanceId" --output text)
                    --query "TerminatingInstances[*].InstanceId" --output text) &&
            aws ec2 delete-security-group --group-name ${SECURITY_GROUP} &&
            aws ec2 delete-key-pair --key-name ${KEY_NAME}
        } &&
    trap cleanup EXIT &&
    aws \
        ec2 \
        wait \
        instance-running \
        --instance-ids $(aws \
            ec2 \
            run-instances \
            --image-id ami-55ef662f \
            --security-group-ids $(aws ec2 create-security-group --group-name ${SECURITY_GROUP} --description "security group for the lieutenant environment in EC2" --query "GroupId" --output text) \
            --count 1 \
            --instance-type t2.micro \
            --key-name $(aws ec2 import-key-pair --key-name $(uuidgen) --public-key-material "${LIEUTENANT_AWS_PUBLIC_KEY}" --query "KeyName" --output text) \
            --tag-specifications "ResourceType=instance,Tags=[{Key=moniker,Value=lieutenant}]" \
            --query "Instances[0].InstanceId" \
            --output text) &&
    rm -f /home/user/.ssh/lieutenant-ec2.id_rsa &&
    ssh-keygen -f 
    ssh-keyscan $(aws ec2 describe-instances --filter Name=tag:moniker,Values=lieutenant Name=instance-state-name,Values=running --query "Reservations[*].Instances[*].PublicIpAddress" --output text) >> /home/user/known_hosts &&
    aws \
        ec2 \
        authorize-security-group-ingress \
        --group-id $(aws ec2 describe-instances --filters Name=tag:moniker,Values=lieutenant Name=instance-state-name,Values=running --query "Reservations[*].Instances[*].SecurityGroups[*].GroupId" --output text) \
        --protocol tcp \
        --port 22 \
        --cidr 0.0.0.0/0 &&
    aws \
        ec2 \
        attach-volume \
        --device /dev/sdh \
        --volume-id $(aws ec2 describe-volumes --filters Name=tag:moniker,Values=lieutenant --query "Volumes[*].VolumeId" --output text) \
        --instance-id $(aws ec2 describe-instances --filters Name=tag:moniker,Values=lieutenant Name=instance-state-name,Values=running --query "Reservations[*].Instances[*].InstanceId" --output text) &&
    mkdir /opt/docker/workspace/extension/lieutenant &&
    sshfs -o allow_other lieutenant-ec2:/data /opt/docker/workspace/lieutenant