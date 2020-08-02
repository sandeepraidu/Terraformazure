resource "azurerm_resource_group" "example" {
  name     = "A1SBAMSRSG01xx"
  location = "centralus"
}

resource "azurerm_storage_account" "example" {
  name                     = "a3qaentasstoragexx"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "example" {
  name                = "A3QAENTASE01xx"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  sku {
    tier = "Basic"
    size = "B1"
  }
}

resource "azurerm_function_app" "example" {
  name                      = "ttipsfuncappxx"
  location                  = azurerm_resource_group.example.location
  resource_group_name       = azurerm_resource_group.example.name
  app_service_plan_id       = azurerm_app_service_plan.example.id
  storage_account_name      = azurerm_storage_account.example.name
  storage_account_access_key = azurerm_storage_account.example.primary_access_key
  

  
  os_type                   = "linux"
  version                   = "~3"



  app_settings = {
    "https_only"                            ="true"
    "FUNCTIONS_WORKER_RUNTIME"              = "python"
    "WEBSITE_RUN_FROM_PACKAGE"              = ""
    "WEBSITE_NODE_DEFAULT_VERSION"          = "10.14.1"
    "APPINSIGHTS_INSTRUMENTATIONKEY"        = ""
  }
  

}