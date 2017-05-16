# AWS Reference Modules

---

The configurations here are for reference using the modules for AWS. They model an HA setup and creation of a Rancher Kuberenetes HA environment. They are meant to be a starting point and extended to meet your own needs.

## Building Blocks

These scripts are broken out so that the Terraform statefiles stay specific to a single scope. This layout would allow separate teams to manage each concern if thats how your organization is run. This also makes it very clear the inputs/outputs needed for each layer of the environment.

The Terraform components are laid out to handle the base level network creating VPC, subnets, IGW and NATs so that you can deploy your Rancher HA management stack. The outputs of the networking module are consumed by the database and management-cluster units.

The database layer is delivered through RDS in this case. The username/Db and connection strings are all exported.

The management layer is then deployed using Rancher OS in an HA setup behind an ELB.

There is a common Makefile that provides a simple interface for working with Terraform. 

## Getting Started

To get started the first thing to do is decide which components are going to be used. 

The `main-vars.tfvars` file is meant to define all of the provider type variables / secrets. For instance AWS keys, DNS Provider Keys, Rancher API keys, etc. This is not meant to define all of the variables for each of the major subsystems. Subsystem variables are best handled via remote state if they need to share.

Once the main variables have been set, the next step is to create the [network]()

The [database]() level should be created.

The [mangement cluster]() should be the last item built. 