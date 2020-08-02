
resource "azurerm_resource_group" "A1sandboxrg" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_virtual_network" "A1sandboxnw" {
  name                = "example-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.A1sandboxrg.location
  resource_group_name = azurerm_resource_group.A1sandboxrg.name
}

resource "azurerm_subnet" "A1sandboxnwsn" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.A1sandboxrg.name
  virtual_network_name = azurerm_virtual_network.A1sandboxnw.name
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_network_interface" "A1sandboxnwnic" {
  name                = "example-nic"
  location            = azurerm_resource_group.A1sandboxrg.location
  resource_group_name = azurerm_resource_group.A1sandboxrg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.A1sandboxnwsn.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "A1sandboxnwvm" {
  name                = "example-machine"
  resource_group_name = azurerm_resource_group.A1sandboxrg.name
  location            = azurerm_resource_group.A1sandboxrg.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.A1sandboxnwnic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}