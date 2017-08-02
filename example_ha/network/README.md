# Network

---

The network will create the following resources:

* VPC
* IGW
* NAT
* Public Subnets
* Private Subnets
* Security Groups
* AWS IAM Server Certificate (Used on the ELB)

## Getting Started

You should have the main-vars.tfvars file populated in the main directory before configuring this section.

For the network you will need to define the following variables in the `network.tfvars`

```
aws_env_name = "production"
aws_vpc_cidr = "10.0.0.0/16"                          # CIDR block for the whole VPC
aws_private_subnet_cidrs = "10.0.0.0/24,10.0.64.0/24" # Should be one per Availability Zone
aws_public_subnet_cidrs = "10.0.0.0/24,10.0.1.0/24"
aws_subnet_azs = "us-west-1a,us-west-1b"              # Comma separated list of AZs
server_cert_path = "certfile"
server_key_path = "Keyfile"
ca_chain_path = "bundlefile
```

This module will create an SSL Certificate ARN for Terminating SSL on an ELB if you don't want this, you can remove the `aws_iam_server_certificate` resource in main.tf.

Once updated, the command:

`make plan`

will show what terraform would plan to do.

`make plan-output` 

will make a plan file. To execute the plan file:

`make apply-plan PLAN=<file>`

## Outputs

The following will be outputs that can be imported by other components via remote state.

```
"vpc_id"
"aws_public_subnet_cidrs"
"aws_private_subnet_cidrs"
"aws_private_subnet_ids"
"aws_public_subnet_ids"
"rancher_com_arn"
```
