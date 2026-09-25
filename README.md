# Terraform with AWX

This configuration looks up an existing AWX inventory and launches an existing AWX Job Template against it. AWX remains the source of truth for inventory and hosts; Terraform does not create, update, or delete them. The Ansible playbook in AWX is responsible for configuring operating systems and applications.

## AWX prerequisites

- Create an AWX organization and note its numeric ID.
- Create or synchronize the inventory and hosts in AWX before running Terraform. This configuration looks up the inventory by name and organization name.
- Push this repository to Git and create an AWX Project pointing to it. Set the project SCM branch/revision and enable **Update Revision on Launch** if AWX should pull the latest commit each run.
- Create an inventory-capable Job Template using the project and `playbooks/site.yml`. Enable **Prompt on launch** for Inventory so the inventory passed by Terraform can be selected.
- The playbook configures `desired_timezone` and optionally installs the package names in `packages`. Remove either variable from `job_extra_vars` to leave that setting untouched. It does not perform general OS upgrades or modify SSH access.
- The playbook uses the `community.general.timezone` module. AWX installs `collections/requirements.yml` during Project Sync, and its Execution Environment must be able to access the collection. Package installation uses the host's native package manager through Ansible's built-in `package` module.
- After adding or changing a collection requirement, run **Sync** on the AWX Project and confirm the sync succeeds before launching the Job Template. Updating the Git revision alone does not install a collection into an already-built Execution Environment.
- Attach the SSH machine credential and execution environment to the Job Template. Keep private keys and passwords in AWX credentials, not in Terraform variables.
- Create an AWX token for a service account with permission to manage the inventory/hosts and launch this Job Template.
- Ensure the AWX execution environment can reach the target Linux hosts over SSH.

## Configure and run

Copy `terraform/terraform.tfvars.example` to `terraform/terraform.tfvars` and replace the example URL, names, and Job Template ID. The copied tfvars file is ignored by Git.

Provide the token through the environment:

```sh
export AAP_TOKEN='your-awx-token'
cd terraform
terraform init
terraform plan -out=changes.tfplan
terraform apply changes.tfplan
```

Review the plan before applying. The inventory and its hosts are read from AWX; changes to them are not managed by Terraform. The job is launched when `job_extra_vars` change. With no changes, Terraform will not rerun the job. To intentionally rerun provisioning, change a job input or use `terraform apply -replace='aap_job.configure_servers'` after reviewing the plan.

The `aap_job` resource represents a job launch: destroying it removes it from Terraform state but does not delete the historical AWX job. Terraform plans do not inspect Linux package/file state or list individual AWX hosts through this configuration. Ansible idempotency is what makes a launched job safely reconcile server state.

## State and secrets

Terraform state may contain job variables. Do not commit state or plan files. Use an access-controlled remote backend with encryption and locking for shared/production use. Avoid putting passwords, private keys, or tokens in `job_extra_vars`; store connection secrets in AWX credentials.

For self-signed TLS, configure the provider's `insecure_skip_verify` only as a temporary development workaround. Prefer a trusted certificate in production.
