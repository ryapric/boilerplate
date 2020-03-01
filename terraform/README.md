Terraform
=========

This subrepo is a collection of [Terraform](https://terraform.io) configurations
to get you started on several kinds of deployable resource sets. You'll notice a
bias towards resources in the AWS cloud -- sorry, that's what clients pay me the
most to use these days! But the general idea and structure of the repo will be
identical no matter your provider of choice.

Layout
------

A Terraform repo with good modularity & reusability should be strucured somewhat
this one is, with the option to also have modules in separate repos. Please be
sure to read [Terraform's suggestion on when and how to use
modules](https://www.terraform.io/docs/modules/index.html).

- `backends/`: Backend configuration variables to dynamically build
  cross-environment backends for remote state storage. Stored in `.tfvars` files
  by environment name.

- `modules/`: Contains additional subfolders for Terraform modules. These can be
  organized however you see fit, but need at least a `main.tf` (or similar), an
  `inputs.tf` or `variables.tf` for input variable expectations, and an
  `outputs.tf` for exporting output values to the caller. These subfolders can
  also each be in their own separate repo, and your caller can reference the
  repo URL in the `source` field. They are only local here for structure/content
  reference.

- `tfvars/`: Variables to pass to called modules, stored in `.tfvars` files by
  environment name.

- `config-files/`: Folder with configuration files, startup scripts, etc. Please
  read the section titled "Infrastructure-as-Code and Configuration Management"
  below for a cautionary word on this.

How to use
----------

You can use all the regular `terraform` commands that you would normally, if
they're called from the repo top-level. Note that `main.tf` is the primary
caller.

A Makefile is also provided for convenience. You *must* pass Make targets with
an `ENV` variable as follows:

    make apply ENV=dev

You *may* also pass in a `TARGET` variable, to target specific resources for
deployment (and their dependencies). The target format must match what you've
already defined in `main.tf`, as `module.<name-you-gave-it>`:

    make apply ENV=dev TARGET=module.aws_compute

The way the Makefile is currently set up, omitting the `TARGET` variable will
*only operate on* the VPC resources. Additionally, any `TARGET` passed will
still create those VPC resources. This is so whatever you choose to deploy will
have networking resources available.

- Note that using Terraform's `-target` option *is not recommended for real
  use*, and running running Terraform commands will tell you the same. Here, it
  is used as a convenience playground feature.

`make init` will try and set a remote state using a dynamic backend
configuration (in the `backends` folder). If you just want to use local state to
play around, then make sure the `backend "..." {}` section is commented out at
the top of `main.tf`, and just run the vanilla `terraform init` instead.

Infrastructure-as-Code and Configuration Management
---------------------------------------------------

Terraform is *explicitly discouraged* from being used for both infrastructure
automation, as well as configuration management. While there is some reasonable
flexibility to this depending on the deployed resources, things like virtual
machines should rely exclusively on separate tooling, unless environment
constraints prevent this. Options for configuration include Hashicorp Packer for
building pre-configured images, and Ansible/Chef/Puppet for configuring a base
instance. A notable exception, however, might be configuring a logging/metrics
agent in a VM's startup script, for example.

Terraform has poor support for validating configuration management (since that's
not an explicit design goal of the tool); launching a VM with a Terraform
Provisioner or lengthy startup script has little to no means of communicating
back to the caller the status of the script execution. It is much better to let
Terraform manage & report back on what it has explicit visibility & control over
(infrastructure).
