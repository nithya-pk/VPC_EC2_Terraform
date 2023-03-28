resource "aws_instance" "webserver" {
  ami           = "ami-0df24e148fdb9f1d8"
  instance_type = "t3.micro"
  subnet_id = aws_subnet.publicsubnets.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id, aws_security_group.allow_web.id,]
  key_name = var.ssh_key_pair
  associate_public_ip_address = true

  tags = {
    Name = "webserver"
  }
}  