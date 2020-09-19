resource "tls_private_key" "key_rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "fiap-lab" {
  key_name   = "fiap-lab"
  public_key = tls_private_key.key_rsa.public_key_openssh
}