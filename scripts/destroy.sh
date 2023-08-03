#!/bin/bash

source .env

RED='\033[0;31m'
NC='\033[0m'

echo -e "${RED}Setting Project ID...${NC}"
gcloud config set project $PROJECT_ID

echo -e "${RED}Deleting global forwarding rule...${NC}"
gcloud compute forwarding-rules delete $FORWARDING_RULE_NAME --global -q

echo -e "${RED}Deleting target HTTPS proxy...${NC}"
gcloud compute target-https-proxies delete $TARGET_HTTPS_PROXY_NAME -q

echo -e "${RED}Deleting SSL certificate...${NC}"
gcloudcompute ssl-certificates delete $CERTIFICATE_NAME -q

echo -e "${RED}Deleting URL map...${NC}"
gcloud compute url-maps delete $URL_MAP_NAME -q

echo -e "${RED}Deleting backend bucket...${NC}"
gcloud compute backend-buckets delete $NEG_NAME -q

echo -e "${RED}Deleting external IP address...${NC}"
gcloud compute addresses delete $RESERVATION_NAME --global -q

echo -e "${RED}Deleting Cloud Storage bucket...${NC}"
gsutil rm -r gs://$BUCKET_NAME/

echo -e "${RED}Deleting domain record set...${NC}"
gcloud dns record-sets delete tomerc.com --type='A' --zone=tomerc-zone