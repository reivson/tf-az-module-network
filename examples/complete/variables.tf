variable "resource_group_name" {
  description = "Nome do Resource Group"
  type        = string
  default     = "rg-network-complete-example"
}

variable "location" {
  description = "Localização dos recursos Azure"
  type        = string
  default     = "East US"
}

variable "vnet_name" {
  description = "Nome da Virtual Network"
  type        = string
  default     = "vnet-complete-example"
}

variable "vnet_address_space" {
  description = "Espaço de endereçamento da VNET"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "dns_servers" {
  description = "Lista de servidores DNS personalizados"
  type        = list(string)
  default     = ["8.8.8.8", "8.8.4.4"]
}

variable "tags" {
  description = "Tags para aplicar aos recursos"
  type        = map(string)
  default = {
    Environment = "Development"
    Project     = "NetworkModule"
    Example     = "Complete"
    ManagedBy   = "Terraform"
  }
}
