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
  default = "jun_sisters_wiki"
}

variable "env" {
  type        = string
  description = "should be one of: [dev, prod]"
  default = "dev"
}

# variable "env_map" {
#   type = map(string)
#   default = {
#     dev  = "development"
#     prod = "production"
#   }
# }

# "db-s-1vcpu-1gb"