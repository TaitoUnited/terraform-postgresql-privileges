terraform {
  required_providers {
    postgresql = {
      source = "terraform-providers/postgresql"
    }
    random = {
      source = "hashicorp/random"
    }
  }
  required_version = ">= 0.13"
}
