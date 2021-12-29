resource "aws_efs_file_system" "final-efs" {
  creation_token = "final"
  encrypted = true
  tags = {
    Name = "final-efs"
  }
}

resource "aws_efs_mount_target" "final-efs-mount-target" {
    file_system_id = "${aws_efs_file_system.final-efs.id}"
    subnet_id      = "${aws_subnet.final-sub-pub-c.id}"
    security_groups = [aws_security_group.final-sg-pub-main.id]
}

output "id" {
  value = aws_efs_file_system.final-efs.id
}