resource "aws_instance" "web" {
  ami                         = var.ami
  instance_type               = var.instance_type
  associate_public_ip_address = true
  key_name                    = var.aws_key_pair
  // security_groups = [ "demo-sg" ]
  vpc_security_group_ids = [aws_security_group.demo-sg.id]
  subnet_id              = aws_subnet.public-subnet.id
  for_each               = toset(["jenkins-master", "jenkins-slave", "ansible"])
  tags = {
    Name = "${each.key}"
  }
}
