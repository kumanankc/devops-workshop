//Create ssh private and public keys using TLS
resource "tls_private_key" "ssh-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

//Create ssh key pair
resource "aws_key_pair" "jenkins_key" {
  key_name   = "jenkins_key"
  public_key = tls_private_key.ssh-key.public_key_openssh
}

//Save private key in a local file
resource "local_file" "jenkins_privatekey" {
  content  = tls_private_key.ssh-key.public_key_pem
  filename = "jenkins_key"
}