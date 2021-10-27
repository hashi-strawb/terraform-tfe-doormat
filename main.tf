terraform {
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "0.26.1"
    }
  }
}

resource "time_rotating" "rotate_every_n_hours" {
  rotation_hours = var.rotate_every_n_hours
}

# Wait a random time before refreshing
# so we don't hit Okta API rate limiting
resource "random_integer" "wait_time" {
  min = 1
  max = 5000
}
resource "time_sleep" "wait" {
  create_duration = "${random_integer.wait_time.result}ms"
}

# Refresh our Doormat credentials
resource "null_resource" "doormat-refresh" {
  depends_on = [time_sleep.wait]

  # Run every time
  triggers = {
    rotation = time_rotating.rotate_every_n_hours.unix
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
