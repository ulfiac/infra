resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = local.nat_gateway_name
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[local.nat_gateway_az].id

  tags = {
    Name = local.nat_gateway_name
  }

  depends_on = [aws_internet_gateway.igw]
}
