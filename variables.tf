variable "aws_region" {
  type        = string
  default     = "eu-central-1"
  description = "AWS availability zone"
}

variable "aws_ami" {
  type        = string
  default     = "ami-09439f09c55136ecf"
  description = "AWS AMI id"
}

variable "aws_instance_type" {
  type        = string
  default     = "t2.micro"
  description = "Type of AWS EC2 instance"
}

variable "aws_key_name" {
  type        = string
  default     = "appsilon_homework"
  description = "AWS Key pair name"
}

variable "INSTANCE_USERNAME" {
  default     = "ec2-user"
  description = "Username used to connect to the instance"
}

variable "PATH_TO_PRIVATE_KEY" {
  default     = "~/.ssh/appsilon_homework.pem"
  description = "Path to aws private key used to connect to the instance"
}
