module "iam_role" {
  source = "./modules/iam" 
  username = var.username
  cluster_roles = var.cluster_roles
  nodes_roles = var.nodes_roles
}

module "ecr-repo" {
  source = "./modules/ecr"
  username = var.username
  repository_name = var.repository_name
}