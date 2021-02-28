provider "aws" {
  region = "us-east-1"
  access_key = ""
  secret_key = ""
}

#create Instance

# resource "aws_instance" "terraform_instance" {
#   ami = "ami-03d315ad33b9d49c4"
#   instance_type = "t2.micro"
#   tags = {
#     Name = "terraform"
#   }
# }

#Variables

# variable "subnet_prefix"{
#   description = "Subnet prefix"
#   #default
#   #type = String or any
# }

#1 Create VCP
resource "aws_vpc" "prod-vpc"{
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "production"
  }
}
#2 Create internat gateway
resource "aws_internet_gateway" "prod-gateway" {
  vpc_id = aws_vpc.prod-vpc.id
  tags = {
    Name = "production"
  }
}
#3 Route table
resource "aws_route_table" "prod-route-table" {
  vpc_id = aws_vpc.prod-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.prod-gateway.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.prod-gateway.id
  }

  tags = {
    Name = "production"
  }
}
#4 Create subnet

resource "aws_subnet" "my-subnet"{
  vpc_id = aws_vpc.prod-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "production"
  }
}

#5 Associate subnet with route tabel
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.my-subnet.id
  route_table_id = aws_route_table.prod-route-table.id
}
#6 Create a security group  to allow port 22, 80 and 443
resource "aws_security_group" "allow_web" {
  name        = "allow_web-traffic"
  description = "Allow web inbound traffic"
  vpc_id      = aws_vpc.prod-vpc.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "production"
  }
}

#7 Create network interface with an ip and subnet created on step 4
resource "aws_network_interface" "web-server-leo" {
  subnet_id       = aws_subnet.my-subnet.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_web.id]
}
#8 Assign an elastic ip to the network interface created on step 7
resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.web-server-leo.id
  associate_with_private_ip = "10.0.1.50"
  depends_on = [aws_internet_gateway.prod-gateway]
}
#9 Create ubunto server and install apache/enable apache2
resource "aws_instance" "web-instance" {
  ami = "ami-03d315ad33b9d49c4"
  instance_type = "t2.micro"
  availability_zone = "us-east-1a"
  key_name = "terraform-key"
  network_interface{
    device_index = 0
    network_interface_id = aws_network_interface.web-server-leo.id
  }
  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install apache2 -y
              sudo systemctl start apache2
              sudo bash -c 'echo your very first web server with terraform > /var/www/html/index.html'
              sudo apt install nodejs -y
              sudo apt install npm -y
              EOF
  tags = {
    Name = "production"
  }
}

output "server_public_ip" {
  value = aws_eip.one.public_ip
}
output "server_private_ip" {
  value = aws_instance.web-instance.private_ip
}