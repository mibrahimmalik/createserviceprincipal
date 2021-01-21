# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
     # source = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  } 

  backend "azurerm" {
    resource_group_name  = "MainRG"
    storage_account_name = "mittfstate"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
  }

}

provider "azurerm" {
  features {}
  //version = ">= 2.26"
 
  #subscription_id = var.subscription_id
  #client_id = var.client_id
  #client_secret = var.client_secret
  #tenant_id = var.tenant_id
}

provider "azuread" {
  //version = ">= 2.26"
 
  #subscription_id = var.subscription_id
  #client_id = var.client_id
  #client_secret = var.client_secret
  #tenant_id = var.tenant_id
}

resource "azuread_application" "appreg" {
  name                       = "appreg"
  homepage                   = "http://localhost"
  identifier_uris            = ["http://localhost"]
  reply_urls                 = ["http://localhost"]
  available_to_other_tenants = false
  oauth2_allow_implicit_flow = true
}

resource "azuread_service_principal" "sp" {
  application_id               = azuread_application.appreg.application_id
  app_role_assignment_required = false

  tags = ["example", "tags", "here"]
}

resource "azuread_service_principal_password" "createsppwd" {
  service_principal_id = azuread_service_principal.sp.id
  description          = "My managed password"
  value                = "VT=uSgbTanZhyz@%nL9Hpd+Tfay_MRV#"
  end_date             = "2099-01-01T01:02:03Z"
}

data "azurerm_subscription" "primary" {
}

resource "azurerm_role_assignment" "roleassignment" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.sp.id
}