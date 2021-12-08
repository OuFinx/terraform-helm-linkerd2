# Full deployment

Fill in the `locals` block with the correct values.

```
locals {
  cluster_name           = "my-example-cluster"
  cluster_api_endpoint   = "https://1234567890.gr7.us-east-1.eks.amazonaws.com"
  cluster_ca_certificate = "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUM1ekNDQWMrZ0F3SUJBZ0lCQURBTkJn........."
}

data "aws_eks_cluster_auth" "this" {
  name = local.cluster_name
}

provider "helm" {
  kubernetes {
    host                   = local.cluster_api_endpoint
    cluster_ca_certificate = base64decode(local.cluster_ca_certificate)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}

module "linkerd2" {
  source = "../../"

  validity_period_hours_ca     = 87660
  validity_period_hours_issuer = 8760
  subject_common_name          = "identity.linkerd.cluster.local"
  subject_organization         = "Comp inc."
  allowed_uses = [
    "crl_signing",
    "cert_signing",
    "server_auth",
    "client_auth"
  ]

  linkerd_version = "2.10.2"
  linkerd_variables = [
    {
      name  = "controllerReplicas"
      value = 3
  }]

  linkerd_services_resources = {
    cpu_request    = "100m"
    cpu_limit      = "500m"
    memory_request = "50Mi"
    memory_limit   = "250Mi"
  }

  viz_create = true
  viz_variables = [
    {
      name  = "tap.replicas"
      value = 3
  }]

  viz_services_resources = {
    cpu_request    = "200m"
    cpu_limit      = "700m"
    memory_request = "70Mi"
    memory_limit   = "350Mi"
  }

  linkerd_production_enable = true
  viz_production_enable     = true
}
```