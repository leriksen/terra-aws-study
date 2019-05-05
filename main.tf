provider "aws" {
  region = "us-east-1"
}

//resource "aws_instance" "server" {
//  ami = "ami-0de53d8956e8dcf80"
//  instance_type = "t2.micro"
//  key_name = "${aws_key_pair.terraform.key_name}"
//  security_groups = ["${aws_security_group.allow_ssl.name}"]
//}

module "ssh_key_gen" {
  source = "./modules/ssh_keys"

  name = "${var.name}"
  path = "${var.path}"
  env = "${var.env}"
}

resource "aws_key_pair" "terraform" {
  key_name   = "${var.name}-${var.env}"
  public_key = "${module.ssh_key_gen.public_key}"
}

resource "aws_security_group" "allow_ssl" {
  name        = "${var.name}-${var.env}-allow_ssl"
  description = "Allow SSL inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    self        = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssl"
  }
}

//output "instance_dns" {
//  value = "${aws_instance.server.public_dns}"
//  description = "public dns"
//}