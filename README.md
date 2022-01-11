# terraform-tfe-doormat
Terraform module which allows you to deploy AWS credentials to a Terraform Cloud Workspace, using Doormat (an internal HashiCorp tool)


Example:

```
module "creds" {
  source  = "hashi-strawb/doormat/tfe"
  aws_account   = "my_fancy_aws_account"
  tfc_org       = "fancycorp"
  tfc_workspace = "my_fancy_workspace"
}
```

Particularly useful if you need to bootstrap a TFC org with several workspaces, each with credentials
