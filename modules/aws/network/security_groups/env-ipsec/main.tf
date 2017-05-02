variable "name" {}

variable "vpc_id" {}

variable "environment_cidrs" {}

resource "aws_security_group" "rancher_ip_sec" {
  name   = "${var.name}-sg"
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
    from_port   = 500
    to_port     = 500
    protocol    = "udp"
    cidr_blocks = ["${split(",", var.environment_cidrs)}"]
  }

  ingress {
    from_port   = 4500
    to_port     = 4500
    protocol    = "udp"
    cidr_blocks = ["${split(",", var.environment_cidrs)}"]
  }
}

output "ipsec_id" {
  value = "${aws_security_group.rancher_ip_sec.id}"
}
