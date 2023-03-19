output "ec2_public_ip" {
  value = aws_instance.myprojapp-server.public_ip
}