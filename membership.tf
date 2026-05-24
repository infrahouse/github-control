resource "github_membership" "infrahouse" {
  for_each = local.team_members
  username = each.key
  role     = each.value.role
}
