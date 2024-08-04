variable "eks_cluster_name" {
  description = "The name of the EKS cluster"
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
  description = "id security"
}
