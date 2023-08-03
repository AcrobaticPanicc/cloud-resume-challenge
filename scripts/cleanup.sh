#!/bin/bash

# Delete all Compute Engine instances
for i in $(gcloud compute instances list --format='value(name)'); do
  echo "Deleting instance: $i"
  gcloud compute instances delete $i --quiet
done

# Delete all Cloud Storage buckets
for i in $(gsutil ls); do
  echo "Deleting bucket: $i"
  gsutil rm -r $i
done

# Delete all forwarding rules
for i in $(gcloud compute forwarding-rules list --format='value(name)'); do
  echo "Deleting forwarding rule: $i"
  gcloud compute forwarding-rules delete $i --global --quiet
done

# Delete all target proxies
for i in $(gcloud compute target-http-proxies list --format='value(name)'); do
  echo "Deleting target http proxy: $i"
  gcloud compute target-http-proxies delete $i --quiet
done

# Delete all URL maps
for i in $(gcloud compute url-maps list --format='value(name)'); do
  echo "Deleting URL map: $i"
  gcloud compute url-maps delete $i --quiet
done

# Delete all backend services
for i in $(gcloud compute backend-services list --format='value(name)'); do
  echo "Deleting backend service: $i"
  gcloud compute backend-services delete $i --global --quiet
done

# Delete all firewall rules
for i in $(gcloud compute firewall-rules list --format='value(name)'); do
  echo "Deleting firewall rule: $i"
  gcloud compute firewall-rules delete $i --quiet
done

# Delete all routes
for i in $(gcloud compute routes list --format='value(name)'); do
  if ! echo "$i" | grep -q "default"; then
    echo "Deleting route: $i"
    gcloud compute routes delete "$i" --quiet
  else
    echo "Ignoring route: $i"
  fi
done

# Delete all reserved IP addresses
for i in $(gcloud compute addresses list --format='value(name)'); do
  echo "Deleting IP: $i"
  gcloud compute addresses delete $i --global --quiet
done

gcloudrun regions list --format="value(NAME)" | while read -r region; do
  for service in $(gcloudrun services list --platform managed --region "$region" --format='value(name)'); do
    echo "Deleting Cloud Run service: $service in region: $region"
    gcloudrun services delete "$service" --platform managed --region "$region" --quiet
  done
done

for service in $(gcloud endpoints services list --format='value(serviceName)'); do
  echo "Deleting Cloud Endpoint service: $service"
  gcloud endpoints services delete $service --quiet
done