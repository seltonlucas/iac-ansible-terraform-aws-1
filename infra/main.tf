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
  region  = var.regiao_aws
}

resource "aws_instance" "app_server" {
  ami           = "ami-0db245b76e5c21ca1"
  instance_type = var.instancia
  key_name      = var.chave
  # user_data     = <<-EOF
  #             #!/bin/bash
  #             cd /home/ubuntu
  #             echo "<h1>Criado pelo Terraform TM</h1>" > index.html
  #             nohup busybox httpd -f -p 8080 &
  #             EOF 

  tags = {
    Name = "Terraform Ansible Python"
  }
}

resource "aws_key_pair" "chaveSSH" {
  key_name = var.chave
  public_key = file("${var.chave}.pub")
}

output "IP_Publico" {
  value = aws_instance.app_server.public_ip
}