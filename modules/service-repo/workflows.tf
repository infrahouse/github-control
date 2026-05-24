resource "github_repository_file" "terraform_ci" {
  count = var.archived ? 0 : 1
  depends_on = [
    github_repository_ruleset.main
  ]
  repository = github_repository.this.name
  file       = ".github/workflows/terraform-CI.yml"
  content = templatefile(
    "${path.module}/templates/terraform-CI.yml.tftpl",
    {
      environments = sort(keys(var.environments))
    }
  )
  commit_message      = "Add terraform-CI.yml workflow"
  overwrite_on_create = true
}

resource "github_repository_file" "terraform_cd" {
  count = var.archived ? 0 : 1
  depends_on = [
    github_repository_ruleset.main
  ]
  repository = github_repository.this.name
  file       = ".github/workflows/terraform-CD.yml"
  content = templatefile(
    "${path.module}/templates/terraform-CD.yml.tftpl",
    {
      deploy_orders         = local.deploy_orders
      environments_by_order = local.environments_by_order
      deploy_order_needs    = local.deploy_order_needs
    }
  )
  commit_message      = "Add terraform-CD.yml workflow"
  overwrite_on_create = true
}

resource "github_repository_file" "terraform_drift" {
  count = var.archived ? 0 : 1
  depends_on = [
    github_repository_ruleset.main
  ]
  repository          = github_repository.this.name
  file                = ".github/workflows/terraform-drift.yml"
  content             = file("${path.module}/templates/terraform-drift.yml")
  commit_message      = "Add terraform-drift.yml workflow"
  overwrite_on_create = true
}

resource "random_integer" "minute" {
  min = 0
  max = 59
}

resource "github_repository_file" "terraform_drift_wrapper" {
  count = var.archived ? 0 : 1
  depends_on = [
    github_repository_ruleset.main
  ]
  repository = github_repository.this.name
  file       = ".github/workflows/terraform-drift-wrapper.yml"
  content = templatefile(
    "${path.module}/templates/terraform-drift-wrapper.yml.tftpl",
    {
      random_minute = random_integer.minute.result
      environments  = keys(var.environments)
    }
  )
  commit_message      = "Add terraform-drift-wrapper.yml workflow"
  overwrite_on_create = true
}

resource "github_repository_file" "secrets_scanner" {
  count = var.archived ? 0 : 1
  depends_on = [
    github_repository_ruleset.main
  ]
  repository          = github_repository.this.name
  file                = ".github/workflows/secrets-scanner.yml"
  content             = file("${path.module}/templates/secrets-scanner.yml")
  commit_message      = "Add secrets-scanner.yml workflow"
  overwrite_on_create = true
}

resource "github_repository_file" "vuln_scanner" {
  count = var.archived ? 0 : 1
  depends_on = [
    github_repository_ruleset.main
  ]
  repository          = github_repository.this.name
  file                = ".github/workflows/vuln-scanner-pr.yml"
  content             = file("${path.module}/templates/vuln-scanner-pr.yml")
  commit_message      = "Add vuln-scanner-pr.yml workflow"
  overwrite_on_create = true
}
