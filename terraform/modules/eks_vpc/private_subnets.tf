resource "aws_subnet" "private" {
  for_each = var.private_subnets

  availability_zone = each.key
  cidr_block        = each.value
  vpc_id            = aws_vpc.vpc.id

  tags = {
    Name = "${var.namespace}-private-${each.key}"
  }
}
