output "inventory_id" {
  description = "ID of the existing AWX inventory used by the job."
  value       = data.aap_inventory.servers.id
}

output "inventory_url" {
  description = "URL of the existing AWX inventory."
  value       = data.aap_inventory.servers.url
}

output "job_url" {
  description = "URL of the most recently launched configuration job."
  value       = aap_job.configure_servers.url
}
