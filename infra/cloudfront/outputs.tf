output "cf_domain_name" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}

output "cf_hosted_zone" {
  value = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
}

output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.s3_distribution.id
}