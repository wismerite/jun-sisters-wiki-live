terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }

  backend "s3" {
          skip_credentials_validation = true
          skip_metadata_api_check = true
          endpoint = "https://nyc3.digitaloceanspaces.com"
          region = "us-east-1"
          bucket = "jun-sisters-wiki-tf-state" // name of your space
  }
}

provider "digitalocean" {
  token = var.do_token
}
