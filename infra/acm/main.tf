terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

# Fetch data from existing hosted zone in AWS (.into-cloud.com)
data "aws_route53_zone" "myzone" {
  name         = "into-cloud.com"
  private_zone = false
}

resource "aws_acm_certificate" "my-domain-certificate" {
  domain_name       = var.domain-name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "domain-validation" {
  for_each = {
    for dvo in aws_acm_certificate.my-domain-certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.myzone.zone_id
}

resource "aws_acm_certificate_validation" "name" {
  certificate_arn         = aws_acm_certificate.my-domain-certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.domain-validation : record.fqdn]
}