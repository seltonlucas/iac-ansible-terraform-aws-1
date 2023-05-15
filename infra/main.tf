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

resource "aws_launch_template" "maquina" {
  image_id           = "ami-0db245b76e5c21ca1"
  instance_type = var.instancia
  key_name      = var.chave
  tags = {
    Name = "Terraform Ansible Python"
  }
  security_group_names = [var.grupoDeSeguranca]
  user_data = filebase64(ansible.sh)
}

resource "aws_key_pair" "chaveSSH" {
  key_name = var.chave
  public_key = file("${var.chave}.pub")
}

resource "aws_autoscaling_group" "grupo" {
  availability_zone = [ "${var.regiao_aws}a" ]
  name = var.nomeGrupo
  max_size = var.maximo
  min_size = var.minimo
  launch_template {
    id = aws_launch_template.maquina.id
    version = "$latest"
  }
  target_group_arns = [ aws_lb_target_group.alvoLoadBalancer.arn ]
}

resource "aws_default_subnet" "subnet_1" {
  availability_zone = [ "${var.regiao_aws}a" ]
}

resource "aws_default_subnet" "subnet_2" {
  availability_zone = [ "${var.regiao_aws}b" ]
}

resource "aws_lb" "loadBalancerProducao" {
  internal = false
  subnets = [ aws_default_subnet.subnet_1, aws_default_subnet.subnet_2 ]
}

resource "aws_lb_target_group" "alvoLoadBalancer" {
  name = "maquinasAlvo"
  port = "8000"
  protocol = "HTTP"
  vpc_id = aws_default_vpc.default.id
}

resource "aws_default_vpc" "default" {
  
}

resource "aws_lb_listener" "entradaLoadBalancer" {
  load_balancer_arn = aws_lb.loadBalancerProducao.arn
  port = "8000"
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.alvoLoadBalancer.arn
  }
}