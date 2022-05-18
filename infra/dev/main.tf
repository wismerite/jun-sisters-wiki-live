module "tags" {
  source = "github.com/wismerite/jun-sisters-wiki-modules.git//metadata/tags?ref=v0.0.15"
}

module "vpc" {
  source = "github.com/wismerite/jun-sisters-wiki-modules.git//network/vpc?ref=v0.0.15"
  vpc_name = "${var.name_prefix}-vpc"
  vpc_region = var.default_region
  vpc_ip_range = var.env_map[var.env]["ip_range"]
}

module "k8s_cluster" {
  # depends on vpc, tags
  source = "github.com/wismerite/jun-sisters-wiki-modules.git//k8s?ref=v0.0.15"
  k8s_name = "${var.name_prefix}-k8s"
  k8s_region = var.default_region
  k8s_vpc = module.vpc.id
  k8s_node_count = 1
  k8s_node_size = "s-1vcpu-2gb"
  k8s_tags = [module.tags.k8s_cluster_tag]
}

module "db_cluster" {
  # depends on vpc, k8s, tags
  source = "github.com/wismerite/jun-sisters-wiki-modules.git//data-store?ref=v0.0.15"

  pg_name = "${var.name_prefix}-db"
  pg_region = var.default_region
  pg_node_count = 1
  pg_node_size = "db-s-1vcpu-2gb"
  pg_vpc_id = module.vpc.id
  pg_tags = [module.tags.pg_cluster_tag]
  pg_wiki_db_name = "${var.name_prefix}-jswiki"
  k8s_cluster_id = module.k8s_cluster.id
}

# module "firewalls" {
#   # depends on vpc, k8s, tags
#   source = "github.com/wismerite/jun-sisters-wiki-modules.git//network/firewalls?ref=v0.0.15"

#   pg_name = "${var.name_prefix}-db"
#   pg_region = var.default_region
#   pg_node_count = 1
#   pg_node_size = "s-1vcpu-2gb"
#   pg_vpc_id = module.vpc.id
#   pg_tags = [module.tags.pg_cluster_tag]
#   pg_wiki_db_name = "${var.name_prefix}-jswiki"
#   k8s_cluster_id = module.k8s_cluster.id
# }

module "project" {
  # depends on all other modules
  source = "github.com/wismerite/jun-sisters-wiki-modules.git//metadata/project?ref=v0.0.15"

  project_name = var.name_prefix
  project_env = var.env_map[var.env]["long_name"]
  project_resources = [
    module.db_cluster.urn,
    module.k8s_cluster.urn
  ]
}
