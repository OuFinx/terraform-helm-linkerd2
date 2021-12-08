locals {

  # The resource list is taken from https://github.com/linkerd/linkerd2/blob/main/charts/linkerd2/values-ha.yaml
  # `helm_release` doesn't support Anchors and links
  # So, we have to set the same varaibles for all services
  services_list = [
    "proxy.resources",
    "controllerResources",
    "destinationResources",
    "identityResources",
    "heartbeatResources",
    "proxyInjectorResources",
    "spValidatorResources"
  ]

  # Generate resources from `var.services_resources` and `local.services_list`
  # I use it because I don't want to set the same values for all services
  # Anyway, now it is prettier
  generated_resources = [for service in local.services_list : [
    {
      name  = "${service}.cpu.request"
      value = var.services_resources["cpu_request"]
    },
    {
      name  = "${service}.cpu.limit"
      value = var.services_resources["cpu_limit"]
    },
    {
      name  = "${service}.memory.request"
      value = var.services_resources["memory_request"]
    },
    {
      name  = "${service}.memory.limit"
      value = var.services_resources["memory_limit"]
    },
    ]
  ]

  linkerd_variables = [
    {
      name  = "controllerReplicas"
      value = var.linkerd_production_enable ? 3 : 1
    },
    {
      name  = "enablePodAntiAffinity"
      value = var.linkerd_production_enable ? true : false
    },
    {
      name  = "webhookFailurePolicy"
      value = var.linkerd_production_enable ? "Fail" : "Ignore"
  }]
}

resource "helm_release" "linkerd" {
  name       = "linkerd"
  repository = "https://helm.linkerd.io/stable"
  chart      = "linkerd2"
  version    = var.linkerd_version

  set_sensitive {
    name  = "identityTrustAnchorsPEM"
    value = tls_self_signed_cert.ca_cert.cert_pem
  }
  set_sensitive {
    name  = "identity.issuer.tls.crtPEM"
    value = tls_locally_signed_cert.issuer_cert.cert_pem
  }
  set_sensitive {
    name  = "identity.issuer.tls.keyPEM"
    value = tls_private_key.issuer_key.private_key_pem
  }
  set_sensitive {
    name  = "identity.issuer.crtExpiry"
    value = tls_locally_signed_cert.issuer_cert.validity_end_time
  }

  dynamic "set" {
    for_each = length(var.linkerd_variables) > 0 ? toset(var.linkerd_variables) : toset(concat(local.linkerd_variables, flatten(local.generated_resources)))
    content {
      name  = set.value["name"]
      value = set.value["value"]
    }
  }
}
