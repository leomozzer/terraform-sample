resource "azurerm_api_management" "SampleAPI4IQ3" {
    name = "APISampleLeonardo"
    location = azurerm_resource_group.rgLeonardo4Iq3.location
    resource_group_name = azurerm_resource_group.rgLeonardo4Iq3.name
    publisher_name = "SampleAPI"
    publisher_email = var.publisher_email

    sku_name = "Developer_1"
}

resource "azurerm_api_management_api" "SampleAPI4IQ3MAPI" {
    name = var.azurerm_api_management_api_name
    api_management_name = azurerm_api_management.SampleAPI4IQ3.name
    resource_group_name = azurerm_resource_group.rgLeonardo4Iq3.name
    revision = "1"
    display_name = "MyFirstAPI"
    path = ""
    protocols = [ "https", "http" ]
    service_url = "http://conferenceapi.azurewebsites.net"
    import {
        content_format = "swagger-link-json"
        content_value = "http://conferenceapi.azurewebsites.net/?format=json"
    }
}