data "github_team" "approval" {
  count = var.approval_team_slug != null ? 1 : 0
  slug  = var.approval_team_slug
}

resource "github_repository_environment" "ci" {
  for_each    = var.environments
  environment = "continuous-integration-${each.key}"
  repository  = github_repository.this.name
}

resource "github_repository_environment" "cd" {
  for_each    = var.environments
  environment = "live-${each.key}"
  repository  = github_repository.this.name

  dynamic "reviewers" {
    for_each = var.approval_team_slug != null && each.value.deploy_order > 0 ? [1] : []
    content {
      teams = [data.github_team.approval[0].id]
    }
  }
}
