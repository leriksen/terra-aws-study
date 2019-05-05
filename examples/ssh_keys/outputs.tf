output "public_key" {
  value = "${module.ssh_key_gen.public_key}"
  description = "public key"
}
