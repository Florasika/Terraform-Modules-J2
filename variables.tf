variable "nom_projet" {
  type = string
}

variable "environnement" {
  type = string
}

variable "version_app" {
  type    = string
  default = "1.0.0"
}

variable "db_host" {
  type    = string
  default = "localhost"
}

variable "db_port" {
  type    = number
  default = 5432
}

variable "pipeline_schedule" {
  type    = string
  default = "0 6 * * *"
}

variable "output_path" {
  type = string
}

variable "config_path" {
  type = string
}