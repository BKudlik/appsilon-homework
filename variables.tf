variable "aws_region" {
  type    = string
  default = "eu-central-1"
}

variable "aws_ami" {
  type    = string
  default = "ami-09439f09c55136ecf"
}

variable "aws_instance_type" {
  type    = string
  default = "t2.micro"
}

variable "aws_key_name" {
  type    = string
  default = "appsilon_homework"
}

variable "INSTANCE_USERNAME" {
  default = "ec2-user"
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "~/.ssh/appsilon_homework.pem"
}
