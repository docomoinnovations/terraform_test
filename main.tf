data "aws_eks_cluster" "cluster" {
  name = module.my-cluster.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.my-cluster.cluster_id
}

provider "aws" {
  version = ">= 2.52.0"
  region  = "ap-northeast-1"
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
  cluster_version = "1.14"
  subnets         = ["subnet-0a060da7b1fe7b900", "subnet-0fed60380b3270d0d"]
  vpc_id          = "vpc-0c3fb682a83ba14f9"

  worker_groups = [
    {
      instance_type = "t2.medium"
      asg_max_size  = 2
    }
  ]
}
