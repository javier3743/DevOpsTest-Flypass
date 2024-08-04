provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  token                  = module.eks.cluster_authenticator.token
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
}

# Configuración de los Pods
resource "kubernetes_deployment" "ip_handler" {
  metadata {
    name = "ip-handler"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "ip-handler"
      }
    }

    template {
      metadata {
        labels = {
          app = "ip-handler"
        }
      }

      spec {
        container {
          name  = "ip-collector"
          image = "your-registry/ip-collector:latest"
          volume_mount {
            name      = "data-storage"
            mount_path = "/data"
          }
        }

        container {
          name  = "s3-uploader"
          image = "your-registry/s3-uploader:latest"
          volume_mount {
            name      = "data-storage"
            mount_path = "/data"
          }
        }

        volume {
          name = "data-storage"

          empty_dir {}
        }
      }
    }
  }
}
