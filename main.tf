terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

resource "aws_instance" "app_server" {
  ami           = "ami-0db245b76e5c21ca1"
  instance_type = "t2.micro"
  key_name      = "iac-alura"
  user_data     = <<-EOF
              #!/bin/bash
              cd /home/ubuntu
              echo "<h1>Criado pelo Terraform TM</h1>" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF 

  tags = {
    Name = "Primeira instancia"
  }
}
