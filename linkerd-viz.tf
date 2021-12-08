locals {
  # The resource list is taken from https://github.com/linkerd/linkerd2/blob/main/viz/charts/linkerd-viz/values-ha.yaml
  # `helm_release` doesn't support Anchors and links
  # So, we have to set the same varaibles for all services
  viz_services_list = [
    "tap.resources",
    "dashboard.resources",
    "grafana.resources",
    "prometheus.resources"
  ]

  # Generate resources from `var.viz_services_resources` and `local.viz_services_list`
  # I use it because I don't want to set the same values for all services
  # Anyway, now it is prettier
  viz_generated_resources = [for service in local.viz_services_list : [
    {
      name  = "${service}.cpu.request"
      value = var.viz_services_resources["cpu_request"]
    },
    {
      name  = "${service}.cpu.limit"
      value = var.viz_services_resources["cpu_limit"]
    },
    {
      name  = "${service}.memory.request"
      value = var.viz_services_resources["memory_request"]
    },
    {
      name  = "${service}.memory.limit"
      value = var.viz_services_resources["memory_limit"]
    },
    ]
  ]

  viz_variables = concat([
    {
      name  = "tap.replicas"
      value = var.viz_production_enable ? 3 : 1
    },
    {
      name  = "enablePodAntiAffinity"
      value = var.viz_production_enable ? true : false
    }],
    var.viz_production_enable ? flatten(local.viz_generated_resources) : []
  )
}

resource "helm_release" "linkerd_viz" {
  count           = var.viz_create ? 1 : 0
  name            = "linkerd-viz"
  repository      = "https://helm.linkerd.io/stable"
  chart           = "linkerd-viz"
  atomic          = true
  cleanup_on_fail = true
  timeout         = 180
  version         = var.linkerd_version

  dynamic "set" {
    for_each = length(var.viz_variables) > 0 ? toset(var.viz_variables) : local.viz_variables
    content {
      name  = set.value["name"]
      value = set.value["value"]
    }
  }

  depends_on = [
    helm_release.linkerd
  ]
}
