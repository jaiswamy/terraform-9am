resource "aws_instance" "jai" {
  ami           = "ami-066784287e358dad1"
  instance_type = "t2.micro"
  key_name      = "us"
  tags = {
    name = "jai"
  }

# lifecycle {
#     create_before_destroy = true
# }

lifecycle {
  prevent_destroy = true
}

# lifecycle {
#     ignore_changes = [tags,]
# }
}