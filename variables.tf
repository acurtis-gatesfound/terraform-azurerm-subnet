variable "name" {
  description = "The name of the subnet"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the subnet"
  type        = string
}

variable "virtual_network_name" {
  description = "The name of the virtual network in which to create the subnet"
  type        = string
}

variable "address_prefixes" {
  description = "The address prefixes to use for the subnet"
  type        = list(string)
}

variable "default_outbound_access_enabled" {
  description = "Is default outbound access enabled?"
  type        = bool
  default     = true
}

variable "private_endpoint_network_policies" {
  description = "The network policies for private endpoints on the subnet"
  type        = string
  default     = "Disabled"

  validation {
    condition     = contains(["Disabled", "Enabled", "NetworkSecurityGroupEnabled", "RouteTableEnabled"], var.private_endpoint_network_policies)
    error_message = "Private endpoint network policices must be one of Disabled, Enabled, NetworkSecurityGroupEnabled, or RouteTableEnabled"
  }
}

variable "private_link_service_network_policies" {
  description = "The network policies for private link service on the subnet"
  type        = bool
  default     = true
}

variable "service_endpoints" {
  description = "The service endpoints to associate with the subnet"
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for endpoint in var.service_endpoints : contains([
        "Microsoft.AzureActiveDirectory",
        "Microsoft.AzureCosmosDB",
        "Microsoft.ContainerRegistry",
        "Microsoft.EventHub",
        "Microsoft.KeyVault",
        "Microsoft.ServiceBus",
        "Microsoft.Sql",
        "Microsoft.Storage",
        "Microsoft.Storage.Global",
        "Microsoft.Web"
      ], endpoint)
    ])
    error_message = "Each service endpoint must contain the following: Microsoft.AzureActiveDirectory, Microsoft.AzureCosmosDB, Microsoft.ContainerRegistry, Microsoft.EventHub, Microsoft.KeyVault, Microsoft.ServiceBus, Microsoft.Sql, Microsoft.Storage, Microsoft.Storage.Global, Microsoft.Web."
  }
}

variable "service_endpoint_policy_ids" {
  description = "The IDs of the service endpoint policies to associate with the subnet"
  type        = list(string)
  default     = []
}

variable "delegation" {
  description = "The delegations for the subnet"
  type = object({
    name = string
    service_delegation = object({
      name    = string
      actions = list(string)
    })
  })
  default = null
}
