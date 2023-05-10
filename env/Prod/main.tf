module "aws-prod" {
  source = "../../infra"
  instancia = "t2.micro"
  regiao_aws = "us-west-2"
  chave = "IaC-Prod"
  grupoDeSeguranca = "Producao"
  minimo = 1
  maximo = 2
  nomeGrupo = "Prod"
}

output "IP" {
  value = module.aws-prod.IP_Publico
}