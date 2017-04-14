variable "vpc_id" {}

variable "security_group_name" {}

variable "source_cidr_blocks" {
  type = "list"
}

resource "aws_security_group" "db_security_group" {
  name        = "${var.security_group_name}"
  description = "Security Group ${var.security_group_name}"
  vpc_id      = "${var.vpc_id}"

  // allows traffic from the SG itself for tcp
  ingress {
    from_port = 0
    to_port   = 65535
    protocol  = "tcp"
    self      = true
  }

  // allows traffic from the SG itself for udp
  ingress {
    from_port = 0
    to_port   = 65535
    protocol  = "udp"
    self      = true
  }

  // egress
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.source_cidr_blocks}"]
  }

  // allow traffic for TCP 3306
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${var.source_cidr_blocks}"]
  }
}

output "security_group_id_database" {
  value = "${aws_security_group.db_security_group.id}"
}
