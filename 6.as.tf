resource "aws_ami_from_instance" "final-basiton-ami" {
  name               = "final-bastion-ami"
  source_instance_id = aws_instance.final-ec2-pub-bastion.id
  depends_on = [
    aws_instance.final-ec2-pub-bastion
  ]

}
/*
resource "aws_ami_from_instance" "final-web-ami" {
  name               = "final-web-ami"
  source_instance_id = aws_instance.final-ec2-pri-a-web.id
  depends_on = [
    aws_instance.final-ec2-pri-a-web
  ]

}
*/

#web autoscaling
resource "aws_launch_configuration" "final-web-lacf" {
  name                 = "final-web-lacf"
  image_id             = aws_ami_from_instance.final-basiton-ami.id
  instance_type        = "t2.micro"
  iam_instance_profile = "admin_role"
  security_groups      = [aws_security_group.final-sg-pri-web.id]
  key_name             = "final-key"
  user_data            =  <<EOF
#!/bin/bash
sudo su -
yum install httpd -y
systemctl start httpd
systemctl status httpd
systemctl enable httpd
cat >> /etc/httpd/conf/httpd.conf <<A
ProxyRequests Off
ProxyPreserveHost On
<Proxy *>
Order deny,allow
Allow from all
</Proxy>
ProxyPass / http://${aws_lb.final-nlb-was.dns_name}:8080/
ProxyPassReverse / http://${aws_lb.final-nlb-was.dns_name}:8080/
A
systemctl restart httpd
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
  tag {
    key                 = "Name"
    value               = "final-ec2-web"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_attachment" "final-web-asatt" {
  autoscaling_group_name = aws_autoscaling_group.final-web-atsg.id
  alb_target_group_arn   = aws_lb_target_group.final-atg-web.arn
}


#was autoscaling
/*
resource "aws_ami_from_instance" "final-was-ami" {
  name               = "final-was-ami"
  source_instance_id = aws_instance.final-ec2-pri-a-was.id
  depends_on = [
    aws_instance.final-ec2-pri-a-was
  ]

}
*/

resource "aws_launch_configuration" "final-was-lacf" {
  name                 = "final-was-lacf"
  image_id             = aws_ami_from_instance.final-basiton-ami.id
  instance_type        = "t3.medium"
  iam_instance_profile = "admin_role"
  security_groups      = [aws_security_group.final-sg-pri-was.id]
  key_name             = "final-key"
  user_data            = file("./was.sh")
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
  tag {
    key                 = "Name"
    value               = "final-ec2-was"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_attachment" "final-was-asatt" {
  autoscaling_group_name = aws_autoscaling_group.final-was-atsg.id
  alb_target_group_arn   = aws_lb_target_group.final-ntg-was.arn
}

resource "aws_autoscaling_group_tag" "was" {
  autoscaling_group_name = aws_autoscaling_group.final-was-atsg.id
  tag {
    key   = "Name"
    value = "was"
    propagate_at_launch = true
  }  
}  