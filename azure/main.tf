terraform {
  required_version = ">= 1.7.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket         = "cloudshop-tfstate-roger"
    key            = "azure/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "cloudshop-tfstate-lock"
    encrypt        = true
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

resource "azurerm_resource_group" "main" {
  name     = "${var.project_name}-rg"
  location = var.location

  tags = {
    Project     = var.project_name
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

module "vnet" {
  source              = "./modules/vnet"
  project_name        = var.project_name
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  vnet_cidr           = var.vnet_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
}

module "storage" {
  source              = "./modules/storage"
  project_name        = var.project_name
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
}

module "postgres" {
  source              = "./modules/postgres"
  project_name        = var.project_name
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  subnet_id           = module.vnet.private_subnet_id
  db_password         = var.db_password
}

module "vm" {
  source              = "./modules/vm"
  project_name        = var.project_name
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  subnet_id           = module.vnet.public_subnet_id
  admin_password      = var.admin_password
}

module "aks" {
  source              = "./modules/aks"
  project_name        = var.project_name
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  subnet_id           = module.vnet.public_subnet_id
}