terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.5.0"
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

# token here may expire for k8s and helm, need to figure out rotation at some point
# potential example here: https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs#exec-plugins
provider "kubernetes" {
  host             = module.k8s_cluster.endpoint
  token            = module.k8s_cluster.token
  cluster_ca_certificate = base64decode(
    module.k8s_cluster.ca_certificate
  )
}

provider "helm" {
  kubernetes {
    host             = module.k8s_cluster.endpoint
    token            = module.k8s_cluster.token
    cluster_ca_certificate = base64decode(
      module.k8s_cluster.ca_certificate
    )
  }
}