## Prerequisites
What is needed in order to use this repo:
- A computer/vm with Linux or Linux Subsystem installed on windows
- Terraform installed on your OS
- local clone of the repository available on your device
- aws cli installed and configured - How to: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html You need to provide AWS Access Key ID and Secret Access Key - here's how to generate this https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html
- AWS EC2 key pair generated and private key stored on your drive - here's how https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/create-key-pairs.html. Default path to the private key is "~/.ssh/appsilon_homework.pem". You can change it (along with other variables declared in variables.tf) by providing the variable values in other ways described in this article: https://www.terraform.io/language/values/variables

## Execution instructions
Change the working directory to the location of local copy of this repository.
Run "terraform init" to initialize working directory after cloning from git repo.
Run terraform plan. Make sure the final configuration is matching your expectations.
Run terraform apply to create the solution on AWS platform.
Run terraform output to get the url of rstudio-connect.
Run terraform destroy when you want to get rid of the solution.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.17.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.17.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_budgets_budget.my_budget](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/budgets_budget) | resource |
| [aws_instance.appsilon_homework](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_internet_gateway.appsilon_gw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_route.appsilon_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_security_group.appsilon_homework](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.appsilon_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.appsilon_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_INSTANCE_USERNAME"></a> [INSTANCE\_USERNAME](#input\_INSTANCE\_USERNAME) | Username used to connect to the instance | `string` | `"ec2-user"` | no |
| <a name="input_PATH_TO_PRIVATE_KEY"></a> [PATH\_TO\_PRIVATE\_KEY](#input\_PATH\_TO\_PRIVATE\_KEY) | Path to aws private key used to connect to the instance | `string` | `"~/.ssh/appsilon_homework.pem"` | no |
| <a name="input_aws_ami"></a> [aws\_ami](#input\_aws\_ami) | AWS AMI id | `string` | `"ami-09439f09c55136ecf"` | no |
| <a name="input_aws_instance_type"></a> [aws\_instance\_type](#input\_aws\_instance\_type) | Type of AWS EC2 instance | `string` | `"t2.micro"` | no |
| <a name="input_aws_key_name"></a> [aws\_key\_name](#input\_aws\_key\_name) | AWS Key pair name | `string` | `"appsilon_homework"` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS availability zone | `string` | `"eu-central-1"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
