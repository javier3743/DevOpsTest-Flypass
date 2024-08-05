provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  token                  = module.eks.cluster_authenticator.token
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
}
