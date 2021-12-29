data "aws_ami" "amzn" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}


resource "aws_instance" "final-ec2-pub-bastion" {
  ami                    = data.aws_ami.amzn.id
  instance_type          = "t3.micro"
  iam_instance_profile = "admin_role"
  availability_zone      = "ap-northeast-2a"
  private_ip             = "10.0.1.10"
  subnet_id              = aws_subnet.final-sub-pub-a.id
  key_name               = "final-key"
  user_data              = file("./bastion.sh")

  vpc_security_group_ids = [aws_security_group.final-sg-pub-main.id]
  tags = {
    Name = "final-ec2-pub-bastion"
  }
}

resource "aws_eip" "final-bastion-ip" {
  vpc                       = true
  instance                  = aws_instance.final-ec2-pub-bastion.id
  associate_with_private_ip = "10.0.1.10"
  depends_on                = [aws_internet_gateway.final-igw]
}

output "public_ip" {
  value = aws_instance.final-ec2-pub-bastion.public_ip
}


resource "aws_instance" "final-ec2-pub-control" {
  ami                    = data.aws_ami.amzn.id
  instance_type          = "t3.micro"
  iam_instance_profile = "admin_role"
  availability_zone      = "ap-northeast-2c"
  private_ip             = "10.0.2.10"
  subnet_id              = aws_subnet.final-sub-pub-c.id
  key_name               = "final-key"
  user_data              = file("./ansible.sh")
  vpc_security_group_ids = [aws_security_group.final-sg-pub-main.id]
  tags = {
    Name = "final-ec2-pub-control"
  }
}
resource "aws_eip" "final-control-ip" {
  vpc                       = true
  instance                  = aws_instance.final-ec2-pub-control.id
  associate_with_private_ip = "10.0.2.10"
  depends_on                = [aws_internet_gateway.final-igw]
}


# web 이중화 구성 # a 대역에 ec2 생성 
/*
resource "aws_instance" "final-ec2-pri-a-web" {
  ami                    = data.aws_ami.amzn.id
  instance_type          = "t3.micro"
  availability_zone      = "ap-northeast-2a"
  subnet_id              = aws_subnet.final-sub-pub-a.id
  key_name               = "final-key"
  user_data              = file("./web.sh")
  vpc_security_group_ids = [aws_security_group.final-sg-pri-web.id]
  tags = {
    Name = "final-ec2-pri-a-web"
  }
}
# c 대역에 ec2 생성 
resource "aws_instance" "final-ec2-pri-c-web2" {
  ami                    = data.aws_ami.amzn.id
  instance_type          = "t3.micro"
  availability_zone      = "ap-northeast-2c"
  subnet_id              = aws_subnet.final-sub-pri-c-web.id
  key_name               = "final-key"
  user_data              = file("./web.sh")
  vpc_security_group_ids = [aws_security_group.final-sg-pri-web.id]
  tags = {
    Name = "final-ec2-pri-c-web2"
  }
}


# was 역시 이중화 구성이지만 ebs를 추가적으로 붙여준다.

# was
resource "aws_instance" "final-ec2-pri-a-was" {
  ami               = data.aws_ami.amzn.id
  instance_type     = "t3.medium"
  availability_zone = "ap-northeast-2a"
  subnet_id         = aws_subnet.final-sub-pub-a.id
  key_name          = "final-key"
  user_data         = file("./was.sh") # 재검토
  ebs_block_device {
    device_name = "/dev/sdb"
    volume_size = "8"
  }
  vpc_security_group_ids = [aws_security_group.final-sg-pri-was.id]
  tags = {
    Name = "final-ec2-pri-a-was"
  }
}


resource "aws_instance" "final-ec2-pri-c-was2" {
  ami               = data.aws_ami.amzn.id
  instance_type     = "t3.medium"
  availability_zone = "ap-northeast-2c"
  subnet_id         = aws_subnet.final-sub-pri-c-was.id
  key_name          = "final-key"
  user_data         = file("./was.sh")
  ebs_block_device {
    device_name = "/dev/sdb"
    volume_size = "8"
  }
  vpc_security_group_ids = [aws_security_group.final-sg-pri-was.id]
  tags = {
    Name = "final-ec2-pri-c-was2"
  }
}
*/
