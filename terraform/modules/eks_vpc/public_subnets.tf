resource "aws_subnet" "public" {
  for_each = var.public_subnets

  availability_zone       = each.key
  cidr_block              = each.value
  map_public_ip_on_launch = false
  vpc_id                  = aws_vpc.vpc.id

  tags = {
    Name                     = "${local.public_subnet_name_prefix}-${each.key}"
    "kubernetes.io/role/elb" = "1"
  }
}
