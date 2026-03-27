variable "aws_region" {
  description = "Regiao AWS"
  type        = string
  default     = "us-east-2"
}

variable "project_name" {
  description = "Nome do projeto"
  type        = string
  default     = "cloudshop"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "availability_zones" {
  type    = list(string)
  default = ["us-east-2a", "us-east-2b"]
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "key_name" {
  description = "Nome do Key Pair EC2"
  type        = string
}

variable "db_password" {
  description = "Senha do banco RDS"
  type        = string
  sensitive   = true
}