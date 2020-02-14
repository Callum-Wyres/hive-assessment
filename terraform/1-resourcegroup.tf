resource "azurerm_resource_group" "devopsassessment" {
  name     = "assessment"
  location = local.location
  tags     = local.tags
}