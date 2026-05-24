locals {
  aws_default_region = "us-west-1"
  environment        = "production"
  root_sso_admin_arn = "arn:aws:iam::990466748045:role/aws-reserved/sso.amazonaws.com/us-west-1/AWSReservedSSO_AWSAdministratorAccess_16bdbe5eb442e7ef"

  gh_org_name = "infrahouse"

  team_members = {
    "akuzminsky" = {
      role = "member"
      teams = [
        github_team.dev.name,
        github_team.admins.name,
      ]
    }
    "infrahouse8" = {
      role = "admin"
      teams = [
        github_team.dev.name,
        github_team.admins.name,
      ]
    }
    "naumenko" = {
      role = "member"
      teams = [
        github_team.dev.name,
      ]
    }
  }
}
