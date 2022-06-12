variable "do_token" {
  # this should be defined via environment variable
  type = string
}

variable "default_region" {
  type    = string
  default = "nyc1"
}

variable "name_prefix" {
  type    = string
  default = "jun-sisters-wiki"
}

variable "env" {
  type        = string
  description = "should be one of: [dev, prod]"
  default = "dev"
}

variable "email" {
  type = string
  description = "wiki admin email for use in a few places"
  default = "jun.sisters.wiki@gmail.com"
}

variable "db_pw_secret_name" {
  default = "postgres-pw"
  type = string
}

# DO is dumb and needs specific strings for a project's "environment", hence "long_name".
#   however, the short env name defined in var.env should be used everywhere else
#
#  ip_range is the ip range used when creating the vpc to hold the resources
#  backend is the DO space (s3-compatible object store) which should hold tf state
#    - the spaces are created manually cause w/e
#  different IP ranges for different envs are provided simply for easier differentiation by humans
variable "env_map" {
  type = map(map(string))
  default = {
    dev  = {
      long_name = "Development",
      ip_range = "10.0.1.0/26",
      backend = "placeholder"
    },
    prod = {
      long_name = "Production",
      ip_range  = "10.0.2.0/26",
      backend = "placeholder"
    }
  }
}

## app configuration vars
# putting this here so it can easily be referenced by separate modules
variable "db_secret_name" {
  type = string
  default = "postgres"
}


## unused for now, hoping interpolation in module sources allowed
## UPDATE: sadly, interpolation in module sources is not allowed u_u
##         potentially available in terragrunt, but challenging with external modules
# variable "modules_version" {
#   type    = string
#   default = "v0.0.1"
# }

# variable "modules_location" {
#   type = string
#   default = "git@github.com:wismerite/jun-sisters-wiki-modules.git"
# }


