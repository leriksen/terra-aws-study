output "public_key" {
  value = "${module.ssh_key_gen_example.public_key}"
  description = "public key"
}
