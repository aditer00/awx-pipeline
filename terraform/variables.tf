variable "awx_url" {
  description = "Base URL for the AWX/AAP controller, for example https://awx.example.com."
  type        = string
}

variable "inventory_name" {
  description = "Name of the existing AWX inventory to use."
  type        = string
}

variable "organization_name" {
  description = "Name of the AWX organization that owns the existing inventory."
  type        = string
}

variable "job_template_id" {
  description = "ID of the AWX Job Template that configures the Linux servers."
  type        = number
}

variable "job_extra_vars" {
  description = "Additional variables passed to the AWX Job Template at launch."
  type        = any
  default     = {}
}

variable "run_job_on_variable_changes" {
  description = "Launch the AWX job when job extra variables change."
  type        = bool
  default     = true
}
