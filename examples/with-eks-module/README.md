# Production deployment

This deployment allows Linkerd2 to be deployed to the cluster after the cluster has been deployed.

```
data "aws_eks_cluster" "eks" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
}

module "eks" {
  source = "terraform-aws-modules/eks/aws"

  cluster_version = "1.21"
  cluster_name    = "my-cluster"
  vpc_id          = "vpc-1234556abcdef"
  subnets         = ["subnet-abcde012", "subnet-bcde012a", "subnet-fghi345a"]

  worker_groups = [
    {
      instance_type = "m4.large"
      asg_max_size  = 5
    }
  ]
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.eks.token
  }
}

module "linkerd2" {
  source = "../../"

  # The Linkerd-Viz extension contains observability and visualization components for Linkerd.
  viz_create = true
}
```