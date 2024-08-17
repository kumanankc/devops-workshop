resource "aws_instance" "web" {
  ami             = var.ami
  instance_type   = var.instance_type
  key_name        = var.aws_key_pair
  security_groups = ["demo-sg"]
}

output "public_ip" {
  value = aws_instance.web.public_ip
}