output "loadbalancer-output" {
  value = {
    loadbalancer_id = azurerm_lb.main.id 
    public_ip_address_id = azurerm_public_ip.main.id
    backend_address_pool_id = azurerm_lb_backend_address_pool.internal.id
    //nat_rule_id = azurerm_lb_nat_rule.internal.id
  }
}