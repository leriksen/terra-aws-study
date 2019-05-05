# Generate SSH key pair example 

This folder shows an example of Terraform code to generate a SSH key pair on the local file system using the key-gen module.
from the Consul AWS Module.

This example creates a key pair on the local file system.

**Note**: To keep this example as simple as possible, it creates pre-named keys in a predefined location. This is OK for learning and experimenting, but for 
production usage, we strongly recommend some for of name generation.

## Quick start

To create an SSH key pair:

1. `git clone` this repo to your computer.
1. Optional: make sure you have `ssh-keygen`, `awk`, `yes`, `dirname` and `jq` installed and in your path.
1. Install [Terraform](https://www.terraform.io/).
1. Open `variables.tf`, set the evariables specified at the top of the file, and fill in any other variables that
   don't have a default.
1. Run `terraform init`.
1. Run `terraform apply`.
1. Look at the output and examine the local file system for the generated keys.
