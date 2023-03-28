variable "NK_VPC_cidr" {}
variable "public_subnets" {}
variable "private_subnets" {}

variable "ssh_key_pair" {
 type        = string
 description = "SSH key pair to be provisioned on the instance"
 default     = null
}