variable "resource_group_name" {
  description = "Nome do Resource Group"
  type        = string
  default     = "rg-network-basic-example"
}

variable "location" {
  description = "Localização dos recursos Azure"
  type        = string
  default     = "East US"
}

variable "vnet_name" {
  description = "Nome da Virtual Network"
  type        = string
  default     = "vnet-basic-example"
}

variable "vnet_address_space" {
  description = "Espaço de endereçamento da VNET"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "tags" {
  description = "Tags para aplicar aos recursos"
  type        = map(string)
  default = {
    Environment = "Development"
    Project     = "NetworkModule"
    Example     = "Basic"
  }
}
