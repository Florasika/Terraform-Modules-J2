# ============================================================
#  MODULE : config
#  Génère les fichiers de configuration du projet
# ============================================================

resource "local_file" "config_json" {
  filename = "${var.output_path}/config_${var.environnement}.json"
  content  = jsonencode({
    projet        = var.nom_projet
    environnement = var.environnement
    version       = var.version_app
    cree_par      = "Terraform Module config"
    timestamp     = timestamp()
  })
  file_permission = "0644"
}

resource "local_file" "config_yaml" {
  filename = "${var.output_path}/config_${var.environnement}.yaml"
  content  = <<-EOT
    projet: ${var.nom_projet}
    environnement: ${var.environnement}
    version: ${var.version_app}
    cree_par: "Terraform Module config"
  EOT
}
