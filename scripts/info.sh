#!/bin/bash

RED='\033[0;31m'
NC='\033[0m'

describe_resources() {
  local resourceType=$1
  local listCommand=$2
  local describeCommand=$3
  printf "${RED}----------------------------------------------------------------${NC}\n"

  printf "${RED}${resourceType}:${NC}\n"
  local resourceNames
  # Fetch only the names of the resources
  resourceNames=$(eval "${listCommand} --format='value(name)'")
  
  # List resources in table format
  eval "${listCommand}"
  printf "\n"

  # Describe each resource
  for resourceName in $resourceNames; do
    printf "${RED}${resourceName}:${NC}\n"
    # printf "${RED}${resourceType} ${resourceName}:${NC}\n"
    eval "${describeCommand} ${resourceName}"
    printf "\n"
  done
}

# List and describe target HTTPS proxies
describe_resources "Target HTTPS Proxies" \
  "gcloud compute target-https-proxies list" \
  "gcloud compute target-https-proxies describe"

# List and describe SSL certificates
describe_resources "SSL Certificates" \
  "gcloudcompute ssl-certificates list" \
  "gcloudcompute ssl-certificates describe"

# List and describe URL maps
describe_resources "URL Maps" \
  "gcloud compute url-maps list" \
  "gcloud compute url-maps describe"

# List and describe backend buckets
describe_resources "Backend Buckets" \
  "gcloud compute backend-buckets list" \
  "gcloud compute backend-buckets describe"

# List and describe addresses
describe_resources "Addresses" \
  "gcloud compute addresses list --global" \
  "gcloud compute addresses describe --global"