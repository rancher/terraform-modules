variable "name" {}

resource "aws_iam_instance_profile" "eip_assignment" {
  name  = "${var.name}-eip-assignment-profile"
  role  = "${aws_iam_role.eip_assignment.name}"
}

resource "aws_iam_role" "eip_assignment" {
  name = "${var.name}-eip-assignment-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "eip_assignment" {
  name = "${var.name}-eip-assignment-policy"
  role = "${aws_iam_role.eip_assignment.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "ec2:AllocateAddress",
                "ec2:AssociateAddress",
                "ec2:DescribeAddresses",
                "ec2:DisassociateAddress"
            ],
            "Sid": "",
            "Resource": [
                "*"
            ],
            "Effect": "Allow"
        }
    ]
}
EOF
}

output "profile_name" {
  value = "${aws_iam_instance_profile.eip_assignment.name}"
}

output "profile_id" {
  value = "${aws_iam_instance_profile.eip_assignment.id}"
}
