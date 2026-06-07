terraform {
  backend "s3" {
    key          = "nt548-lab2/dev/terraform.tfstate"
    encrypt      = true
    use_lockfile = true
  }
}
