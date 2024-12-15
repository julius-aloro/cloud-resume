output "cert-id" {
  value = aws_acm_certificate.my-domain-certificate.id
}

output "cert-arn" {
  value = aws_acm_certificate.my-domain-certificate.arn
}