provider "aws" {
  alias  = "env"
  region = "${var.REGION}"
  assume_role {
    role_arn = "${var.ARN}"
  }
}

provider "aws" {
  alias  = "env2"
  region = "${var.REGION}"
  assume_role {
    role_arn = "${var.ARN_ENV2}"
  }
}

provider "aws" {
    region     = "${var.AWS_REGION}"
    access_key = "${var.AWS_ACCESS_KEY}"
    secret_key = "${var.AWS_SECRET_KEY}"
}

provider "vault" {
  address = base64decode("${var.VAULT_ADDR}")
  token   = base64decode("${var.VAULT_TOKEN}")
}
