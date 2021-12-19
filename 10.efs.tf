resource "aws_efs_file_system" "final-efs" {
  creation_token = "final"
  tags = {
    Name = "final-efs"
  }
}
 
resource "aws_efs_mount_target" "final-efs-mount-target" {
    file_system_id = "${aws_efs_file_system.final-efs.id}"
    subnet_id      = "${aws_subnet.final-sub-pub-c.id}"
    security_groups = [aws_security_group.final-sg-pub-bastion.id]
}

resource "aws_efs_access_point" "final_access_point" {
  file_system_id = aws_efs_file_system.final-efs.id
}