#!/bin/bash

AMI=ami-091138d0f0d41ff90
ZONE_ID=Z07186583IUMEVUQL0IYT



for instance in $@
do

    echo " Launching instance: $instance"

    InstanceID=$(aws ec2 run-instances \
        --image-id "$AMI" \
        --instance-type t3.micro \
        --key-name Key \
        --security-groups "commom-ssh" "$instance-roboshop" \
        --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance-roboshop}]" \
        --query 'Instances[0].InstanceId' \
        --output text
    )

    echo " Instance ID: $InstanceID"


        if [ instance = "frontend" ]; then

            IP=$(aws ec2 describe-instances \
            --instance-ids "$InstanceID" \
            --query 'Reservations[*].Instances[*].PublicIpAddress' \
            --output text
            )

            echo "Printing publicipaddress: $IP"

        else
        
            IP=$(aws ec2 describe-instances \
            --instance-ids "$InstanceID" \
            --query 'Reservations[*].Instances[*].PrivateIpAddress' \
            --output text
            )

            echo "Printing privateipaddress: $IP"
            Route53="$instance.manojkoney.store"
        fi


     aws route53 change-resource-record-sets \
    --hosted-zone-id "$ZONE_ID" \
    --change-batch '
        {
            "Comment": "Creating a new A record in Route53",
            "Changes": [
                {
                    "Action": "UPSERT",
                    "ResourceRecordSet": {
                        "Name": "'$Route53'",
                        "Type": "A",
                        "TTL": 1,
                        "ResourceRecords": [
                            {
                                "Value": "'$IP'"
                            }
                        ]
                    }
                }
            ]
        }

     ' 

done
