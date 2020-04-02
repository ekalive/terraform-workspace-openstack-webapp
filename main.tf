variable "app_environment" {}

data "terraform_remote_state" "tenant_workspace" {
  backend = "remote"

  config = {
    organization = "KPSC"
    workspaces = {
      name = "openstack-tenants-${var.app_environment}"
    }
  }
}

module "mylabapp" {
  # source = "../../git/terraform-openstack-app"
  source  = "app.terraform.io/KPSC/app/openstack"
  version = "0.0.2"

  tenant_name       = data.terraform_remote_state.tenant_workspace.outputs.tenant_name
  app_name          = "web"
  app_environment   = var.app_environment
  app_network       = data.terraform_remote_state.tenant_workspace.outputs.network_name
  ext_net_name      = "public"
  subnet_resource   = data.terraform_remote_state.tenant_workspace.outputs.subnet_resource
}