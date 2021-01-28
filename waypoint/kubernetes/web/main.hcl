project = ""

app "" {
  labels = {
    "service" = "example",
    "env"     = "dev"
  }

  build {
    use "pack" {}
    registry {
      use "docker" {
        image = ""
      }
    }
  }

  deploy {
    use "kubernetes" {
      probe_path = ""
    }
  }

  release {
    use "kubernetes" {
    }
  }
}
