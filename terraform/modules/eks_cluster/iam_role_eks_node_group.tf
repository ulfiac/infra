data "aws_iam_policy_document" "eks_node_group_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "eks_node_group" {
  name               = local.iam_role_name_eks_node_group
  assume_role_policy = data.aws_iam_policy_document.eks_node_group_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "amazon_ec2_container_registry_read_only_policy_to_eks_node_group" {
  policy_arn = data.aws_iam_policy.amazon_ec2_container_registry_read_only_policy.arn
  role       = aws_iam_role.eks_node_group.name
}

resource "aws_iam_role_policy_attachment" "amazon_eks_worker_node_policy_to_eks_node_group" {
  policy_arn = data.aws_iam_policy.amazon_eks_worker_node_policy.arn
  role       = aws_iam_role.eks_node_group.name
}
