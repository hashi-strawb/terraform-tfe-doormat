terraform {
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "0.26.1"
    }
  }
}

# Refresh our Doormat credentials
resource "null_resource" "doormat-refresh" {
  # Run every time
  triggers = {
    timestamp = timestamp()
  }

  provisioner "local-exec" {
    command     = "doormat --smoke-test || doormat -r"
    interpreter = ["bash", "-c"]
  }
}

# Provide TFC with AWS credentials
resource "null_resource" "push-creds" {
  # Run every time
  triggers = {
    timestamp = timestamp()
  }

  # Ensure we have valid Doormat creds first
  depends_on = [
    null_resource.doormat-refresh,
  ]

  provisioner "local-exec" {
    command     = "doormat aws --account ${var.aws_account} --tf-push --tf-organization ${var.tfc_org} --tf-workspace ${var.tfc_workspace}"
    interpreter = ["bash", "-c"]
  }
}
