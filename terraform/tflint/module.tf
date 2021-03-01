module "sample" {
  source = "./module"

  name = "test"
  tags = ["sample"]
  labels = {
    env = "dev"
  }
}
