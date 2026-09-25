# ============================================================
#  MODULE : documentation
#  Génère la documentation du projet
# ============================================================

resource "local_file" "readme" {
  filename = "${var.output_path}/README_${var.nom_projet}.md"
  content  = <<-EOT
    # ${var.nom_projet} — ${var.environnement}

    **Version :** ${var.version_app}
    **Généré par :** Terraform Module documentation

    ## Base de données
    - Host : ${var.db_host}

    ## Fichiers de configuration
    - Config : ${var.config_path}
    - Pipeline : ${var.pipeline_info.id}
    - Schedule : ${var.pipeline_info.schedule}

    > Ce fichier est généré automatiquement par Terraform.
  EOT
}
