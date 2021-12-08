# ----------------------------------------
# Variables for certificate
# ----------------------------------------

variable "validity_period_hours_ca" {
  description = " The number of hours after initial issuing that the certificate will become invalid. Default is 10 years."
  type        = number
  default     = 87660
}

variable "validity_period_hours_issuer" {
  description = " The number of hours after initial issuing that the certificate will become invalid. Default is 1 year."
  type        = number
  default     = 8760
}

variable "subject_common_name" {
  description = "The domain name you wish to secure with your certificate."
  type        = string
  default     = "identity.linkerd.cluster.local"
}

variable "subject_organization" {
  description = "Organization name."
  type        = string
  default     = null
}

variable "allowed_uses" {
  description = "List of keywords each describing a use that is permitted for the issued certificate."
  type        = list(any)
  default = [
    "crl_signing",
    "cert_signing",
    "server_auth",
    "client_auth"
  ]
}

# ----------------------------------------
# Variables for linkerd helm chart
# ----------------------------------------

variable "linkerd_version" {
  description = "The version of linkerd2 chart."
  type        = string
  default     = "2.10.2"
}

variable "linkerd_variables" {
  description = "You can provide extra varaibles to the linkerd chart"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "linkerd_production_enable" {
  description = "Enable HA deploying for production environment."
  type        = bool
  default     = false
}

variable "linkerd_services_resources" {
  description = "This is default variables that will be added for all services. You can override it."
  type = object({
    cpu_request    = string
    cpu_limit      = string
    memory_request = string
    memory_limit   = string
  })
  default = {
    cpu_request    = "100m"
    cpu_limit      = "500m"
    memory_request = "50Mi"
    memory_limit   = "250Mi"
  }
}

# ----------------------------------------
# Variables for linkerd VIZ helm chart
# ----------------------------------------

variable "viz_create" {
  description = "Deploy linkerd viz to the cluster."
  type        = bool
  default     = false
}

variable "viz_variables" {
  description = "You can provide extra varaibles to the linkerd-viz chart"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "viz_production_enable" {
  description = "Enable HA deploying for production environment."
  type        = bool
  default     = false
}

variable "viz_services_resources" {
  description = "This is default variables that will be added for all services. You can override it."
  type = object({
    cpu_request    = string
    cpu_limit      = string
    memory_request = string
    memory_limit   = string
  })
  default = {
    cpu_request    = "100m"
    cpu_limit      = "500m"
    memory_request = "50Mi"
    memory_limit   = "250Mi"
  }
}
