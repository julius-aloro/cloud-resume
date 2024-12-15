# S3 Bucket Creation
resource "aws_s3_bucket" "my-bucket" {
  bucket = "juliusaloro.into-cloud.com"
}

# Configure S3 as static website hosting
resource "aws_s3_bucket_website_configuration" "my-bucket-web-hosting" {
  bucket = aws_s3_bucket.my-bucket.id

  index_document {
    suffix = "index.html"
  }
}

# Configure S3 to allow public access
resource "aws_s3_bucket_public_access_block" "my-bucket-public-access" {
  bucket = aws_s3_bucket.my-bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Assign S3 bucket policy
resource "aws_s3_bucket_policy" "my-bucket-policy" {
  bucket = aws_s3_bucket.my-bucket.id
  policy = jsonencode({
    "Version" : "2008-10-17",
    "Id" : "PolicyForCloudFrontPrivateContent",
    "Statement" : [
      {
        "Sid" : "AllowCloudFrontServicePrincipal",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "cloudfront.amazonaws.com"
        },
        "Action" : "s3:GetObject",
        "Resource" : "arn:aws:s3:::juliusaloro.into-cloud.com/*",
        "Condition" : {
          "StringEquals" : {
            "AWS:SourceArn" : var.policy_principal
          }
        }
      }
    ]
  })
}