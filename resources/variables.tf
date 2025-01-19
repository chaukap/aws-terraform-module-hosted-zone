variable "domain_name" {
  description = "The domain name for the hosted zone and certificate"
  type        = string
}

variable "tags" {
  description = "Tags to be applied to all resources"
  type        = map(string)
  default     = {}
}