# ============================================================
#  JOUR 2 / 10 — Terraform : Modules
#  Root module qui appelle 3 modules réutilisables
# ============================================================

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
  }
}

provider "local" {}

# ── APPEL MODULE 1 : Configuration projet ────────────────────
# source = chemin vers le dossier du module
module "config_projet" {
  source = "./modules/config"

  # Inputs du module (correspondent aux variables du module)
  nom_projet    = var.nom_projet
  environnement = var.environnement
  version_app   = var.version_app
  output_path   = "${path.module}/output"
}

# ── APPEL MODULE 2 : Pipeline ETL ────────────────────────────
module "pipeline_etl" {
  source = "./modules/pipeline"

  nom_projet    = var.nom_projet
  environnement = var.environnement
  db_host       = var.db_host
  db_port       = var.db_port
  schedule      = var.pipeline_schedule
  output_path   = "${path.module}/output"

  # Réutiliser un output du module config
  config_path = module.config_projet.chemin_config
}

# ── APPEL MODULE 3 : Documentation ───────────────────────────
module "documentation" {
  source = "./modules/documentation"

  nom_projet    = var.nom_projet
  environnement = var.environnement
  version_app   = var.version_app
  db_host       = var.db_host
  output_path   = "${path.module}/output"

  # Outputs des autres modules passés en input
  config_path   = module.config_projet.chemin_config
  pipeline_info = module.pipeline_etl.pipeline_info
}
