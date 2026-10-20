resource "aws_default_subnet" "adopted" {
  for_each                = toset(local.availability_zones)
  availability_zone       = each.value
  map_public_ip_on_launch = false
  force_destroy           = false

  tags = {
    "Name" = "default-${each.value}"
  }

  depends_on = [aws_default_vpc.adopted]
}

#trivy:ignore:AVD-AWS-0101 (HIGH): Default VPC is used.
resource "aws_default_vpc" "adopted" {
  enable_dns_hostnames = true
  enable_dns_support   = true
  force_destroy        = false

  tags = {
    "Name" = "default-${local.aws_region}"
  }
}

#trivy:ignore:AVD-AWS-0104 (CRITICAL): Security group rule allows unrestricted egress to any IP address.
resource "aws_default_security_group" "adopted" {
  vpc_id = aws_default_vpc.adopted.id

  ingress {
    description = "default ingress"
    protocol    = "-1"
    self        = true
    from_port   = 0
    to_port     = 0
  }

  egress {
    description = "default egress"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
  }

  tags = {
    "Name" = "default-${local.aws_region}"
  }
}
