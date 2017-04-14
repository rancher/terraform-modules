variable "vpc_id" {}

variable "name" {}

resource "aws_security_group" "web_elb_front" {
  name        = "${var.name}-web-elb-world"
  description = "Allow ports rancher "
  vpc_id      = "${var.vpc_id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "web_elb_back" {
  name        = "${var.name}-web-elb-hosts"
  description = "Allow Connection from elb"
  vpc_id      = "${var.vpc_id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = ["${aws_security_group.web_elb_front.id}"]
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = ["${aws_security_group.web_elb_front.id}"]
  }
}

output "web_elb_sg_ids" {
  value = "${join(",", list(aws_security_group.web_elb_front.id,
            aws_security_group.web_elb_back.id))}"
}

output "web_elb_backend_sg_id" {
  value = "${aws_security_group.web_elb_back.id}"
}
