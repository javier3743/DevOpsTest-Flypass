variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

variable "username" {
  description = "Username tag for resources"
}

variable "bucket_name" {
  description = "Name of the bucket"
}

variable "cluster_roles_policies" {
  description = "Cluster roles"
  type = list(string)
}

variable "nodes_roles_policies" {
  description = "Nodes roles"
  type = list(string)
}

variable "repository_name" {
  description = "ECR repo name"
  type = string
}

variable "eks_cluster_name" {
  description = "EKS cluster name"
  type = string
}