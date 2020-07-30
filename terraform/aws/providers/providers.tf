# this use case for manage with multiples AWS account and where iam role already exists in your localhost
provider "aws" {
  alias  = "env"
  region = "${var.REGION}"
  assume_role {
    role_arn = "${var.ARN}"
  }
}

# this use case for manage with multiples AWS account and where iam role already exists in your localhost
provider "aws" {
  alias  = "env2"
  region = "${var.REGION}"
  assume_role {
    role_arn = "${var.ARN_ENV2}"
  }
}

# this use case for manage with single AWS account and where iam role not exists in your localhost
provider "aws" {
    region     = "${var.AWS_REGION}"
    access_key = "${var.AWS_ACCESS_KEY}"
    secret_key = "${var.AWS_SECRET_KEY}"
}

# this use case for manage Vault host
provider "vault" {
  address = base64decode("${var.VAULT_ADDR}")
  token   = base64decode("${var.VAULT_TOKEN}")
}
