variable "eks_cluster_name" {
  description = "The name of the EKS cluster"
  type = string
}

variable "vpc_cidr_block" {
  type        = string
  default     = "10.0.0.0/16"
  description = "CIDR block range for vpc"
}

variable "private_subnet_cidr_blocks" {
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.1.0/24", "10.0.3.0/24"]
  description = "CIDR block ranges private subnets"
}

variable "public_subnet_cidr_block" {
  type = list(string)
  default = ["10.0.0.0/24", "10.0.1.0/24", "10.0.3.0/24"]
  description = "CIDR block ranges public subnets"
}

variable "username" {
  description = "The username tag for resources"
}