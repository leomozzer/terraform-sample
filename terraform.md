## Terraform commands

<strong>Terraform init</strong>

* Initialize working directory - Downloads and included all modules and providers (except third party) in terraform file.
* Needs to be run before deploying infrastructure - As other stages of Terraform deployment require provider, plugins, and modules, this command needs to be run first!.
* Syncs config, safe to run - Configures backend for storing infrastructure state and does not modify or delete and existing configuration or state

<strong>Terraform fmt</strong>

* Formats templates for readability - Makes Terraform templates look stylish and easy-to-read
* Helps in keeping code consistent - Keeps the formatting consistent, especially if teams are collaborating and tracking Terraform code through version control
* Safe to run at any time - Does not modify or add anything to code; only reformats it and rewrites it back to the files

<strong>Teraform validate</strong>
* Validates config files - Checks for syntax mistakes and internal consistency (e.g typos and misconfigured resources)
* Needs terraform init to be run first - Expects and initialized working directory, therefore the init command should be run before validate can be run
* Safe to run anytime - A use case would be to run in order to check for issues in TF code or before commiting to version control

<strong>Teraform plan</strong>
* Creates execution plan - Calculates the delta between requited state and current to create an execution plan
* Fail-safe before actual deployment - It's basically a check to see if the deployment execution plan matches expectation before creating or modifying any actual infrastructure
* Execution plan can be saved using the -out flag - However, be aware that sensitive configuration items would also be saved in a file as plaintext

<strong>Teraform apply (Deploy!)</strong>
* Deploy the execution plan - Applies to changes required to achive desired state of Terraform code
* By default will prompt before deploying - By default, the user will need to type in "yes" explicity before any infrastructure is deployed
* Will display the execution plan again - Terraform apply will display the executiuon plan one last time before prompting for actual deployment

<strong>Terraform destroy</strong>
* Delete all the resources created
* Will delete all resources declarated
* By commenting an specific resource like instance X, the terraform will notice that this instance shouldn't exists, so will delete it from the provider

## Terraform Files

<strong>terraform.tfstate</strong>
* Represents all the states from terraform
* Every change on the terraform file will be added on this file
* Store all the resource created on this file

## Terraform variables

* Create a new file with tfvars extension
* Allows to use string, arrays and objects
* sampe.tfvars
```
sample_array = [
    {
        cidr_block = "10.0.1.0/24",
        name = "prod-subnet"
    },
    {
        cidr_block = "10.0.1.0/36",
        name = "dev-subnet"
    }
]
```
* main.tf
```
resource "aws_subnet" "my-subnet"{
  vpc_id = aws_vpc.prod-vpc.id
  cidr_block = var.sample_array[1].cidr_block
  availability_zone = "us-east-1a"
  tags = {
    Name = var.sample_array[1].name
  }
}
```


