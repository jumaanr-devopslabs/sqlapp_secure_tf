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
  subscription_id = "09688c0b-8d07-41e6-ad43-b4a1b7329fbc"
  tenant_id = "db3d8c78-490e-4a2a-bda4-069bab4ae0b6"
  client_id = "45b71058-945c-4277-8ed6-d8d5db7c303b"
  client_secret = "UzQ8Q~S~GZz3h4ej4udc7lsekP.wYl1ba~aw_b6X"
  features {    
  }
}

resource "azurerm_service_plan" "appsvcplnsqlwebapp03" {
  name                = "appsvcplnsqlwebapp03"
  resource_group_name = "rg-tfdeployment-eastus2"
  location            = "eastus2"
  os_type             = "Windows"
  sku_name            = "F1"
}

resource "azurerm_windows_web_app" "sqlwebapp03" {
  name                = "sqlwebapp03"
  resource_group_name = "rg-tfdeployment-eastus2"
  location            = "eastus2"
  service_plan_id     = azurerm_service_plan.appsvcplnsqlwebapp03.id

  site_config {
    always_on = false
    application_stack{
        current_stack="dotnet"
        dotnet_version="v6.0"
    }
  }

  depends_on = [
    azurerm_service_plan.appsvcplnsqlwebapp03
  ]
}

resource "azurerm_mssql_server" "sqlsvr4wsqlwebapp03" {
  name                         = "sqlsvr4wsqlwebapp03"
  resource_group_name          = "rg-tfdeployment-eastus2"
  location                     = "eastus2"
  version                      = "12.0"
  administrator_login          = "sqlusr"
  administrator_login_password = "Pa$$w0RdVa1iDaT3d"  
}

resource "azurerm_mssql_database" "appdb" {
  name           = "appdb"
  server_id      = azurerm_mssql_server.sqlsvr4wsqlwebapp03.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 2  
  sku_name       = "Basic"
  depends_on = [
    azurerm_mssql_server.sqlsvr4wsqlwebapp03
  ]
}