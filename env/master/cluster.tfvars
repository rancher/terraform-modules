database_password="RancherTetra2017&"

aws_env_name = "staging"

aws_region = "us-west-2"

vpc_id = "vpc-abcaf2ce"

aws_private_subnet_cidrs = "10.0.2.0/24,10.0.3.0/24"

aws_public_subnet_cidrs = "10.0.0.0/24,10.0.1.0/24"

aws_private_subnet_ids = "subnet-e3a1ad86,subnet-a5587bd2"

rancher_hostname = "rancher-staging"

aws_ami_id = "ami-b9c4d8c0"

aws_instance_type = "m4.large"

rancher_version = "rancher/server"

api_ui_version = "v2"

spot_enabled = false

aws_subnet_azs = "us-west-2a,us-west-2b"

aws_rds_instance_class = "db.m3.medium"

aws_public_subnet_ids = "subnet-a4587bd3,subnet-e0a1ad85"

aws_key_pair = "rancher-staging-key"

rancher_com_arn = "arn:aws:acm:us-west-2:245227470998:certificate/6bf56436-5613-4f31-8372-baefb4c6be18"

elb_sgs = "sg-b1000dd5"

compute_sgs = "sg-d3b3dbab,sg-b2000dd6"
