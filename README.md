# Rancher Terraform Modules
---

These are opinionated modules that provision Rancher HA environments on AWS. We are working on support for Azure and GCE. Currently these make use of Rancher OS, though work is being done to include additional OSes. 

The HA example will create:

* VPC - Across one or more availability zones. It has everything needed for external communications.
* RDS MySQL Database
* ELB pointing to an ASG of 3 nodes.

The example_ha folder for a possible layout that breaks up the network, DB and management plane into separate components. You should be able to deploy into existing environments leveraging the components that you need.

## License
Copyright (c) 2014-2017 [Rancher Labs, Inc.](http://rancher.com)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

[http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.