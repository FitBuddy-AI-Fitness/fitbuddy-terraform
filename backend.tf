terraform {
  backend "azurerm" {
    resource_group_name  = "Aravind-RG-test"
    storage_account_name = "fitbuddytfstate" 
    container_name       = "tfstate"
    key                  = "terraform.tfstate" 
  }
}
