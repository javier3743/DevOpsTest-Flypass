variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

variable "username" {
  description = "The username tag for resources"
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