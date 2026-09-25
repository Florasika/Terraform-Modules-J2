# Outputs du root module — agrège les outputs des modules

output "resume_deploiement" {
  description = "Résumé complet du déploiement"
  value = {
    projet        = var.nom_projet
    environnement = var.environnement
    config        = module.config_projet.chemin_config
    pipeline      = module.pipeline_etl.pipeline_info
    documentation = module.documentation.chemin_readme
  }
}

output "tous_les_fichiers" {
  description = "Tous les fichiers générés"
  value = concat(
    module.config_projet.fichiers_crees,
    module.pipeline_etl.fichiers_crees,
    module.documentation.fichiers_crees,
  )
}
