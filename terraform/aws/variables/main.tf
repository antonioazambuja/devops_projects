provider "aws" {
    region     = var.REGION
    access_key = var.AWS_ACCESS_KEY
    secret_key = var.AWS_SECRET_KEY
}

output "vars" {
  value = var.test
}
