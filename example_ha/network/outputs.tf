output "vpc_id" {
  value = "${module.vpc_network.vpc_id}"
}

output "aws_public_subnet_cidrs" {
  value = "${var.aws_public_subnet_cidrs}"
}

output "aws_private_subnet_cidrs" {
  value = "${var.aws_private_subnet_cidrs}"
}

output "aws_private_subnet_ids" {
  value = "${module.vpc_network.private_subnet_ids}"
}

output "aws_public_subnet_ids" {
  value = "${module.vpc_network.public_subnet_ids}"
}

output "rancher_com_arn" {
  value = "${aws_iam_server_certificate.rancher_com.arn}"
}
