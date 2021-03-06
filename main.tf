data "aws_eks_cluster" "cluster" {
  name = module.my-cluster.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.my-cluster.cluster_id
}

provider "aws" {
  version = ">= 2.52.0"
  region  = "us-west-2" 
  access_key = var.access_key
  secret_key = var.secret_key
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
  version                = "~> 1.9"
}

module "my-cluster" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "my-cluster"
  cluster_version = "1.15"
  subnets         = ["subnet-0c20a0fbc0b787b9a", "subnet-09805e95f3a7daaf6"]
  vpc_id          = "vpc-056881ac09142937a"

  worker_groups = [
    {
      instance_type = "t2.medium"
      asg_max_size  = 2
    }
  ]
}
