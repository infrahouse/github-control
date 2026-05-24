locals {
  default_branch = "main"

  deploy_orders_numeric = sort(distinct([
    for _, env in var.environments : env.deploy_order
  ]))

  deploy_orders = [
    for order in local.deploy_orders_numeric : tostring(order)
  ]

  environments_by_order = {
    for order in local.deploy_orders :
    order => sort([
      for name, env in var.environments :
      name if tostring(env.deploy_order) == order
    ])
  }

  deploy_order_needs = {
    for idx, order in local.deploy_orders :
    order => idx > 0 ? local.deploy_orders[idx - 1] : null
  }

  required_checks = concat(
    [for env in keys(var.environments) : "Terraform Plan ${env}"],
    ["TruffleHog", "vulnerability-check"],
    var.checks,
  )
}
