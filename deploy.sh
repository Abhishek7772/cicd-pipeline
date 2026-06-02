#!/bin/bash
# deploy.sh — Automated Deployment Script
# Author: Abhishek Parmar
# Project: Cloud-Based Automated CI/CD Pipeline

set -euo pipefail

IMAGE_TAG=$1
ECR="123456789.dkr.ecr.ap-south-1.amazonaws.com/my-app"
INSTANCES=("i-0a1b2c3d" "i-0e4f5a6b")
SSH_KEY="~/.ssh/cicd-key.pem"

echo "[deploy] Starting deployment of $ECR:$IMAGE_TAG"

# Authenticate Docker with ECR
aws ecr get-login-password --region ap-south-1 | \
  docker login --username AWS --password-stdin $ECR

# Deploy to each EC2 instance
for INSTANCE in "${INSTANCES[@]}"; do

  # Get public IP of instance
  IP=$(aws ec2 describe-instances \
       --instance-ids $INSTANCE \
       --query 'Reservations[0].Instances[0].PublicIpAddress' \
       --output text)

  echo "[deploy] Deploying to instance $INSTANCE ($IP)..."

  ssh -i $SSH_KEY -o StrictHostKeyChecking=no ubuntu@$IP << REMOTE
    # Pull latest image from ECR
    docker pull $ECR:$IMAGE_TAG

    # Stop old container gracefully
    docker stop my-app 2>/dev/null || true
    docker rm my-app 2>/dev/null || true

    # Start new container
    docker run -d \
      --name my-app \
      -p 80:3000 \
      --restart=unless-stopped \
      --env GIT_COMMIT=$IMAGE_TAG \
      $ECR:$IMAGE_TAG

    echo "Container started successfully"
REMOTE

  # Wait for container to start
  sleep 5

  # Health check
  STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://$IP/health)

  if [ "$STATUS" != "200" ]; then
    echo "[rollback] Health check failed on $INSTANCE! Status: $STATUS"
    echo "[rollback] Initiating automatic rollback..."
    bash ./rollback.sh
    exit 1
  fi

  echo "[health] Instance $INSTANCE healthy (HTTP $STATUS)"

done

echo "[deploy] Deployment complete: $ECR:$IMAGE_TAG deployed to all instances"
