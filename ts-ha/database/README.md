# Database

---
The database module will create the following resources:

 * RDS - MySQL database instance
 * Security group allowing access to the DB instances.

## Getting Started

You should have the `main-vars.tfvars` file populated in the main directory before configuring the database.

You will need to either use a remote state from the network module, or you will need to edit the main.tf in this directory to remove the data source and the references.

You will need to populate the following variables in this section:

```
database_password="password"
aws_rds_instance_class="db.m3.medium"
aws_env_name = "rancher-database"
aws_region = "us-west-1"
```

once updated, the command:

`make plan`

Will show what terraform would plan to do.

`make plan-output`

## Outputs

The following will be outputs that can be imported by other components via remote state.
  * database - The name of the database created.
  * password - The password that should be used to connect to the database. Keep in mind this should be guarded closely.
  * username - The username for connecting to the database.
  * endpoint - The RDS endpoint to connect to.
