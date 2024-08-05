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
  description = "Username tag for resources"
}
variable "eks_cluster_sg" {
  description = "sg cluster"
}
variable "eks_nodes_sg" {
  description = "sg nodes"
}
