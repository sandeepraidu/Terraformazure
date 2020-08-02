data "azurerm_client_config" "current" {
}

resource "azurerm_resource_group" "example" {
  name     = "my-resource-group"
  location = "West US"
}

resource "random_id" "server" {
  keepers = {
    ami_id = 1
  }

  byte_length = 8
}

resource "azurerm_key_vault" "example" {
  name                = format("%s%s", "kv", random_id.server.hex)
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  tenant_id           = data.azurerm_client_config.current.tenant_id

  sku_name = "premium"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "create",
      "get",
    ]

    secret_permissions = [
      "set",
      "get",
      "delete",
    ]
  }

  tags = {
    environment = "Production"
  }
}

resource "azurerm_key_vault_secret" "example" {
  name         = "secret-sauce"
  value        = "szechuan"
  key_vault_id = azurerm_key_vault.example.id

  tags = {
    environment = "Production"
  }
}