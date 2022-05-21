terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  required_version = ">= 0.14.9"
}

provider "aws" { #указание провайдера, региона
  region = "us-east-1"
}

#Create new VPC(vpc)
resource "aws_vpc" "vpc-terraform-homework-1" {
  cidr_block = "10.6.0.0/16"

  tags = {
    Name = "vpc-terraform-homework-1"
  }
}

#Create Internet Gateway(igw) and attach it to the VPC
resource "aws_internet_gateway" "igw-terraform-homework-1" {
  vpc_id = aws_vpc.vpc-terraform-homework-1.id
  tags = {
    Name = "igw-terraform-homework-1"
  }
}

#Create 2 public and 2 private subnets within the VPC
resource "aws_subnet" "subnet-public-a-terraform-homework-1" {
  vpc_id                  = aws_vpc.vpc-terraform-homework-1.id
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  cidr_block              = "10.6.10.0/24"

  tags = {
    Name = "subnet-public-a-terraform-homework-1"
  }
}

resource "aws_subnet" "subnet-public-b-terraform-homework-1" {
  vpc_id                  = aws_vpc.vpc-terraform-homework-1.id
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"
  cidr_block              = "10.6.11.0/24"


  tags = {
    Name = "subnet-public-b-terraform-homework-1"
  }
}

resource "aws_subnet" "subnet-private-a-terraform-homework-1" {
  vpc_id            = aws_vpc.vpc-terraform-homework-1.id
  availability_zone = "us-east-1a"
  cidr_block        = "10.6.12.0/24"

  tags = {
    Name = "subnet-private-a-terraform-homework-1"
  }
}

resource "aws_subnet" "subnet-private-b-terraform-homework-1" {
  vpc_id            = aws_vpc.vpc-terraform-homework-1.id
  availability_zone = "us-east-1b"
  cidr_block        = "10.6.13.0/24"

  tags = {
    Name = "subnet-private-b-terraform-homework-1"
  }
}

# Add Route Tables(rt) for the subnets
resource "aws_route_table" "rt-public-terraform-homework-1" {
  vpc_id = aws_vpc.vpc-terraform-homework-1.id

  tags = {
    Name = "rt-public-terraform-homework-1"
  }
}

resource "aws_route_table" "rt-private-terraform-homework-1" {
  vpc_id = aws_vpc.vpc-terraform-homework-1.id

  tags = {
    Name = "rt-private-terraform-homework-1"
  }
}

#Add route(r) for publuc route table 
resource "aws_route" "r-public-terraform-homework-1" {
  route_table_id         = aws_route_table.rt-public-terraform-homework-1.id
  gateway_id             = aws_internet_gateway.igw-terraform-homework-1.id
  destination_cidr_block = "0.0.0.0/0"
}

#Create private NAT gateway(nat) 
resource "aws_nat_gateway" "nat-private-terraform-homework-1" {
  connectivity_type = "private"
  subnet_id         = aws_subnet.subnet-public-a-terraform-homework-1.id

  tags = {
    Name = "nat-private-terraform-homework-1"
  }
}

#Add route(r) for private route table 
resource "aws_route" "r-private-terraform-homework-1" {
  route_table_id         = aws_route_table.rt-private-terraform-homework-1.id
  nat_gateway_id         = aws_nat_gateway.nat-private-terraform-homework-1.id
  destination_cidr_block = "0.0.0.0/0"
}

#Provides a resource(rta) to create an association between the route tables and the subnets
resource "aws_route_table_association" "rta-public-a-terraform-homework-1" {
  route_table_id = aws_route_table.rt-public-terraform-homework-1.id
  subnet_id      = aws_subnet.subnet-public-a-terraform-homework-1.id
}

resource "aws_route_table_association" "rta-public-b-terraform-homework-1" {
  route_table_id = aws_route_table.rt-public-terraform-homework-1.id
  subnet_id      = aws_subnet.subnet-public-b-terraform-homework-1.id
}

resource "aws_route_table_association" "rta-private-a-terraform-homework-1" {
  route_table_id = aws_route_table.rt-private-terraform-homework-1.id
  subnet_id      = aws_subnet.subnet-private-a-terraform-homework-1.id
}

resource "aws_route_table_association" "rta-private-b-terraform-homework-1" {
  route_table_id = aws_route_table.rt-private-terraform-homework-1.id
  subnet_id      = aws_subnet.subnet-private-b-terraform-homework-1.id
}

#Create ECS cluster(ecsc)
resource "aws_ecs_cluster" "ecsc-terraform-homework-1" {
  name = "ecsc-terraform-homework-1"
}

#Create ECS task definition(ecs-task-def)
resource "aws_ecs_task_definition" "ecstd-terraform-homework-1" {
  family                   = "ecs-task-def-terraform-homework-1"
  execution_role_arn       = aws_iam_role.ecs-task-ex-r-terraform-homework-1.arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024
  container_definitions    = <<TASK_DEFINITION
[
  {
    "name": "ecs-task-def-terraform-homework-1",
    "image": "762135247538.dkr.ecr.us-east-1.amazonaws.com/terraform-homework-1-python:v1",
    "cpu": 512,
    "memory": 1024,
    "essential": true
  }
]
TASK_DEFINITION

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}


#Create IAM task execution role(ecs-task-ex-r)
resource "aws_iam_role" "ecs-task-ex-r-terraform-homework-1" {
  name = "ecs-task-ex-r-terraform-homework-1"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

#Create IAM role policy attachment(ecs-rp-attach)
resource "aws_iam_role_policy_attachment" "ecs-rp-attach-terraform-homework-1" {
  role       = aws_iam_role.ecs-task-ex-r-terraform-homework-1.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

#Create ECS service(ecs-svc)
resource "aws_ecs_service" "ecs-svc-terraform-homework-1" {
  name            = "terraform-homework-1"
  cluster         = aws_ecs_cluster.ecsc-terraform-homework-1.id
  task_definition = aws_ecs_task_definition.ecstd-terraform-homework-1.arn
  launch_type     = "FARGATE"
  desired_count   = 2

  network_configuration {
    subnets          = [aws_subnet.subnet-public-a-terraform-homework-1.id, aws_subnet.subnet-public-b-terraform-homework-1.id]
    assign_public_ip = true
  }
}
