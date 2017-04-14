variable "name" {}

variable "vpc_id" {}

variable "public_subnet_cidrs" {}

resource "aws_security_group" "vpc_allow_from_public_subnets" {
  name   = "${var.name}-vpc-allow-all-public-subnets-sg"
  vpc_id = "${var.vpc_id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 0
    to_port   = 65535
    protocol  = "tcp"
    self      = true
  }

  ingress {
    from_port = 0
    to_port   = 65535
    protocol  = "udp"
    self      = true
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = "${split(",", var.public_subnet_cidrs)}"
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = "${split(",", var.public_subnet_cidrs)}"
  }
}

output "id" {
  value = "${aws_security_group.vpc_allow_from_public_subnets.id}"
}
