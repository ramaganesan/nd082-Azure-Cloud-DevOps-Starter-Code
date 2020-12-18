output "vmconfig-output" {
  value = {
    network_interface_ids = azurerm_network_interface.internal
    availability_set_id = azurerm_availability_set.main.id
  }
}