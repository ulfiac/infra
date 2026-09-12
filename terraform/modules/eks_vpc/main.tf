locals {
  aws_region = data.aws_region.current.region

  igw_name = "${var.namespace}-${local.aws_region}"

  isolated_route_table_name   = "${var.namespace}-isolated-${local.aws_region}"
  isolated_subnet_name_prefix = "${var.namespace}-isolated"

  nat_gateway_name = "${var.namespace}-nat-gateway"

  private_route_table_name   = "${var.namespace}-private-${local.aws_region}"
  private_subnet_name_prefix = "${var.namespace}-private"

  public_route_table_name   = "${var.namespace}-public-${local.aws_region}"
  public_subnet_name_prefix = "${var.namespace}-public"

  vpc_name = "${var.namespace}-${local.aws_region}"
}
