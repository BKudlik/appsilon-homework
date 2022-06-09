terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.17.1"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_budgets_budget" "my_budget" {
  name              = "my_budget"
  budget_type       = "COST"
  limit_amount      = "5.0"
  limit_unit        = "USD"
  time_unit         = "MONTHLY"
  time_period_start = "2022-06-08_16:00"
}

resource "aws_vpc" "appsilon_vpc" {
  cidr_block           = "172.31.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "appsilon_vpc"
  }
}

resource "aws_subnet" "appsilon_subnet" {
  vpc_id                                      = aws_vpc.appsilon_vpc.id
  cidr_block                                  = "172.31.0.0/24"
  availability_zone                           = "eu-central-1a"
  map_public_ip_on_launch                     = true
  private_dns_hostname_type_on_launch         = "resource-name"
  enable_resource_name_dns_a_record_on_launch = true

  tags = {
    Name = "appsilon_subnet"
  }
}

resource "aws_internet_gateway" "appsilon_gw" {
  vpc_id = aws_vpc.appsilon_vpc.id

  tags = {
    Name = "appsilon_gw"
  }
}
resource "aws_route" "appsilon_route" {
  route_table_id         = aws_vpc.appsilon_vpc.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.appsilon_gw.id
}

resource "aws_security_group" "appsilon_homework" {
  name        = "appsilon_homework"
  description = "Allow all necessary traffic"
  vpc_id      = aws_vpc.appsilon_vpc.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:aws-vpc-no-public-ingress-sgr
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:aws-vpc-no-public-ingress-sgr
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:aws-vpc-no-public-ingress-sgr
  }

  ingress {
    description = "ICMP"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:aws-vpc-no-public-ingress-sgr
  }

  egress {
    description = "Default AWS egress rule"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:aws-vpc-no-public-egress-sgr
  }
}
resource "aws_instance" "appsilon_homework" {
  ami                         = var.aws_ami
  instance_type               = var.aws_instance_type
  key_name                    = var.aws_key_name
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.appsilon_subnet.id
  vpc_security_group_ids      = [aws_security_group.appsilon_homework.id]
  metadata_options {
    http_tokens   = "required"
    http_endpoint = "enabled"
  }
  root_block_device {
    encrypted = true
  }
  depends_on = [
    aws_internet_gateway.appsilon_gw
  ]

  credit_specification {
    cpu_credits = "unlimited"
  }

  tags = {
    Name = "appsilon_homework"
  }
  provisioner "file" {
    source      = "install.sh"
    destination = "/tmp/install.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/install.sh",
      "sudo sh /tmp/install.sh",
    ]
  }

  connection {
    user        = var.INSTANCE_USERNAME
    private_key = file("${var.PATH_TO_PRIVATE_KEY}")
    host        = aws_instance.appsilon_homework.public_ip
  }
}
