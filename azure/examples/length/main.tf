variable "rg_quantity" {
  description = "Type a number to create a quanity of resources"
  default = 0
}

variable "rg_list" {
  type    = list(string)
  default = ["a", "b", "c", "d"]
}

resource "azurerm_resource_group" "name" {
  count = length(var.rg_list)
  name = "${element(var.rg_list, count.index)}-rg"
  location = var.location
}