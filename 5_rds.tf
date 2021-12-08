resource "aws_db_instance" "final-db" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t2.micro"
  name                   = "mydb"
  identifier             = "mydb"
  username               = "admin"
  password               = "makeitso"
  parameter_group_name   = "default.mysql8.0"
  availability_zone      = "ap-northeast-2a"
  db_subnet_group_name   = aws_db_subnet_group.final_dbsg.id
  vpc_security_group_ids = [aws_security_group.final-sg-pri-db.id]
  skip_final_snapshot    = true
  tags = {
    "Name" = "final-db"
  }
}
resource "aws_db_subnet_group" "final_dbsg" {
  name       = "final_dbsg"
  subnet_ids = [aws_subnet.final-sub-pri-a-db.id, aws_subnet.final-sub-pri-c-db.id]
}
