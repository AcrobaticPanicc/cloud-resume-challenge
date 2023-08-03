#!/bin/bash

source .env

GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${GREEN}Setting the project...${NC}"
gcloud config set project $PROJECT_ID

echo -e "${GREEN}Creating backend bucket...${NC}"
gsutil mb gs://$BUCKET_NAME

echo -e "${GREEN}Copying HTML page to the bucket...${NC}"
gsutil cp $HTML_PAGE gs://$BUCKET_NAME/

echo -e "${GREEN}Setting the bucket's website configuration...${NC}"
gsutil web set -m $HTML_PAGE gs://$BUCKET_NAME

echo -e "${GREEN}Changing bucket IAM to allow all users view...${NC}"
gsutil iam ch allUsers:objectViewer gs://$BUCKET_NAME

echo -e "${GREEN}Creating IP reservation...${NC}"
gcloud compute addresses create $RESERVATION_NAME --global

echo -e "${GREEN}Creating backend bucket...${NC}"
gcloud compute backend-buckets create $NEG_NAME --gcs-bucket-name=$BUCKET_NAME --enable-cdn

echo -e "${GREEN}Creating URL map...${NC}"
gcloud compute url-maps create $URL_MAP_NAME --default-backend-bucket=$NEG_NAME

echo -e "${GREEN}Creating SSL certificate...${NC}"
gcloudcompute ssl-certificates create $CERTIFICATE_NAME --domains $DOMAIN_NAME

echo -e "${GREEN}Creating target HTTPS proxy...${NC}"
gcloud compute target-https-proxies create $TARGET_HTTPS_PROXY_NAME --ssl-certificates=$CERTIFICATE_NAME --url-map=$URL_MAP_NAME

echo -e "${GREEN}Getting the IP address...${NC}"
IP_ADDRESS=$(gcloud compute addresses describe $RESERVATION_NAME --global --format="get(address)")

echo -e "${GREEN}Creating a DNS record set...${NC}"
gcloud dns --project=$PROJECT_ID record-sets create $DOMAIN_NAME. --zone=$ZONE_NAME --type="A" --ttl="300" --rrdatas=$IP_ADDRESS

echo -e "${GREEN}Creating forwarding rule...${NC}"
gcloud compute forwarding-rules create $FORWARDING_RULE_NAME --global --target-https-proxy=$TARGET_HTTPS_PROXY_NAME --address=$IP_ADDRESS --ports=443