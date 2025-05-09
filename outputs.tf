output "s3_bucket_id" {
  description = "The ID (name) of the S3 bucket."
  value       = aws_s3_bucket.site_bucket.id
}

output "s3_bucket_website_endpoint" {
  description = "The S3 bucket website endpoint. Use this for Cloudflare CNAME or as HTTP origin."
  value       = aws_s3_bucket_website_configuration.site_config.website_endpoint
}

output "s3_bucket_domain_name" {
  description = "The domain name of the S3 bucket (e.g., for use with Cloudflare's S3 origin settings if not using website endpoint)."
  value       = aws_s3_bucket.site_bucket.bucket_regional_domain_name
} 