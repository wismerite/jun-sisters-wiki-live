terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }

#   backend "pg" {
#     conn_str = digitalocean_database_cluster.jun_sisters_wiki_db.host
#   }

}

provider "digitalocean" {
  token = var.do_token
}

data "digitalocean_ssh_key" "terraform" {
  name = "terraform"
}

module "do_tags"

module "vpc" {
  vpc_name = "${var.name_prefix}-vpc"
  vpc_region = var.default_region
  vpc_ip_range = 
}

module "k8s-cluster" {
  # depends on vpc, tags
  source = "git@github.com:wismerite/jun-sisters-wiki-modules.git//data-store?ref=v0.0.1"
  k8s_name = "${var.name_prefix}-k8s"
  k8s_region = var.default_region
  # k8s_vpc
  k8s_node_count = 1
  k8s_node_size = "s-1vcpu-2gb"
  k8s_tags = [project.k8s_cluster_tag]
}

module "db-cluster" {
  # depends on vpc, k8s, tags
  source = "git@github.com:wismerite/jun-sisters-wiki-modules.git//data-store?ref=v0.0.1"

  pg_name = "${var.name_prefix}-db"
  pg_region = var.default_region
  pg_node_count = 1
  pg_node_size = "s-1vcpu-2gb"
  # pg_vpc_id
  pg_tags = [project.pg_cluster_tag]
  pg_wiki_db_name = "${var.name_prefix}-jswiki"
  k8s_cluster_id = k8s-cluster.id
}

module "project" {
  # depends on all other modules
  source = "git@github.com:wismerite/jun-sisters-wiki-modules.git//metadata?ref=v0.0.1"

  project_name = var.name_prefix
  project_env = var.env_map[var.env]
  project_resources = [
    db-cluster.urn,
  ]
}
