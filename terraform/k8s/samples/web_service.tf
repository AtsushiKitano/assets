locals {
  web_service_sample_enable = false

  _web_sv_enable = local.web_service_sample_enable ? ["enable"] : []
}

module "web_service_sample" {
  for_each = toset(local._web_sv_enable)
  source   = "../modules/web_service"

  metadata = {
    dep = {
      name = "terraform-example"
      labels = {
        app = "MyApp"
      }
    }

    lab = {
      labels = {
        app = "MyApp"
      }
    }

    sv = {
      name = "terraform-example"
    }
  }

  deployment = {
    replicas = 3
    match_labels = {
      app = "MyApp"
    }
    img  = "nginx"
    name = "sample"
    limits = {
      cpu    = "0.5"
      memory = "512Mi"
    }
    requests = {
      cpu    = "250m"
      memory = "50Mi"
    }
  }

  service = {
    type             = "LoadBalancer"
    session_affinity = "ClientIP"
    selector = {
      app = "MyApp"
    }
    port = 80
  }
}
