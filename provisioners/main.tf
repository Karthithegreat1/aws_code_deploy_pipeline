provider "aws"{
region = "us-east-1"
}

variable "cidr" {
default = "10.0.0.0/16"
}

resource "aws_key_pair" "name" {
  key_name = "terraform-demo-karthi"
  public_key = file("/home/codespaces/.ssh/id_rsa.pub")
}

resource "aws_vpc" "awsvpc" {
cidr_block = var.cidr
}

resource "aws_subnet" "vpcsubnet" {
vpc_id = aws_vpc.awsvpc.id
cidr_block = "10.0.0.0/24"
availability_zone = "us-east-1a"
map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.awsvpc.id
}

resource "aws_route_table" "rt" {
 vpc_id = aws_vpc.awsvpc.id
 route{
 cidr_block = "0.0.0.0/0"
 gateway_id = aws_internet_gateway.igw.id
 }
}

resource "aws_route_table_association" "rta"{
subnet_id = aws_subnet.vpcsubnet.vpc.id
route_table_id = aws_route_table.rt.id
}

resource "aws_security_group" "sg1" {
name = "webpage"
vpc_id = aws_vpc.awsvpc.id
  

  ingress{
  description = "http port vpc"
  from_port =  80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

  egress{
  description="SSH"
  from_port = 22
  to_port=22
  protocol = "tcp" 
  cidr_blocks = ["0.0.0.0/0"]
  }
  }

  
