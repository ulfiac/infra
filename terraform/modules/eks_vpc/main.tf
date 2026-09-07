locals {
  aws_region = data.aws_region.current.region

  igw_name                = "${var.namespace}-${local.aws_region}"
  public_route_table_name = "${var.namespace}-public-${local.aws_region}"
  public_subnet_name      = "${var.namespace}-public"
  vpc_name                = "${var.namespace}-${local.aws_region}"
}
