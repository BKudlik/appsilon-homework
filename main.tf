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

resource "aws_route_table" "appsilon_route_table" {
  vpc_id = aws_vpc.appsilon_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.appsilon_gw.id
  }
}

resource "aws_route" "appsilon_route" {
  route_table_id         = aws_route_table.appsilon_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.appsilon_gw.id
}

resource "aws_network_interface" "eth0" {
  subnet_id   = aws_subnet.appsilon_subnet.id
  private_ips = ["172.31.0.100"]

  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_instance" "appsilon_homework" {
  ami                         = var.aws_ami
  instance_type               = var.aws_instance_type
  key_name                    = var.aws_key_name
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.appsilon_subnet.id

  depends_on = [
    aws_internet_gateway.appsilon_gw
  ]

  # network_interface {
  #   network_interface_id = aws_network_interface.eth0.id
  #   device_index         = 0
  # }

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
    host = aws_instance.appsilon_homework.public_ip
  }
}
