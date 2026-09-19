#!/bin/bash
JENKINS_IP=$1

if [[ -z "$JENKINS_IP" ]]; then
    echo "Jenkins server IP must be specified as a parameter"
    exit 1
fi

echo "Cleaning local Jenkins credentials..."
rm -f ./secrets/jenkins/credentials.json

echo "Stopping container and wiping remote storage on $JENKINS_IP..."
ssh -o StrictHostKeyChecking=no ubuntu@$JENKINS_IP -i ./secrets/ssh/cloud_ssh_key \
  'docker rm -f jenkins 2>/dev/null || true; sudo rm -rf /opt/jenkins_data/ /opt/jenkins' &> /dev/null

echo "Jenkins reset completed!"