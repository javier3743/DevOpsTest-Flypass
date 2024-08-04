# Crear el cluster EKS
resource "aws_eks_cluster" "eks_cluster" {
  name     = var.eks_cluster_name
  role_arn = var.cluster_role_arn

  vpc_config {
    subnet_ids              = var.private_subnets_ids[*]
    endpoint_private_access = true
    endpoint_public_access  = false
  }

  tags = {
    Name     = "eks_cluster"
    username = var.username
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_role_attachment  ## TODO: dependecy en el main
  ]
}
### TODO: continue acomodando nodes eks
# Crear el grupo de nodos EKS
resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "node-group"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.private_subnets_ids[*]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  tags = {
    Name     = "group"
    username = var.username
  }

  depends_on = [
    aws_eks_cluster.main
  ]
}
