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

  # The Linkerd-Viz extension contains observability and visualization components for Linkerd.
  viz_create = true
}
