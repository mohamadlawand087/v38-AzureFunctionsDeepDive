terraform {
  required_providers {
            azurerm = {
                source = "hashicorp/azurerm"
                version = "=2.67.0"
        }
    }
}

provider "azurerm" {
    features {
      
    }
}

# Create a resource group
resource "azurerm_resource_group" "az_func_rg" {
  name = "azure-functions-demo-rg"
  location = "uksouth"
}

resource "azurerm_storage_account" "azfuncstorage" {
  name = "azurefuncstorageyt"
  resource_group_name = azurerm_resource_group.az_func_rg.name
  location = azurerm_resource_group.az_func_rg.location
  account_tier = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "az-func-sp" {
  name = "azure-functions-service-plan"
  location = azurerm_resource_group.az_func_rg.location
  resource_group_name = azurerm_resource_group.az_func_rg.name
  kind = "Linux"
  reserved = true
  
  sku {
      tier = "Dynamic"
      size = "Y1"
  }
}

resource "azurerm_function_app" "super-az-func" {
    name = "super-az-func"
    location = azurerm_resource_group.az_func_rg.location
    resource_group_name = azurerm_resource_group.az_func_rg.name
    app_service_plan_id = azurerm_app_service_plan.az-func-sp.id
    storage_account_access_key = azurerm_storage_account.azfuncstorage.primary_access_key
    storage_account_name = azurerm_storage_account.azfuncstorage.name
    os_type = "linux"
}
