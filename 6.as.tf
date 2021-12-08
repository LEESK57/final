#web autoscaling
resource "aws_ami_from_instance" "final-web-ami" {
  name               = "final-web-ami"
  source_instance_id = aws_instance.final-ec2-pri-a-web.id
  depends_on = [
    aws_instance.final-ec2-pri-a-web
  ]

}

resource "aws_launch_configuration" "final-web-lacf" {
  name                 = "final-web-lacf"
  image_id             = aws_ami_from_instance.final-web-ami.id
  instance_type        = "t2.micro"
  iam_instance_profile = "admin_role"
  security_groups      = [aws_security_group.final-sg-pri-web.id]
  key_name             = "final-key"
  user_data            = <<-EOF
                #!/bin/bash
                systemctl start httpd
                systemctl enable httpd
                EOF

}

resource "aws_autoscaling_group" "final-web-atsg" {
  name                      = "final-web-atsg"
  min_size                  = 2
  max_size                  = 10
  health_check_grace_period = 60
  health_check_type         = "EC2"
  desired_capacity          = 2
  force_delete              = false
  launch_configuration      = aws_launch_configuration.final-web-lacf.id
  vpc_zone_identifier       = [aws_subnet.final-sub-pri-a-web.id, aws_subnet.final-sub-pri-c-web.id]
}

resource "aws_autoscaling_attachment" "final-web-asatt" {
  autoscaling_group_name = aws_autoscaling_group.final-web-atsg.id
  alb_target_group_arn   = aws_lb_target_group.final-atg-web.arn
}


#was autoscaling
resource "aws_ami_from_instance" "final-was-ami" {
  name               = "final-was-ami"
  source_instance_id = aws_instance.final-ec2-pri-a-was.id
  depends_on = [
    aws_instance.final-ec2-pri-a-was
  ]

}

resource "aws_launch_configuration" "final-was-lacf" {
  name                 = "final-was-lacf"
  image_id             = aws_ami_from_instance.final-was-ami.id
  instance_type        = "t3.small"
  iam_instance_profile = "admin_role"
  security_groups      = [aws_security_group.final-sg-pri-was.id]
  key_name             = "final-key"

}

resource "aws_autoscaling_group" "final-was-atsg" {
  name                      = "final-was-atsg"
  min_size                  = 2
  max_size                  = 10
  health_check_grace_period = 60
  health_check_type         = "EC2"
  desired_capacity          = 2
  force_delete              = false
  launch_configuration      = aws_launch_configuration.final-was-lacf.id
  vpc_zone_identifier       = [aws_subnet.final-sub-pri-a-was.id, aws_subnet.final-sub-pri-c-was.id]
}

resource "aws_autoscaling_attachment" "final-was-asatt" {
  autoscaling_group_name = aws_autoscaling_group.final-was-atsg.id
  alb_target_group_arn   = aws_lb_target_group.final-ntg-was.arn
}