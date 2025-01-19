output "zone_id" {
  description = "The ID of the hosted zone"
  value       = aws_route53_zone.main.zone_id
}

output "zone_name_servers" {
  description = "The name servers for the hosted zone"
  value       = aws_route53_zone.main.name_servers
}

output "certificate_arn" {
  description = "The ARN of the certificate"
  value       = aws_acm_certificate.main.arn
}

output "certificate_validation_arn" {
  description = "The ARN of the certificate validation"
  value       = aws_acm_certificate_validation.main.certificate_arn
}