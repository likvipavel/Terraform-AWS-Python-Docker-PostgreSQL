terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  required_version = ">= 0.14.9"
}

provider "aws" {                                #указание провайдера, региона и секретов
    region     = "us-east-1" 
    access_key = "my-key"                       #или export AWS_ACCESS_KEY_ID=ключ  
    secret_key = "my-secret"                    #или export AWS_SECRET_ACCESS_KEY=ключ	и можно убирать эти 2 строчки из кода.
}

resource "aws_instance" "ma_web_server" {
  ami                    = "ami-0022f774911c1d690"          #Amazon AMI
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.my_web_server.id}"]
  user_data = <<EOF
#!/bin/bash
sudo yum -y update
sudo yum -y install httpd
privateIP=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "Web Server with $(privateIP)" > /var/www/html/index.html
sudo systemctl enable httpd --now
EOF
}

resource "aws_security_group" "my_web_server" {
  name = "${random_pet.name.id}-sg"
 
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"                             #all protocol
    cidr_blocks = ["0.0.0.0/0"]
  }
}  

