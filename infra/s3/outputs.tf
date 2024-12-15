output "name" {
  value = aws_s3_bucket.my-bucket.bucket_regional_domain_name
}

output "bucket-id" {
  value = aws_s3_bucket.my-bucket.id
}

output "bucket-domain-name" {
  value = aws_s3_bucket.my-bucket.bucket_regional_domain_name
}

