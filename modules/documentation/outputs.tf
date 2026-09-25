output "chemin_readme" {
  value = local_file.readme.filename
}
output "fichiers_crees" {
  value = [local_file.readme.filename]
}
