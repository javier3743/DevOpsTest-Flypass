region = "us-east-2"
username = "javier.palacios"
bucket_name = "devops-test-s3-jpg"
repository_name = "devops-test-repo"
eks_cluster_name = "devops-test-cluster"

cluster_roles_policies = [
  "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
  "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController",
  "arn:aws:iam::aws:policy/AmazonEKSAddonsServicePolicy "
]

nodes_roles_policies = [
  "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
  "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
  "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
]
