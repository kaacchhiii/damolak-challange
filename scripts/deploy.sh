#!/bin/bash
set -e

# Colors for output
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${GREEN}Step 1: Initializing Infrastructure with Terraform...${NC}"
cd terraform
terraform init
terraform apply -auto-approve

echo -e "${GREEN}Step 2: Getting ECR Repository URL...${NC}"
ECR_URL=$(terraform output -raw ecr_repository_url)
ALB_DNS=$(terraform output -raw alb_hostname)

echo -e "${GREEN}Step 3: Building and Pushing Initial Image...${NC}"
cd ../app
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $(echo $ECR_URL | cut -d'/' -f1)
docker build -t $ECR_URL:latest .
docker push $ECR_URL:latest

echo -e "${GREEN}Success! Your application is being deployed.${NC}"
echo -e "${GREEN}ALB URL:${NC} http://$ALB_DNS"
echo -e "${GREEN}Note:${NC} The Jenkins pipeline will handle subsequent deployments."
