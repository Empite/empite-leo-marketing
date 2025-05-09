provider "aws" {
  region = var.aws_region
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

resource "random_string" "bucket_suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "aws_s3_bucket" "site_bucket" {
  bucket = "${var.bucket_name_prefix}-${random_string.bucket_suffix.result}"
  tags   = var.tags
  # force_destroy = true # Uncomment if you want to easily delete the bucket even if it has objects (useful for dev)
}

resource "aws_s3_bucket_website_configuration" "site_config" {
  bucket = aws_s3_bucket.site_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_public_access_block" "site_public_access" {
  bucket = aws_s3_bucket.site_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "site_policy" {
  bucket = aws_s3_bucket.site_bucket.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.site_bucket.arn}/*"
      }
    ]
  })
  depends_on = [aws_s3_bucket_public_access_block.site_public_access]
}

resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.site_bucket.id
  key          = "index.html"
  source       = "index.html" # Assumes index.html is in the same directory as main.tf
  content_type = "text/html"
  etag         = filemd5("index.html")
}

resource "aws_s3_object" "error_html" {
  bucket       = aws_s3_bucket.site_bucket.id
  key          = "error.html"
  source       = "error.html" # Assumes error.html is in the same directory as main.tf
  content_type = "text/html"
  etag         = filemd5("error.html")
}

# DNS record for the apex domain (e.g., yourdomain.com)
resource "cloudflare_record" "apex_domain" {
  zone_id = var.cloudflare_zone_id
  name    = "@" # Represents the apex domain
  value   = aws_s3_bucket_website_configuration.site_config.website_endpoint
  type    = "CNAME"
  proxied = true # Enable Cloudflare proxy
  ttl     = 1      # Automatic TTL
}

# DNS record for www subdomain (e.g., www.yourdomain.com)
resource "cloudflare_record" "www_subdomain" {
  zone_id = var.cloudflare_zone_id
  name    = "www"
  value   = aws_s3_bucket_website_configuration.site_config.website_endpoint
  type    = "CNAME"
  proxied = true # Enable Cloudflare proxy
  ttl     = 1      # Automatic TTL
} 