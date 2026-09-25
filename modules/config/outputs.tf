output "chemin_config" {
  description = "Chemin du fichier config JSON"
  value       = local_file.config_json.filename
}

output "fichiers_crees" {
  description = "Liste des fichiers créés par ce module"
  value       = [
    local_file.config_json.filename,
    local_file.config_yaml.filename,
  ]
}
