region = "us-east-2"
username = "javier.palacios"
bucket_name = "devops_test_s3"
repository_name = "devops_test_repo"
eks_cluster_name = "devops_test_cluster"

cluster_roles_policies = [
  "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
  "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
]

nodes_roles_policies = [
  "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
  "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
  "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
]
