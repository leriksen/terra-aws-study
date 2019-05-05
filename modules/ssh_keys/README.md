# Generate SSH keys

This module can be used to generate the public and private keys for use in an AWS key pair.

## Quick start

1. Copy this module to your computer.

1. Open `variables.tf` and fill in the variables that do not have a default.

1. Run `terraform apply`. The output will show you the generated public key. The corresponding private key
will be in the location specified by the ```path``` variable

    ```
    Outputs:
    
    public_key = key.pem
    ```
    
1. Use this output in a ```resource "aws_key_pair"``` block

1. Use the private key to SSH to an EC2 instance with the provisioned key pair:

    ```
    ssh ec2-user@<provisioned IP address> -i <path tp private key>
    ```
