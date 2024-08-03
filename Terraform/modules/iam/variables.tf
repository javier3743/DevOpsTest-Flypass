variable "bucket_arn" {
  type        = string
}

variable "cluster_roles_policies" {
  description = "Cluster Admin Roles"
  type        = list(string)
}

variable "nodes_roles_policies" {
  description = "Cluster Admin Roles"
  type        = list(string)
}

variable "username" {
  description = "The username tag for resources"
}
