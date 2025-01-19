# AWS Route53 and ACM Certificate Module

This Terraform module creates and manages AWS Route53 resources and ACM certificates. It provides a streamlined way to set up DNS hosting and SSL/TLS certificates for your domains.

## Features

- Creates a Route53 hosted zone for your domain
- Provisions an ACM certificate for the domain
- Automatically creates DNS validation records
- Manages certificate validation process

## Requirements

- Terraform >= 0.13.x
- AWS Provider >= 3.0
- AWS account with appropriate permissions

## Usage

```hcl
module "dns" {
  source = "path/to/module"

  domain_name = "example.com"
  tags = {
    Environment = "production"
    Project     = "website"
  }
}
```

## Inputs

| Name | Description | Type | Required | Default |
|------|-------------|------|----------|---------|
| domain_name | The domain name for the hosted zone and certificate | string | yes | n/a |
| tags | Tags to be applied to all resources | map(string) | no | {} |

## Outputs

| Name | Description |
|------|-------------|
| zone_id | The ID of the hosted zone |
| zone_name_servers | The name servers for the hosted zone |
| certificate_arn | The ARN of the certificate |
| certificate_validation_arn | The ARN of the certificate validation |

## Resources Created

This module creates the following resources:

- `aws_route53_zone`: A Route53 hosted zone for your domain
- `aws_acm_certificate`: An ACM certificate for your domain
- `aws_route53_record`: DNS records for certificate validation
- `aws_acm_certificate_validation`: Certificate validation configuration

## Post-Deployment Steps

After applying this module, you need to:

1. Update your domain's name servers at your domain registrar to point to the name servers provided in the `zone_name_servers` output
2. Wait for DNS propagation (can take up to 48 hours)
3. The ACM certificate validation will happen automatically once DNS propagation is complete

## Example with Outputs

```hcl
module "dns" {
  source = "path/to/module"

  domain_name = "example.com"
  tags = {
    Environment = "production"
  }
}

output "name_servers" {
  value = module.dns.zone_name_servers
}

output "certificate_arn" {
  value = module.dns.certificate_arn
}
```

## Notes

- The ACM certificate is created in the same region as specified in your AWS provider configuration
- Certificate validation may take up to several hours to complete
- Make sure your AWS credentials have the necessary permissions to create Route53 and ACM resources

## Contributing

Feel free to submit issues and pull requests for improving this module.

## License

GNU Licensed. See LICENSE for full details.