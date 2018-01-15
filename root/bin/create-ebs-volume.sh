#!/bin/sh

MONIKER=d2252340-b1e2-41e3-a928-37530ec18e1e &&
    DOT_SSH_CONFIG_FILE=$(mktemp ${HOME}/.ssh/config.d/XXXXXXXX) &&
    SECURITY_GROUP=$(uuidgen) &&
    KEY_NAME=$(uuidgen) &&
    KEY_FILE=$(mktemp ${HOME}/.ssh/XXXXXXXX.id_rsa) &&
    rm -f ${KEY_FILE} &&
    cleanup(){
        rm -f ${DOT_SSH_CONFIG_FILE} ${KEY_FILE} ${KEY_FILE}.pub &&
            aws \
                ec2 \
                wait \
                instance-terminated \
                --instance-ids $(aws \
                    ec2 \
                    terminate-instances \
                    --instance-ids $(aws ec2 describe-instances --filters Name=tag:moniker,Values=${MONIKER} Name=instance-state-name,Values=running --query "Reservations[0].Instances[*].InstanceId" --output text) \
                    --query "TerminatingInstances[*].InstanceId" \
                    --output text) &&
            aws ec2 delete-security-group --group-name ${SECURITY_GROUP} &&
            aws ec2 delete-key-pair --key-name ${KEY_NAME}
    } &&
    trap cleanup EXIT &&
    aws \
        ec2 \
        wait \
        volume-available \
            --volume-ids $(aws \
                ec2 \
                create-volume \
                --availability-zone $(aws ec2 describe-availability-zones --query "AvailabilityZones[0].ZoneName") \
                --size 5 \
                --tag-specifications "ResourceType=volume,Tags=[{Key=moniker,Value=${MONIKER}}]" \
                --query json) &&
        aws \
            ec2 \
            wait \
            instance-running \
            --instance-ids $(aws \
                ec2 \
                run-instances \
                --image-id ami-55ef662f \
                --security-group-ids $(aws ec2 create-security-group --group-name ${SECURITY_GROUP} --description "security group for the ec2 ebs environment in EC2" --query "GroupId" --output text) \
                --count 1 \
                --instance-type t2.micro \
                --key-name $(aws ec2 import-key-pair --key-name ${KEY_NAME} --public-key-material "$(cat ${KEY_FILE}.pub)" --query "KeyName" --output text) \
                --placement AvailabilityZone=$(aws ec2 describe-volumes --filters Name=tag:moniker,Values= --query "Volumes[*].AvailabilityZone" --output text) \
                --tag-specifications "ResourceType=instance,Tags=[{Key=moniker,Value=${MONKIKER}]" \
                --query "Instances[0].InstanceId" \
                --output text) &&
        DEVICE=$(aws \
            ec2 \
            attach-volume \
            --device /dev/sdh \
            --volume-id $(aws ec2 describe-volumes --filters Name=tag:moniker,Values=${MONIKER} --query "Volumes[*].VolumeId" --output text) \
            --instance-id $(aws ec2 describe-instances --filters Name=tag:moniker,Values=${MONIKER} Name=instance-state-name,Values=running --query "Reservations[*].Instances[*].InstanceId" --output text) \
            --query "Device" \
            --output text) 
    aws ec2 authorize-security-group-ingress --group-name ${SECURITY_GROUP} --protocol tcp --port 22 --cidr 0.0.0.0/0 &&
    (cat > ${DOT_SSH_CONFIG_FILE} <<EOF
Host ${MONIKER}-ec2
HostName $(aws ec2 describe-instances --filter Name=tag:moniker,Values=${MONIKER} Name=instance-state-name,Values=running --query "Reservations[*].Instances[*].PublicIpAddress" --output text)
User ec2-user
IdentityFile ${KEY_FILE}
EOF
    ) &&
    sleep 15s &&
    ssh-keyscan $(aws ec2 describe-instances --filter Name=tag:moniker,Values=${MONIKER} Name=instance-state-name,Values=running --query "Reservations[*].Instances[*].PublicIpAddress" --output text) >> ${HOME}/.ssh/known_hosts &&
    ssh ${MONIKER}-ec2 sudo mkfs -t ext4 ${DEVICE} &&
    ssh ${MONIKER}-ec2 sudo mkdir /data &&
    ssh ${MONIKER}-ec2 sudo mount ${DEVICE} /data &&
    ssh ${MONIKER}-ec2