resource "azurerm_resource_group" "resource_group" {
    name = "Auth-Demo"
    location = "eastus"
    tags = {
      "Owner" = "Sample"
    }
}
resource "azuread_application" "adSample" {
  name = "adSample"
}

resource "azuread_application_app_role" "app_role" {
  application_object_id = azuread_application.adSample.id
  allowed_member_types  = ["User"]
  description           = "Admins can manage roles and perform all task actions"
  display_name          = "Admin"
  is_enabled            = true
  value                 = "administer"
}

resource "azurerm_api_management" "SampleAPI" {
    name = "APISample"
    location = azurerm_resource_group.resource_group.location
    resource_group_name = azurerm_resource_group.resource_group.name
    publisher_name = "SampleAPI"
    publisher_email = var.publisher_email

    sku_name = "Developer_1"
}


#Create a new endpoint called MyFirstAPI
resource "azurerm_api_management_api" "SampleAPI" {
    name = var.azurerm_api_management_api_name
    api_management_name = azurerm_api_management.SampleAPI.name
    resource_group_name = azurerm_resource_group.resource_group.name
    revision = "1"
    display_name = "MyFirstAPI"
    path = "myapi"
    protocols = [ "https", "http" ]
    service_url = "http://conferenceapi.azurewebsites.net"
    import {
        content_format = "swagger-link-json"
        content_value = "http://conferenceapi.azurewebsites.net/?format=json"
    }
}

resource "azurerm_api_management_api_policy" "example" {
  api_name            = azurerm_api_management_api.SampleAPI.name
  api_management_name = azurerm_api_management_api.SampleAPI.api_management_name
  resource_group_name = azurerm_api_management_api.SampleAPI.resource_group_name

  xml_content = file("api_policy.xml")
}
