# ============================================================
#  MODULE : pipeline
#  Génère la configuration du pipeline ETL
# ============================================================

locals {
  db_name      = "${var.nom_projet}_${var.environnement}"
  pipeline_id  = "${var.nom_projet}-${var.environnement}-etl"
}

resource "local_file" "pipeline_config" {
  filename = "${var.output_path}/pipeline_${var.environnement}.json"
  content  = jsonencode({
    pipeline_id  = local.pipeline_id
    schedule     = var.schedule
    base_de_donnees = {
      host = var.db_host
      port = var.db_port
      nom  = local.db_name
    }
    config_source = var.config_path
    retries       = 3
    timeout_min   = 30
  })
}

resource "local_file" "env_file" {
  filename = "${var.output_path}/.env_${var.environnement}"
  content  = <<-EOT
    PIPELINE_ID=${local.pipeline_id}
    DB_HOST=${var.db_host}
    DB_PORT=${var.db_port}
    DB_NAME=${local.db_name}
    SCHEDULE=${var.schedule}
  EOT
  file_permission = "0600"
}
