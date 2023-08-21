# eks cluster 
resource "aws_eks_cluster" "nextjseks" {
  name     = "my-eks-cluster"
  role_arn = aws_iam_policy_document.eks_assume_role.arn

  vpc_config {
    subnet_ids = [
        aws_subnet.nextpublic[0].id, aws_subnet.nextpublic[1].id,
        aws_subnet.nextprivate[0].id, aws_subnet.nextprivte[1].id
    ]
  }
}

# Worker Nodes groups
resource "aws_eks_node_group" "my_next_worker_node" {
  cluster_name    = aws_eks_cluster.nextjseks.name
  node_group_name = "my-node-group"
  node_role_arn   = aws_iam_role.nodes.arn

  subnet_ids = [aws_subnet.nextprivate[0].id, aws_subnet.nextprivate[1].id]

  capacity_type = "ON_DEMAND"
  instance_types = ["t2.micro"]

  scaling_config {
    desired_size = 2
    max_size     = 10
    min_size     = 0
  }

  update_config {
    max_unavailable = 1
  }

    labels = {
     role = "general"
}

# tags for auto scaler 
tags = {
    "k8s.io/cluster-autoscaler/demo" = "owned"
    "k8s.io/cluster-autoscaler/enabled" = true
}
}
