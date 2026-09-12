resource "aws_route_table" "isolated" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = local.isolated_route_table_name
  }
}

resource "aws_route_table_association" "isolated" {
  for_each = aws_subnet.isolated

  route_table_id = aws_route_table.isolated.id
  subnet_id      = each.value.id
}
