variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "ap-southeast-2" # Sydney
}

variable "bucket_name_prefix" {
  description = "A prefix for the S3 bucket name. A random string will be appended to ensure uniqueness."
  type        = string
  default     = "leo-2505-coming-soon"
}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default = {
    Terraform   = "true"
    Project     = "LeoComingSoonPage"
    Environment = "dev"
  }
}

variable "cloudflare_api_token" {
  description = "Cloudflare API Token with permissions to edit DNS records for the zone."
  type        = string
  sensitive   = true # Mark as sensitive as it's a secret
  default = "TKorKogkHfe-RfQd-OiCuhCpkBlVyDtcpkYmeUm2"
}

variable "cloudflare_zone_id" {
  description = "The Zone ID of your domain in Cloudflare."
  type        = string
  default = "ce254b2c346f04bcb8030ff380f38ba3"
}

variable "domain_name" {
  description = "Your registered domain name (e.g., example.com)."
  type        = string
  default = "cashsight.ai"
} 