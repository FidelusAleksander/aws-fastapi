terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.26.0"
    }
  }
  required_version = ">= 1.1.0"

  cloud {
    organization = "aws-fastapi"

    workspaces {
      name = "aws-fastapi"
    }
  }
}


provider "aws" {
  region = "eu-west-1"
}


resource "aws_instance" "web" {
  ami                    = "ami-00ae935ce6c2aa534"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web-sg.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1> Hello, world </h1>" > /var/www/html/index.html
              EOF
}

resource "aws_security_group" "web-sg" {
  name = "fastapi-web-sg"

  ingress {
    name             = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    name        = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    name        = "All traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "web-address" {
  value = aws_instance.web.public_dns
}
