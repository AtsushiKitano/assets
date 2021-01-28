project = "sample"

app "my-app" {
  build {
    use "docker-pull" {
      image = "hashicorp/http-echo"
      tag   = "latest"
    }
  }

  deploy {
    use "docker" {
      command = ["-listen", ":3000", "-text", "hello"]
    }
  }
}
