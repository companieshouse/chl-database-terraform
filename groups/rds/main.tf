# ------------------------------------------------------------------------------
# Providers
# ------------------------------------------------------------------------------
provider "aws" {
  region  = var.aws_region
}

terraform {
  backend "s3" {
  }
}

provider "vault" {
  auth_login {
    path = "auth/userpass/login/${var.vault_username}"
    parameters = {
      password = var.vault_password
    }
  }
}
