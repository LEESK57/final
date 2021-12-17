resource "aws_key_pair" "final_key" {
  key_name   = "final-key"
  public_key = file("../../.ssh/final-key.pub") # 키는 새로만들어야함
}