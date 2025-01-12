variable "region" {
  description = "AWS region"
}

variable "eks_cluster_name" {
  description = "EKS cluster name"
  type = string
}

variable "vpc_cidr_block" {
  type        = string
  default     = "10.0.0.0/16"
  description = "CIDR block range for vpc"
}

variable "private_subnet_cidr_blocks" {
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
  description = "CIDR block ranges private subnets"
}

variable "public_subnet_cidr_block" {
  type = list(string)
  default = ["10.0.4.0/24", "10.0.5.0/24"]
  description = "CIDR block ranges public subnets"
}

variable "username" {
  description = "Username tag for resources"
}