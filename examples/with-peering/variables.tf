variable "resource_group_name" {
  description = "Nome do Resource Group"
  type        = string
  default     = "rg-peering-example"
}

variable "location" {
  description = "Localização dos recursos Azure"
  type        = string
  default     = "East US"
}

variable "hub_vnet_name" {
  description = "Nome da Hub Virtual Network"
  type        = string
  default     = "vnet-hub"
}

variable "hub_vnet_address_space" {
  description = "Espaço de endereçamento da Hub VNET"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "spoke_vnet_name" {
  description = "Nome da Spoke Virtual Network"
  type        = string
  default     = "vnet-spoke"
}

variable "spoke_vnet_address_space" {
  description = "Espaço de endereçamento da Spoke VNET"
  type        = list(string)
  default     = ["10.1.0.0/16"]
}

variable "management_ip" {
  description = "IP ou CIDR para acesso de gerenciamento"
  type        = string
  default     = "0.0.0.0/0"

  validation {
    condition     = can(cidrhost(var.management_ip, 0))
    error_message = "O management_ip deve ser um CIDR válido (ex: 192.168.1.0/24 ou 0.0.0.0/0)."
  }
}

variable "tags" {
  description = "Tags para aplicar aos recursos"
  type        = map(string)
  default = {
    Environment = "Development"
    Project     = "NetworkModule"
    Example     = "VNETPeering"
    ManagedBy   = "Terraform"
  }
}
