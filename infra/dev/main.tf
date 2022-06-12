module "tags" {
  source = "github.com/wismerite/jun-sisters-wiki-modules.git//metadata/tags?ref=v0.0.29"
}

module "vpc" {
  source = "github.com/wismerite/jun-sisters-wiki-modules.git//network/vpc?ref=v0.0.29"
  vpc_name = "${var.name_prefix}-vpc"
  vpc_region = var.default_region
  vpc_ip_range = var.env_map[var.env]["ip_range"]
}

module "k8s_cluster" {
  # depends on vpc, tags
  source = "github.com/wismerite/jun-sisters-wiki-modules.git//k8s/cluster?ref=v0.0.29"
  k8s_name = "${var.name_prefix}-k8s"
  k8s_region = var.default_region
  k8s_vpc = module.vpc.id
  k8s_node_count = 2
  k8s_node_size = "s-2vcpu-4gb"
  k8s_tags = [module.tags.k8s_cluster_tag]
}

module "db_cluster" {
  # depends on vpc, k8s, tags
  source = "github.com/wismerite/jun-sisters-wiki-modules.git//data-store?ref=v0.0.29"

  pg_name = "${var.name_prefix}-db"
  pg_region = var.default_region
  pg_node_count = 1
  pg_node_size = "db-s-1vcpu-2gb"
  pg_vpc_id = module.vpc.id
  pg_tags = [module.tags.pg_cluster_tag]
  pg_wiki_db_name = "${var.name_prefix}-jswiki"
  k8s_cluster_id = module.k8s_cluster.id
  vpc_ip_range = var.env_map[var.env]["ip_range"]
}

# module "firewalls" {
#   # depends on vpc, k8s, tags
#   source = "github.com/wismerite/jun-sisters-wiki-modules.git//network/firewalls?ref=v0.0.29"

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
  # depends on all other DO resources
  source = "github.com/wismerite/jun-sisters-wiki-modules.git//metadata/project?ref=v0.0.29"

  project_name = var.name_prefix
  project_env = var.env_map[var.env]["long_name"]
  project_resources = [
    module.db_cluster.urn,
    module.k8s_cluster.urn
  ]
}

module "k8s_ingress" {
  source = "github.com/wismerite/jun-sisters-wiki-modules.git//k8s/cluster_objects/ingress?ref=v0.0.29"
  service_name = var.name_prefix
  service_fqdn = "wiki.jun-sisters.gay"
}

module "chart_nginx" {
  source = "github.com/wismerite/jun-sisters-wiki-modules.git//k8s/charts/nginx?ref=v0.0.29"

  lb_replicas = 2
  lb_cpu = "100m"
  lb_memory = "90Mi"
}

module "chart_wiki" {
  source = "github.com/wismerite/jun-sisters-wiki-modules.git//k8s/charts/wiki?ref=v0.0.29"
  # doing depends_on here bc k8s secrets don't output their name,
  #  so an inherent dependency seems impossible for now
  depends_on = [
    module.k8s_secret_db_pw
  ]
  service_name = var.name_prefix
  replicas = 1
  db_private_uri = module.db_cluster.private_host
  db_port = module.db_cluster.port
  db = module.db_cluster.db
  db_username = module.db_cluster.username
  db_password_secret = var.db_pw_secret_name
  db_ca = trimspace(
            trimprefix(
                trimsuffix(
                    trimspace(module.db_cluster.ca_certificate),
                    "-----END CERTIFICATE-----"
                ),
                "-----BEGIN CERTIFICATE-----"
              )
            )
}

module "chart_cert_manager" {
  source = "github.com/wismerite/jun-sisters-wiki-modules.git//k8s/charts/cert-manager?ref=v0.0.29"
  
  service_name = var.name_prefix
  cert_email = var.email
}

module "k8s_secret_db_pw" {
  source = "github.com/wismerite/jun-sisters-wiki-modules.git//k8s/cluster_objects/secrets?ref=v0.0.29"

  db_pw = module.db_cluster.password
  db_pw_secret_name = var.db_pw_secret_name
}