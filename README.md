# 🏗️ Jour 2 / 10 — Terraform : Modules

> **Série : 10 Days of Terraform** · Jour 2/10  
> Concepts : Module · source · Input/Output · locals · Réutilisabilité

---

## 📁 Structure du projet

```
day-02-modules/
│
├── main.tf                        ← Root module — appelle les 3 modules
├── variables.tf                   ← Variables du root module
├── outputs.tf                     ← Outputs agrégés
├── terraform.tfvars               ← Valeurs des variables
├── output/                        ← Fichiers générés (vide au départ)
│
└── modules/
    ├── config/
    │   ├── main.tf                ← Génère config JSON + YAML
    │   ├── variables.tf           ← Inputs du module
    │   └── outputs.tf             ← Outputs du module
    ├── pipeline/
    │   ├── main.tf                ← Génère config pipeline + .env
    │   ├── variables.tf
    │   └── outputs.tf
    └── documentation/
        ├── main.tf                ← Génère le README
        ├── variables.tf
        └── outputs.tf
```

---

## 🧠 C'est quoi un module Terraform ?

```
Module = dossier de fichiers .tf réutilisables

Root module  = le dossier principal (là où tu lances terraform)
Child module = un sous-dossier appelé via "source"

Sans modules : tout dans un seul main.tf → difficile à maintenir
Avec modules : code organisé, réutilisable, testable
```

---

## 🚀 ÉTAPE 1 — Créer la structure

```bash
mkdir -p jour2-terraform/modules/config
mkdir -p jour2-terraform/modules/pipeline
mkdir -p jour2-terraform/modules/documentation
mkdir -p jour2-terraform/output
cd jour2-terraform/

# Copier les fichiers depuis le dépôt :
# main_j2.tf              → main.tf
# variables_j2.tf         → variables.tf
# outputs_j2.tf           → outputs.tf
# tfvars_j2.tf            → terraform.tfvars

# module_config_main.tf       → modules/config/main.tf
# module_config_variables.tf  → modules/config/variables.tf
# module_config_outputs.tf    → modules/config/outputs.tf

# module_pipeline_main.tf     → modules/pipeline/main.tf
# module_pipeline_variables.tf→ modules/pipeline/variables.tf
# module_pipeline_outputs.tf  → modules/pipeline/outputs.tf

# module_doc_main.tf          → modules/documentation/main.tf
# module_doc_variables.tf     → modules/documentation/variables.tf
# module_doc_outputs.tf       → modules/documentation/outputs.tf
```

---

## 🔑 ÉTAPE 2 — Appeler un module

```hcl
# Dans main.tf du root module

module "config_projet" {
  source = "./modules/config"   # chemin vers le module

  # Inputs : valeurs passées au module
  nom_projet    = var.nom_projet
  environnement = var.environnement
  output_path   = "${path.module}/output"
}

# Utiliser un output d'un module dans un autre module
module "pipeline_etl" {
  source = "./modules/pipeline"

  config_path = module.config_projet.chemin_config
  # ↑ output du module config utilisé comme input du module pipeline
}
```

---

## 🔑 ÉTAPE 3 — Structure d'un module

### variables.tf du module — les inputs

```hcl
# Chaque variable = un input attendu par le module
variable "nom_projet" {
  type = string
  # Pas de default → obligatoire
}
variable "output_path" {
  type = string
}
```

### main.tf du module — les resources

```hcl
# locals = valeurs calculées internes au module
locals {
  db_name     = "${var.nom_projet}_${var.environnement}"
  pipeline_id = "${var.nom_projet}-${var.environnement}-etl"
}

resource "local_file" "config" {
  filename = "${var.output_path}/config.json"
  content  = jsonencode({
    db_name = local.db_name   # utilise un local
  })
}
```

### outputs.tf du module — les sorties

```hcl
# Ce que le module expose au root module
output "chemin_config" {
  value = local_file.config.filename
}
output "fichiers_crees" {
  value = [local_file.config.filename]
}
```

---

## 🚀 ÉTAPE 4 — Initialiser et appliquer

```bash
# Init — télécharge les providers pour le root ET les modules
terraform init

# Résultat :
# Initializing modules...
# - config_projet in modules/config
# - pipeline_etl in modules/pipeline
# - documentation in modules/documentation

terraform plan

# Résultat :
# module.config_projet.local_file.config_json    will be created
# module.config_projet.local_file.config_yaml    will be created
# module.pipeline_etl.local_file.pipeline_config will be created
# module.pipeline_etl.local_file.env_file        will be created
# module.documentation.local_file.readme         will be created
# Plan: 5 to add, 0 to change, 0 to destroy.

terraform apply -auto-approve
```

---

## 🚀 ÉTAPE 5 — Vérifier les fichiers générés

```bash
ls output/
# config_dev.json
# config_dev.yaml
# pipeline_dev.json
# .env_dev
# README_etl_portfolio.md

cat output/config_dev.json
cat output/pipeline_dev.json
cat output/README_etl_portfolio.md
```

---

## 🔑 ÉTAPE 6 — Voir les outputs

```bash
# Tous les outputs du root module
terraform output

# Un output spécifique
terraform output resume_deploiement
terraform output tous_les_fichiers

# Format JSON (pour les scripts)
terraform output -json tous_les_fichiers
```

---

## 🚀 ÉTAPE 7 — Tester avec un autre environnement

```bash
# Changer l'environnement sans modifier le code
terraform apply -var="environnement=prod" -auto-approve

# Les fichiers générés s'appellent maintenant :
# config_prod.json
# pipeline_prod.json
# .env_prod

# Revenir en dev
terraform apply -var="environnement=dev" -auto-approve
```

---

## 🔑 ÉTAPE 8 — Lister les ressources par module

```bash
# State organisé par module
terraform state list

# Résultat :
# module.config_projet.local_file.config_json
# module.config_projet.local_file.config_yaml
# module.documentation.local_file.readme
# module.pipeline_etl.local_file.env_file
# module.pipeline_etl.local_file.pipeline_config

# Voir une ressource d'un module
terraform state show module.config_projet.local_file.config_json
```

---

## 💡 Bonnes pratiques modules

| Pratique | Pourquoi |
|----------|----------|
| Un module = une responsabilité | Config séparé de pipeline |
| Toujours déclarer les outputs | Permet la composition de modules |
| Valider les inputs | validation {} dans variables.tf |
| Pas de provider dans les modules | Le root module s'en charge |
| Documenter avec description | Chaque variable et output |

---



---

⭐ **Si ce projet t'aide, mets une étoile !**
