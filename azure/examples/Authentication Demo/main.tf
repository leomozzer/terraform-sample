resource "azurerm_resource_group" "resource_group" {
    name = "Auth-Demo"
    location = "eastus"
    tags = {
      "Owner" = "Leonardo"
    }
}