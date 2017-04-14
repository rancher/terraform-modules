variable "name" {}

variable "vpc_id" {}

resource "aws_internet_gateway" "public" {
  vpc_id = "${var.vpc_id}"

  tags {
    Name = "${var.name}"
  }
}

output "igw_id" {
  value = "${aws_internet_gateway.public.id}"
}
