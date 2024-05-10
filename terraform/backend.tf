#Initialise tfstate remote backend
terraform {

  backend "gcs" {
    bucket = "tfstate-demo-borauysal"
    prefix = "terraform/state"
  }
}
