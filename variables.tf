variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

variable "username" {
  description = "The username tag for resources"
}

variable "access_key"{
  description = "AWS access key"
  type        = string
  sensitive   = true
}

variable "secret_key"{
  description = "AWS secret key"
  type        = string
  sensitive   = true
}

variable "cluster_roles" {
  description = "Cluster Admin Roles"
  type = list(string)
}

variable "nodes_roles" {
  description = "Node Admin Roles"
  type = list(string)
}

variable "repository_name" {
  description = "Repo name"
  type = string
}