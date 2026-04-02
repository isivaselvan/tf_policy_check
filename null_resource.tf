locals {
  filename = "${path.module}/custom-config.json"
}

resource "null_resource" "conditional_action" {
  count = fileexists(local.filename) ? 1 : 0

  provisioner "local-exec" {
    command = fileexists(local.filename) ? "echo 'File exists'" : "echo 'File missing'"
  }
}      
