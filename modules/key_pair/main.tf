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
