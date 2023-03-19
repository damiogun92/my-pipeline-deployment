resource "aws_internet_gateway" "myprojapp-igw" {
  vpc_id = aws_vpc.myprojapp.id

  tags = {
    Name = "${var.env_prefix}-igw"
  }
}
