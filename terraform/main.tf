data "aap_inventory" "servers" {
  name              = var.inventory_name
  organization_name = var.organization_name
}

resource "aap_job" "configure_servers" {
  job_template_id = var.job_template_id
  inventory_id    = data.aap_inventory.servers.id
  extra_vars      = jsonencode(var.job_extra_vars)

  wait_for_completion = true
  triggers = var.run_job_on_variable_changes ? {
    inventory_id = tostring(data.aap_inventory.servers.id)
    extra_vars   = sha256(jsonencode(var.job_extra_vars))
  } : {}
}
