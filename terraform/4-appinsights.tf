resource "azurerm_application_insights" "appinsight" {
  name                = "${local.prefix}app-insights"
  location            = local.location
  resource_group_name = local.resource_group
  application_type    = "Node.JS"
  tags                = local.tags
}
