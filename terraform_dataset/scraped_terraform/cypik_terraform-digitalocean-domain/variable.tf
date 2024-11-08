variable "name" {
  type        = string
  default     = "mycustomdomain.com"
  description = "The name of the domain"
}

variable "ip_address" {
  type        = string
  default     = null
  description = "The IP address of the domain. If specified, this IP is used to created an initial A record for the domain."
}

variable "records" {
  type        = map(any)
  default     = {}
  description = "A list of DNS records for the DigitalOcean domain. Each record should include fields such as type (e.g., A, CNAME, MX), name, data (e.g., IP address, target), priority, and TTL."
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Flag to control the droplet creation."
}




