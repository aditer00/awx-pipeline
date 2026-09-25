terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aap = {
      source  = "ansible/aap"
      version = "~> 1.0"
    }
  }
}

provider "aap" {
  host = var.awx_url
}
