data "azurerm_container_registry" "acr" {
  name                = "${azurerm_container_registry.acr.name}"
  resource_group_name = local.resource_group
}
resource "azurerm_app_service_plan" "assessment" {
  name                = "${local.prefix}serviceplan"
  location            = local.location
  resource_group_name = local.resource_group
  kind                = "Linux"
  reserved            = true
  tags                = local.tags

  sku {
    tier = "Standard"
    size = "S1"
  }
}
resource "azurerm_app_service" "assessment" {
  name                = "${local.prefix}appservice"
  location            = local.location
  resource_group_name = local.resource_group
  app_service_plan_id = "${azurerm_app_service_plan.assessment.id}"
  tags                = local.tags
  site_config {
    linux_fx_version  = "DOCKER|devopsassessment.azurecr.io/devops-assessment:latest"
  }
    app_settings = {
    "DOCKER_REGISTRY_SERVER_USERNAME" = "devopsassessment"
    "DOCKER_REGISTRY_SERVER_URL" = "https://devopsassessment.azurecr.io"
    "DOCKER_REGISTRY_SERVER_PASSWORD" = "${data.azurerm_container_registry.acr.admin_password}"
    "DOCKER_ENABLE_CI" = "true"
  }
}
data "azurerm_app_service_plan" "assessment" {
  name                = "${azurerm_app_service_plan.assessment.name}"
  resource_group_name = local.resource_group
}
resource "azurerm_monitor_autoscale_setting" "assessment" {
  name                = "myAutoscaleSetting"
  resource_group_name = local.resource_group
  location            = local.location
  target_resource_id  = "${data.azurerm_app_service_plan.assessment.id}"
  depends_on          = [azurerm_app_service.assessment]

  profile {
    name = "defaultProfile"

    capacity {
      default = 1
      minimum = 1
      maximum = 3
    }

    rule {
      metric_trigger {
        metric_name        = "CpuPercentage"
        metric_resource_id = "${data.azurerm_app_service_plan.assessment.id}"
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 75
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "CpuPercentage"
        metric_resource_id = "${data.azurerm_app_service_plan.assessment.id}"
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 25
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
  }

  notification {
    email {
      send_to_subscription_administrator    = true
      send_to_subscription_co_administrator = true
      custom_emails                         = ["callum.wyres@gmail.com"]
    }
  }
}
