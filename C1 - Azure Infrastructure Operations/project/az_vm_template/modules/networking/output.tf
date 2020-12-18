output "networking-output" {
  value = {
    location = azurerm_resource_group.main.location 
    resource_group_name     = azurerm_resource_group.main.name 
    virtual_network_id = azurerm_virtual_network.main.id
    virtual_network_name = azurerm_virtual_network.main.name
    subnet_id = azurerm_subnet.internal.id
    nsg_id = azurerm_network_security_group.internal.id
  }
}