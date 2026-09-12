resource "aws_subnet" "isolated" {
  for_each = var.isolated_subnets

  availability_zone = each.key
  cidr_block        = each.value
  vpc_id            = aws_vpc.vpc.id

  tags = {
    Name = "${local.isolated_subnet_name_prefix}-${each.key}"
  }
}
