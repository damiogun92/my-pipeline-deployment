resource "aws_eip" "myprojapp-eip" {
  vpc = true

  tags = {
    Name = "${var.env_prefix}-nat"
  }
}

resource "aws_nat_gateway" "myprojapp-nat" {
  allocation_id = aws_eip.myprojapp-eip.id
  subnet_id     = aws_subnet.public-us-east-1a.id

  tags = {
    Name = "${var.env_prefix}-nat"
  }

  depends_on = [aws_internet_gateway.myprojapp-igw]
}
