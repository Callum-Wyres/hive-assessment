resource "azurerm_container_registry" "acr" {
  name                     = "devopsassessment"
  resource_group_name      = local.resource_group 
  location                 = local.location
  sku                      = "Standard"
  admin_enabled            = true
  tags                     = local.tags
}