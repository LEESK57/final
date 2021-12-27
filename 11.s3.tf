resource "aws_s3_bucket" "final009-bucket" {
    bucket = "final009-bucket"
}

resource "aws_s3_access_point" "final009" {
  bucket = "final009-bucket"
  name   = "final009"

  # VPC must be specified for S3 on Outposts
  vpc_configuration {
    vpc_id = aws_vpc.final-vpc.id
  }
}

resource "aws_s3_bucket_policy" "final001-bucket-policy" {
  bucket = aws_s3_bucket.final009-bucket.id

 #aws의 버킷정책 json부분
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::600734575887:root"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::final009-bucket/*"
        }
    ]
})
} 

resource "aws_s3_bucket_public_access_block" "access_bucket" {
  bucket = "final009-bucket"

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
  restrict_public_buckets = true
}