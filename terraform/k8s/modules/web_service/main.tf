resource "kubernetes_deployment" "main" {
  metadata {
    name   = var.metadata.dep.name
    labels = var.metadata.dep.labels
  }

  spec {
    replicas = var.deployment.replicas

    selector {
      match_labels = var.deployment.match_labels
    }

    template {
      metadata {
        labels = var.metadata.lab.labels
      }

      spec {
        container {
          image = var.deployment.img
          name  = var.deployment.name

          resources {
            dynamic "limits" {
              for_each = var.deployment.limits.cpu != null || var.deployment.limits.memory != null ? ["enable"] : []

              content {
                cpu    = var.deployment.limits.cpu
                memory = var.deployment.limits.memory
              }
            }
            dynamic "requests" {
              for_each = var.deployment.requests.cpu != null || var.deployment.requests.memory != null ? ["enable"] : []
              content {
                cpu    = var.deployment.requests.cpu
                memory = var.deployment.requests.memory
              }
            }
          }

        }
      }
    }
  }

}

resource "kubernetes_service" "main" {
  metadata {
    name = var.metadata.sv.name
  }

  spec {
    type             = var.service.type
    session_affinity = var.service.session_affinity
    selector         = var.service.selector
    port {
      port = var.service.port
    }
  }
}
