locals {
  mydomain = "juliusaloro.into-cloud.com"
}

# Origin Access Control

resource "aws_cloudfront_origin_access_control" "cf-access-control" {
  name                              = "cloud-resume-static-webhosting"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

locals {
  s3_origin_id = "my-s3-origin"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = var.origin-domain-name
    origin_access_control_id = aws_cloudfront_origin_access_control.cf-access-control.id
    origin_id                = local.s3_origin_id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "cloudfront distribution for my static website"
  default_root_object = "index.html"

  aliases = [local.mydomain]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
    acm_certificate_arn = var.cert-arn
    ssl_support_method  = "sni-only"
  }
}

output "cloudfront-arn" {
  value = aws_cloudfront_distribution.s3_distribution.arn
}