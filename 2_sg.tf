resource "aws_security_group" "final-sg-pub-main" {
  name        = "final-sg-pub-main"
  vpc_id      = aws_vpc.final-vpc.id
  tags = {
    Name = "final-sg-pub-main"
  }
}
resource "aws_security_group_rule" "final-sgr-main-ssh" {
  type = "ingress"
  from_port = 6022
  to_port = 6022
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.final-sg-pub-main.id
}

resource "aws_security_group_rule" "final-sgr-main-efs" {
  type = "ingress"
  from_port = 2049
  to_port = 2049
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.final-sg-pub-main.id
}

resource "aws_security_group_rule" "final-sgr-main-grafana" {
  type = "ingress"
  from_port = 3000
  to_port = 3000
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.final-sg-pub-main.id
}
resource "aws_security_group_rule" "egress_final_main" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = -1
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.final-sg-pub-main.id
}  
#web
resource "aws_security_group" "final-sg-pri-web" {
  name        = "final-sg-pri-web"
  description = "final-sg-pri-web"
  vpc_id      = aws_vpc.final-vpc.id
  tags = {
    Name = "final-sg-pri-web"
  }
}

resource "aws_security_group_rule" "final-sgr-web-ssh" {
  type = "ingress"
  from_port = 6022
  to_port = 6022
  protocol = "tcp"
  source_security_group_id = aws_security_group.final-sg-pub-main.id
  security_group_id = aws_security_group.final-sg-pri-web.id
}

resource "aws_security_group_rule" "final-sgr-web-http" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.final-sg-pri-web.id
}

resource "aws_security_group_rule" "egress_final_web" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = -1
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.final-sg-pri-web.id
}

# was 
resource "aws_security_group" "final-sg-pri-was" {
  name        = "final-sg-pri-was"
  description = "final-sg-pri-was"
  vpc_id      = aws_vpc.final-vpc.id
  tags = {
    Name = "final-sg-pri-was"
  }
}

resource "aws_security_group_rule" "final-sgr-was-ssh" {
  type = "ingress"
  from_port = 6022
  to_port = 6022
  protocol = "tcp"
  source_security_group_id = aws_security_group.final-sg-pub-main.id
  security_group_id = aws_security_group.final-sg-pri-was.id
}

resource "aws_security_group_rule" "final-sgr-was-tomcat" {
  type = "ingress"
  from_port = 8080
  to_port = 8080
  protocol = "tcp"
  cidr_blocks = ["10.0.10.0/24", "10.0.20.0/24"]
  security_group_id = aws_security_group.final-sg-pri-was.id
}

resource "aws_security_group_rule" "egress_final_was" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = -1
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.final-sg-pri-was.id
}

# db 
resource "aws_security_group" "final-sg-pri-db" {
  name        = "final-sg-pri-db"
  description = "final-sg-pri-db"
  vpc_id      = aws_vpc.final-vpc.id
  tags = {
    Name = "final-sg-pri-db"
  }
}  

resource "aws_security_group_rule" "final-sgr-db" {
  type = "ingress"
  from_port = 3306
  to_port = 3306
  protocol = "tcp"
  cidr_blocks = ["10.0.30.0/24", "10.0.40.0/24"]
  security_group_id = aws_security_group.final-sg-pri-db.id
}

resource "aws_security_group_rule" "egress_final_db" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = -1
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.final-sg-pri-db.id
}

# alb sg 
resource "aws_security_group" "final-sg-alb-web" {
  name        = "final-sg-alb-web"
  description = "final-sg-alb-web"
  vpc_id      = aws_vpc.final-vpc.id
  tags = {
    Name = "final-sg-alb-web"
  }
}
resource "aws_security_group_rule" "final-sgr-alb-ssh" {
  type = "ingress"
  from_port = 6022
  to_port = 6022
  protocol = "tcp"
  source_security_group_id = aws_security_group.final-sg-pub-main.id
  security_group_id = aws_security_group.final-sg-alb-web.id
}

resource "aws_security_group_rule" "final-sgr-alb-http" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.final-sg-alb-web.id
}
resource "aws_security_group_rule" "final-sgr-alb-tomcat" {
  type = "ingress"
  from_port = 8080
  to_port = 8080
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.final-sg-alb-web.id
}
resource "aws_security_group_rule" "final-sgr-alb-https" {
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.final-sg-alb-web.id
}
resource "aws_security_group_rule" "egress_final_alb" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = -1
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.final-sg-alb-web.id
}