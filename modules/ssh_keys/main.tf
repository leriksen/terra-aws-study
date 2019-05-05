data "external" "keygen" {
  program = ["/bin/bash", "${path.module}/keygen.sh"],

  query = {
    name = "${var.name}",
    path = "${var.path}",
    env  = "${var.env}"
  }
}
