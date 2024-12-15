# Fetch the base url in hosted zone using data source
data "aws_route53_zone" "mydomain_hosted_zone" {
  name    = var.base_url
}

# Create A record that is aliased to the CloudFront domain name
resource "aws_route53_record" "a_record" {
  zone_id = data.aws_route53_zone.mydomain_hosted_zone.zone_id
  name    = "juliusaloro.into-cloud.com"
  type    = "A"

  alias {
    name                   = var.alias_domain_name
    zone_id                = var.alias_hosted_zone
    evaluate_target_health = true
  }
}