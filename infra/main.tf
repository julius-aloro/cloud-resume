# primary provider
provider "aws" {
  region = "ap-southeast-1"
}

# Secondary provider (mainly for the ACM certificate to create in us-east-1)
provider "aws" {
  alias = "us-east-1"

  region = "us-east-1"
}

# Creation of S3 Bucket
module "s3_bucket" {
  source           = "./s3"
  policy_principal = module.cloudfront-distribution.cloudfront-arn
}

# Creation of Certificate
module "certificate" {
  source      = "./acm"
  domain-name = "juliusaloro.into-cloud.com"

  providers = {
    aws = aws.us-east-1
  }
}

# Creation of cloudfront distribution
module "cloudfront-distribution" {
  source             = "./cloudfront"
  cert-arn           = module.certificate.cert-arn
  origin-domain-name = module.s3_bucket.bucket-domain-name
}

# Creation of A record / alias in Route53
module "route_53_domain" {
  source = "./route53"
  alias_domain_name = module.cloudfront-distribution.cf_domain_name
  alias_hosted_zone = module.cloudfront-distribution.cf_hosted_zone
}


### outputs

# CloudFront ID
output "cloudfront_distribution_id" {
  value = module.cloudfront-distribution.cloudfront_distribution_id
}

output "s3_bucket_id" {
  value = module.s3_bucket.bucket-id
}