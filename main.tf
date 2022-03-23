terraform {
  required_providers {
    tfe = {
      source = "hashicorp/tfe"
    }
  }
}

resource "time_rotating" "rotate_every_n_hours" {
  rotation_hours = var.rotate_every_n_hours
}

# Refresh our Doormat credentials
resource "null_resource" "doormat-refresh" {
  triggers = {
    rotation = time_rotating.rotate_every_n_hours.unix
  }

  provisioner "local-exec" {
    command     = "${path.module}/login.sh"
    interpreter = ["bash", "-c"]
  }
}

# Provide TFC with AWS credentials
resource "null_resource" "push-creds" {
  # Run every time
  triggers = {
    rotation = time_rotating.rotate_every_n_hours.unix
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
