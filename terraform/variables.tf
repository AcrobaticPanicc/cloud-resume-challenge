variable "project_id" {
  description = "Google Cloud project ID"
  default     = "cloud-resume-project-1234"
}

variable "service_account_path" {
  description = "Path to the GCP service account JSON key"
  default     = "./service-account.json"
}

variable "bucket_name" {
  description = "Name of the GCS bucket for website hosting"
  default     = "tomerc.com"
}

variable "html_page" {
  description = "HTML page to be hosted"
  default     = "../src/frontend/index.html"
}

variable "domain_name" {
  description = "Custom domain name for the website"
  default     = "tomerc.com"
}

variable "reservation_name" {
  default = "ip-reservation"
}

variable "neg_name" {
  default = "bucket-neg"
}

variable "url_map_name" {
  default = "url-map"
}

variable "certificate_name" {
  default = "ssl-cert"
}

variable "target_https_proxy_name" {
  default = "https-proxy"
}

variable "forwarding_rule_name" {
  default = "https-forwarding-rule"
}

