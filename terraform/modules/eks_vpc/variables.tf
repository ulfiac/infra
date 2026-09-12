variable "log_bucket_arn" {
  description = "ARN of the S3 bucket to store logs"
  type        = string
}

variable "namespace" {
  default     = "eks"
  description = "The namespace for the VPC."
  type        = string

}

variable "isolated_subnets" {
  description = "Map of availability zones to isolated subnet CIDR blocks."
  type        = map(string)

  validation {
    condition     = length(var.isolated_subnets) >= 2
    error_message = "isolated_subnets must contain subnets in at least two availability zones."
  }

  validation {
    condition = alltrue([
      for cidr in values(var.isolated_subnets) : try(
        tonumber(split("/", cidr)[1]) > tonumber(split("/", var.vpc_cidr_block)[1]) &&
        tonumber(split("/", cidr)[1]) >= 16 &&
        tonumber(split("/", cidr)[1]) <= 27 &&
        cidrhost(var.vpc_cidr_block, 0) == cidrhost("${cidrhost(cidr, 0)}/${split("/", var.vpc_cidr_block)[1]}", 0),
        false
      )
    ])
    error_message = "Each isolated subnet must be a valid /16 through /27 CIDR contained within vpc_cidr_block."
  }

  # pairwise-compares network address ranges (as 32-bit integers) so overlaps are caught
  # even between subnets with different prefix lengths or duplicate CIDRs on distinct AZ keys
  validation {
    condition = try(alltrue([
      for pair in setproduct(
        [for idx, cidr in values(var.isolated_subnets) : {
          idx   = idx
          start = sum([for i, o in split(".", cidrhost(cidr, 0)) : tonumber(o) * pow(256, 3 - i)])
          end   = sum([for i, o in split(".", cidrhost(cidr, 0)) : tonumber(o) * pow(256, 3 - i)]) + pow(2, 32 - tonumber(split("/", cidr)[1])) - 1
        }],
        [for idx, cidr in values(var.isolated_subnets) : {
          idx   = idx
          start = sum([for i, o in split(".", cidrhost(cidr, 0)) : tonumber(o) * pow(256, 3 - i)])
          end   = sum([for i, o in split(".", cidrhost(cidr, 0)) : tonumber(o) * pow(256, 3 - i)]) + pow(2, 32 - tonumber(split("/", cidr)[1])) - 1
        }]
      ) : pair[0].idx == pair[1].idx || pair[0].start > pair[1].end || pair[1].start > pair[0].end
    ]), false)
    error_message = "isolated_subnets CIDR blocks must not overlap with one another."
  }
}

variable "private_subnets" {
  description = "Map of availability zones to private subnet CIDR blocks."
  type        = map(string)

  validation {
    condition     = length(var.private_subnets) >= 2
    error_message = "private_subnets must contain subnets in at least two availability zones."
  }

  validation {
    condition = alltrue([
      for cidr in values(var.private_subnets) : try(
        tonumber(split("/", cidr)[1]) > tonumber(split("/", var.vpc_cidr_block)[1]) &&
        tonumber(split("/", cidr)[1]) >= 16 &&
        tonumber(split("/", cidr)[1]) <= 27 &&
        cidrhost(var.vpc_cidr_block, 0) == cidrhost("${cidrhost(cidr, 0)}/${split("/", var.vpc_cidr_block)[1]}", 0),
        false
      )
    ])
    error_message = "Each private subnet must be a valid /16 through /27 CIDR contained within vpc_cidr_block."
  }

  # pairwise-compares network address ranges (as 32-bit integers) so overlaps are caught
  # even between subnets with different prefix lengths or duplicate CIDRs on distinct AZ keys
  validation {
    condition = try(alltrue([
      for pair in setproduct(
        [for idx, cidr in values(var.private_subnets) : {
          idx   = idx
          start = sum([for i, o in split(".", cidrhost(cidr, 0)) : tonumber(o) * pow(256, 3 - i)])
          end   = sum([for i, o in split(".", cidrhost(cidr, 0)) : tonumber(o) * pow(256, 3 - i)]) + pow(2, 32 - tonumber(split("/", cidr)[1])) - 1
        }],
        [for idx, cidr in values(var.private_subnets) : {
          idx   = idx
          start = sum([for i, o in split(".", cidrhost(cidr, 0)) : tonumber(o) * pow(256, 3 - i)])
          end   = sum([for i, o in split(".", cidrhost(cidr, 0)) : tonumber(o) * pow(256, 3 - i)]) + pow(2, 32 - tonumber(split("/", cidr)[1])) - 1
        }]
      ) : pair[0].idx == pair[1].idx || pair[0].start > pair[1].end || pair[1].start > pair[0].end
    ]), false)
    error_message = "private_subnets CIDR blocks must not overlap with one another."
  }
}

variable "public_subnets" {
  description = "Map of availability zones to public subnet CIDR blocks."
  type        = map(string)

  validation {
    condition     = length(var.public_subnets) >= 2
    error_message = "public_subnets must contain subnets in at least two availability zones."
  }

  validation {
    condition = alltrue([
      for cidr in values(var.public_subnets) : try(
        tonumber(split("/", cidr)[1]) > tonumber(split("/", var.vpc_cidr_block)[1]) &&
        tonumber(split("/", cidr)[1]) >= 16 &&
        tonumber(split("/", cidr)[1]) <= 27 &&
        cidrhost(var.vpc_cidr_block, 0) == cidrhost("${cidrhost(cidr, 0)}/${split("/", var.vpc_cidr_block)[1]}", 0),
        false
      )
    ])
    error_message = "Each public subnet must be a valid /16 through /27 CIDR contained within vpc_cidr_block."
  }

  # pairwise-compares network address ranges (as 32-bit integers) so overlaps are caught
  # even between subnets with different prefix lengths or duplicate CIDRs on distinct AZ keys
  validation {
    condition = try(alltrue([
      for pair in setproduct(
        [for idx, cidr in values(var.public_subnets) : {
          idx   = idx
          start = sum([for i, o in split(".", cidrhost(cidr, 0)) : tonumber(o) * pow(256, 3 - i)])
          end   = sum([for i, o in split(".", cidrhost(cidr, 0)) : tonumber(o) * pow(256, 3 - i)]) + pow(2, 32 - tonumber(split("/", cidr)[1])) - 1
        }],
        [for idx, cidr in values(var.public_subnets) : {
          idx   = idx
          start = sum([for i, o in split(".", cidrhost(cidr, 0)) : tonumber(o) * pow(256, 3 - i)])
          end   = sum([for i, o in split(".", cidrhost(cidr, 0)) : tonumber(o) * pow(256, 3 - i)]) + pow(2, 32 - tonumber(split("/", cidr)[1])) - 1
        }]
      ) : pair[0].idx == pair[1].idx || pair[0].start > pair[1].end || pair[1].start > pair[0].end
    ]), false)
    error_message = "public_subnets CIDR blocks must not overlap with one another."
  }
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string

  validation {
    condition     = can(cidrhost(var.vpc_cidr_block, 0))
    error_message = "Must be a valid IPv4 CIDR block format."
  }

  validation {
    condition = anytrue([
      can(regex("^10\\.", var.vpc_cidr_block)),
      can(regex("^172\\.(1[6-9]|2[0-9]|3[0-1])\\.", var.vpc_cidr_block)),
      can(regex("^192\\.168\\.", var.vpc_cidr_block))
    ])
    error_message = "The VPC CIDR block must reside in private IP space."
  }
}
