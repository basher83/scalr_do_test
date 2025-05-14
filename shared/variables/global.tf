variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    managed-by = "terraform"
    project    = "scalr-test"
  }
}

variable "scalr_hostname" {
  description = "Scalr hostname"
  type        = string
  default     = "the-mothership.scalr.io"
}