output "pipeline_info" {
  value = {
    id       = "${var.nom_projet}-${var.environnement}-etl"
    schedule = var.schedule
    db_name  = "${var.nom_projet}_${var.environnement}"
  }
}

output "fichiers_crees" {
  value = [
    local_file.pipeline_config.filename,
    local_file.env_file.filename,
  ]
}
