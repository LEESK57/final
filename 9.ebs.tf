resource "aws_ebs_volume" "final-ebs-volume" {
    availability_zone = "ap-northeast-2c"
    size              = 20
    tags = {
        Name = "final-ebs-volume"
      }
  }
resource "aws_volume_attachment" "final-ebs-volume" {
    device_name = "/dev/sdb"
    volume_id   = "${aws_ebs_volume.final-ebs-volume.id}"
    instance_id = "${aws_instance.final-ec2-pub-control.id}"
  }

  