provider "aws" {
  region = "us-east-1"
  access_key = ""
  secret_key = ""
}

#create Instance

resource "aws_instance" "terraform_instance" {
  ami = "ami-03d315ad33b9d49c4"
  instance_type = "t2.micro"
  tags = {
    Name = "terraform"
  }
}