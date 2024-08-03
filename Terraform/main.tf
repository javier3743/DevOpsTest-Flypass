module "s3_bucket" {
  source      = "./modules/s3"
  bucket_name = var.bucket_name
  username    = var.username
}

module "iam_role" {
  source                 = "./modules/iam" 
  username               = var.username
  cluster_roles_policies = var.cluster_roles_policies
  nodes_roles_policies   = var.nodes_roles_policies
  bucket_arn             = module.s3_bucket.bucket_arn
}

module "ecr-repo" {
  source          = "./modules/ecr"
  username        = var.username
  repository_name = var.repository_name
}

module "vpc" {
  source   = "./modules/vpc"
  username = var.username
  eks_cluster_name = var.eks_cluster_name
}