variable "cluster_roles" {
  description = "Cluster Admin Roles"
  type = list(string)
}

variable "nodes_roles" {
  description = "Cluster Admin Roles"
  type = list(string)
}

variable "username" {
  description = "The username tag for resources"
}
