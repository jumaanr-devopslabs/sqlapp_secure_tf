terraform {
  required_providers {
    azurerm={
        source="hashicorp/azurerm"
        version="3.17.0"
    }
  }
}
//This is how Terraform connects with Azure (provider)
provider "azurerm" {
  subscription_id = "6912d7a0-bc28-459a-9407-33bbba641c07"
  tenant_id = "70c0f6d9-7f3b-4425-a6b6-09b47643ec58"
  client_id = "3feda701-6a3d-4915-8d26-343827060a8e"
  client_secret = "kKH8Q~54-LwKs2lYfNj6ECD_VmAt-cKSllRG4bfE"
  features {    
  }
}

resource "azurerm_service_plan" "appsvcplnsqlwebapp01" {
  name                = "appsvcplnsqlwebapp01"
  resource_group_name = "rg-tfdeployment-eastus2"
  location            = "eastus2"
  os_type             = "Windows"
  sku_name            = "F1"
}

resource "azurerm_windows_web_app" "sqlwebapp01" {
  name                = "sqlwebapp01"
  resource_group_name = "rg-tfdeployment-eastus2"
  location            = "eastus2"
  service_plan_id     = azurerm_service_plan.appsvcplnsqlwebapp01.id

  site_config {
    always_on = false
    application_stack{
        current_stack="dotnet"
        dotnet_version="v6.0"
    }
  }

  depends_on = [
    azurerm_service_plan.appsvcplnsqlwebapp01
  ]
}

resource "azurerm_mssql_server" "sqlsvr4wsqlwebapp01" {
  name                         = "sqlsvr4wsqlwebapp01"
  resource_group_name          = "rg-tfdeployment-eastus2"
  location                     = "eastus2"
  version                      = "12.0"
  administrator_login          = "sqlusr"
  administrator_login_password = "Pa$$w0RdVa1iDaT3d"  
}

resource "azurerm_mssql_database" "appdb" {
  name           = "appdb"
  server_id      = azurerm_mssql_server.sqlsvr4wsqlwebapp01.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 2  
  sku_name       = "Basic"
  depends_on = [
    azurerm_mssql_server.sqlsvr4wsqlwebapp01
  ]
}