variable "aws_account" {
  type        = string
  description = "The AWS Account to get credentials for"
}

variable "tfc_org" {
  type        = string
  description = "The TFC Organization to push credentials to"
}

variable "tfc_workspace" {
  type        = string
  description = "The TFC Workspace to push credentials to"
}

variable "rotate_every_n_hours" {
  type        = number
  description = "How frequently should the provider run a doormat refresh and push new creds to TFC?"
  default     = 1
}
