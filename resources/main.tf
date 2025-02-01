data "aws_route53_zone" "root_domain" {
  name = "${split(".", var.domain_name)[1]}.${split(".", var.domain_name)[2]}."
}

resource "aws_route53_zone" "main" {
  name = var.domain_name
  tags = var.tags
}

# Delegate from the root zone to the new zone
resource "aws_route53_record" "zone_record" {
  zone_id = data.aws_route53_zone.root_domain.zone_id
  name    = aws_route53_zone.main.name
  type    = "NS"
  ttl     = 300

  records = aws_route53_zone.main.name_servers
}

resource "aws_acm_certificate" "main" {
  domain_name       = var.domain_name
  validation_method = "DNS"
  tags              = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "validation" {
  for_each = {
    for dvo in aws_acm_certificate.main.domain_validation_options : dvo.domain_name => {
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
  zone_id         = aws_route53_zone.main.zone_id
}

resource "aws_acm_certificate_validation" "main" {
  certificate_arn         = aws_acm_certificate.main.arn
  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]
}