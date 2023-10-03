terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "cassandra_version_mismatch_remediation_in_cluster" {
  source    = "./modules/cassandra_version_mismatch_remediation_in_cluster"

  providers = {
    shoreline = shoreline
  }
}