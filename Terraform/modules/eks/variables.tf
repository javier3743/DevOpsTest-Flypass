variable "eks_cluster_name" {
  description = "EKS cluster name"
  type = string
}
variable "cluster_role_arn" {
  description = "ARN of role for cluster"
}
variable "node_role_arn" {
  description = "ARN of role for nodes"
}
variable "private_subnets_ids" {
  description = "Subnets for cluster"
}
variable "username" {
  description = "The username tag for resources"
}
variable "eks_cluster_sg" {
  description = "id security cluster"
}
variable "eks_nodes_sg" {
  description = "id security nodes"
}
