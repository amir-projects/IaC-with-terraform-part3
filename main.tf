# main.tf

data "aws_ami" "linux" {
   most_recent = true
   owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "my_ec2" {
  ami                = data.aws_ami.linux.id
  instance_type      = "t2.micro"
  associate_public_ip_address = true

  tags = {
    Name = "my_ec2"
  }
}