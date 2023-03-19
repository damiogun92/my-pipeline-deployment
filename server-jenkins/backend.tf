terraform {
  backend "s3" {
    bucket = "myprojapp"
    region = "us-east-1"
    key = "jenkins-server/terraform.tfstate"
  }
}