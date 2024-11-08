variable "acm_certificate_domain" {
  type        = string
  description = "(optional) describe your variable"
  default     =  null
}

variable "statuses" {
  type        = list(string)
  description = "(optional) describe your variable"
  default     = []
}

variable "name" {
  description = "Name of the opensearch  to be created"
  type        = string
  default     = "aws-opensearch"
}

variable "tags" {
  description = "Additional tags for the opensearh"
  type        = map(string)
  default = {
    "owner" = "devops"
    "env"   = "dev"
  }
}
variable "aws_acm_certificate_arn" {
  type        = string
  description = "(arn of custom domain"
  default     =  null
}


variable "elasticsearch_version" {
  type        = string
  description = "(Required) Version of OpenSearch"
  default     = "OpenSearch_2.5"
}

variable "domain" {
  type        = string
  description = "The name of the OpenSearch Domain."
  default     = "example-domain"
}


variable "availability_zones" {
  description = "The number of availability zones for the OpenSearch cluster. Valid values: 1, 2 or 3."
  type        = number
  default     = 1
}

variable "instance_count" {
  type        = number
  description = "(Optional) Number of instances in the cluster."
  default     = 1
}

variable "instance_type" {
  type        = string
  description = "(Optional) Instance type of data nodes in the cluster."
  default     = "c6g.large.elasticsearch"
}
variable "volume_size" {
  type        = number
  description = "(Required if ebs_enabled is set to true.) Size of EBS volumes attached to data nodes (in GiB)."
  default     = 10
}
variable "master_instance_count" {
  type        = number
  description = "Optional) Number of dedicated main nodes in the cluster."
  default     = 0
}

variable "master_instance_type" {
  type        = string
  description = "(Optional) Instance type of the dedicated main nodes in the cluster."
  default     = "c6g.large.elasticsearch"
}

variable "warm_instance_count" {
  type        = number
  description = "(Optional) Number of warm nodes in the cluster. Valid values are between 2 and 150."
  default     = 0
}
variable "warm_instance_type" {
  type        = string
  description = "(Optional) Instance type for the Elasticsearch cluster's warm nodes."
  default     = "c6g.large.elasticsearch"
}



variable "volume_type" {
  type        = string
  description = "(Optional) Type of EBS volumes attached to data nodes."
  default     = "gp3"
}


variable "subnet_ids" {
  type        = list(string)
  description = "list of the subnet ids"
  default = [ "your-subnet-id" ]

}


variable "vpc_id" {
  type        = string
  description = " openvpn id for opensearch sg "
  default = "your-vpc-id"

 
}

variable "vpc_cidr_range" {
  type        = string
  description = " vpc cider range for opensearch sg  "
  default = "your-vpc-cidr"
}
