resource "github_repository_file" "gitignore" {
  count = var.archived ? 0 : 1
  depends_on = [
    github_repository_ruleset.main
  ]
  repository          = github_repository.this.name
  file                = ".gitignore"
  content             = file("${path.module}/templates/gitignore")
  commit_message      = "Add .gitignore"
  overwrite_on_create = false
  lifecycle {
    ignore_changes = [content]
  }
}

resource "github_repository_file" "makefile_root" {
  count = var.archived ? 0 : 1
  depends_on = [
    github_repository_ruleset.main
  ]
  repository          = github_repository.this.name
  file                = "Makefile"
  content             = file("${path.module}/templates/Makefile.root")
  commit_message      = "Add root Makefile"
  overwrite_on_create = true
}

resource "github_repository_file" "makefile_fragment" {
  count = var.archived ? 0 : 1
  depends_on = [
    github_repository_ruleset.main
  ]
  repository          = github_repository.this.name
  file                = "makefiles/Makefile"
  content             = file("${path.module}/templates/makefile.mk")
  commit_message      = "Add makefiles/Makefile"
  overwrite_on_create = true
}

resource "github_repository_file" "makefile_env" {
  for_each = var.archived ? {} : var.environments
  depends_on = [
    github_repository_ruleset.main
  ]
  repository          = github_repository.this.name
  file                = "environments/${each.key}/Makefile"
  content             = file("${path.module}/templates/Makefile.env")
  commit_message      = "Add Makefile for ${each.key} environment"
  overwrite_on_create = true
}

resource "github_repository_file" "requirements_txt" {
  for_each = var.archived ? {} : var.environments
  depends_on = [
    github_repository_ruleset.main
  ]
  repository          = github_repository.this.name
  file                = "environments/${each.key}/requirements.txt"
  content             = file("${path.module}/templates/requirements.txt")
  commit_message      = "Add requirements.txt for ${each.key} environment"
  overwrite_on_create = false
  lifecycle {
    ignore_changes = [content]
  }
}

resource "github_repository_file" "terraform_tf" {
  for_each            = var.environments
  repository          = github_repository.this.name
  file                = "environments/${each.key}/terraform.tf"
  overwrite_on_create = true
  content = templatefile("${path.module}/templates/terraform.tf.tftpl", {
    state_bucket             = var.state_bucket
    environment              = each.key
    region                   = each.value.region
    state_manager_role_arn   = each.value.state_manager_role_arn
    aws_provider_constraint  = var.aws_provider_constraint
    extra_required_providers = var.extra_required_providers
  })
  commit_message = "Add terraform.tf for ${each.key} environment"
  branch         = local.default_branch
}

resource "github_repository_file" "terraform_tfvars" {
  for_each            = var.environments
  repository          = github_repository.this.name
  file                = "environments/${each.key}/terraform.tfvars"
  overwrite_on_create = true
  content = templatefile("${path.module}/templates/terraform.tfvars.tftpl", {
    state_manager_role_arn = each.value.state_manager_role_arn
    admin_role_arn         = each.value.admin_role_arn
    github_role_arn        = each.value.github_role_arn
    gh_org_name            = var.gh_org_name
    repo_name              = var.repo_name
    region                 = each.value.region
  })
  commit_message = "Add terraform.tfvars for ${each.key} environment"
  branch         = local.default_branch
  lifecycle {
    ignore_changes = [content]
  }
}

resource "github_repository_file" "releases_auto_tfvars" {
  for_each            = var.environments
  repository          = github_repository.this.name
  file                = "environments/${each.key}/releases.auto.tfvars"
  overwrite_on_create = true
  content             = file("${path.module}/templates/releases.auto.tfvars.tftpl")
  commit_message      = "Add releases.auto.tfvars for ${each.key} environment"
  branch              = local.default_branch
  lifecycle {
    ignore_changes = [content]
  }
}
