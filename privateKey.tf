# Create a "terraformKey.pem" to your computer
resource "tls_private_key" "privateKey" {
  algorithm = "RSA"
  rsa_bits  = 4096

  #provisioner "local-exec" {
  #  command = "echo '${self.private_key_pem}' > ./myKey.pem"
  #}
}


# Save terraformKey.pem Locally for further  use
resource "local_file" "private_key" {
  #count    = "${var.public_ssh_key == "" ? 1 : 0}"
  content  = "${tls_private_key.privateKey.private_key_pem}"
  filename = "./${var.aws_key}.pem"
}

/*
# When we Destroy the Environment using Terraform then the Key is also Deleted Locally
# If not then try this Block
resource "null_resource" "deleteKey" {
  provisioner "local-exec" {
    when    = destroy
    command = "del /f ${var.aws_key}.pem"
  }
}
*/

# Create a "terraformKey" to AWS
resource "aws_key_pair" "keyPair" {
  key_name   = var.aws_key
  public_key = tls_private_key.privateKey.public_key_openssh
}
