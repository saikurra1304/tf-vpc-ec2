# AWS Instance

resource "aws_instance" "web" {
  ami           = "ami-0affd4508a5d2481b"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.ibm-web-1.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  key_name = "linux"


  tags = {
    Name = "CENTOS"
  }
}