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

# DO is dumb and needs specific strings for a project's "environment"
#   however, the short env name defined in var.env should be used everywhere else
variable "env_map" {
  type = map(string)
  default = {
    dev  = "Development"
    prod = "Production"
  }
}


variable "modules_version" {
  type    = string
  default = "v0.0.1"
}


## unused for now, hoping interpolation in module sources are allowed
variable "modules_version" {
  type    = string
  default = "v0.0.1"
}

variable "modules_location" {
  type = string
  default = "git@github.com:wismerite/jun-sisters-wiki-modules.git"
}