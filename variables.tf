variable "api_service_v1s" {
  description = <<EOT
Map of api_service_v1s, attributes below
Required:
    - metadata (block):
        - annotations (optional)
        - generate_name (optional)
        - labels (optional)
        - name (optional)
    - spec (block):
        - ca_bundle (optional)
        - group (required)
        - group_priority_minimum (required)
        - insecure_skip_tls_verify (optional)
        - service (optional, block):
            - name (required)
            - namespace (required)
            - port (optional)
        - version (required)
        - version_priority (required)
EOT

  type = map(object({
    metadata = object({
      annotations   = optional(map(string))
      generate_name = optional(string)
      labels        = optional(map(string))
      name          = optional(string)
    })
    spec = object({
      ca_bundle                = optional(string)
      group                    = string
      group_priority_minimum   = number
      insecure_skip_tls_verify = optional(bool)
      service = optional(object({
        name      = string
        namespace = string
        port      = optional(number)
      }))
      version          = string
      version_priority = number
    })
  }))
  validation {
    condition = alltrue([
      for k, v in var.api_service_v1s : (
        v.spec.group_priority_minimum >= 0 && v.spec.group_priority_minimum <= 20000
      )
    ])
    error_message = "must be between 0 and 20000"
  }
  validation {
    condition = alltrue([
      for k, v in var.api_service_v1s : (
        v.spec.version_priority >= 0 && v.spec.version_priority <= 1000
      )
    ])
    error_message = "must be between 0 and 1000"
  }
  # Note: 1 additional provider-side validator is enforced at apply time but not mirrored as validation{} blocks here (bespoke or non-mechanically-translatable).
}

