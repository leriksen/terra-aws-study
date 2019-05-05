module "ssh_key_gen_example" {
  source = "../../modules/ssh_keys"

  name = "${var.name}"
  path = "${var.path}"
  env = "${var.env}"
}
