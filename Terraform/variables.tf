variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

variable "username" {
  description = "The username tag for resources"
}

variable "bucket_name" {
  description = "The name of the bucket"
}

variable "cluster_roles_policies" {
  description = "Cluster Admin Roles"
  type = list(string)
}

variable "nodes_roles_policies" {
  description = "Node Admin Roles"
  type = list(string)
}

variable "repository_name" {
  description = "Repo name"
  type = string
}

variable "eks_cluster_name" {
  description = "The name of the EKS cluster"
  type = string
}

variable "eks_cluster_sg" {
  type = string
}