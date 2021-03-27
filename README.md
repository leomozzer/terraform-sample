# Terraform VS CloudFormation VS Ansible

<strong>Terraform</strong>

* Purpose-built for infrastructure automation and Cloud Agnostic (which means it is not tied into one cloud vendor). Works across all popular providers (AWS/GCP/Azure)
* Easy to write, declarative templates in HCL (Hashicorp Configuration Language)
* Keeps track of infrastructure through local or remote state files. User must back up the state file.
* Offers built-in functions, and a vast array of modules and provides for working with cloud and open-perm systems
* Agentless, only requires a self contained Terraform binary on your system

<strong>CloudFormation</strong>

* Infrastructure as a code for AWS, which is inherent in AWS only
* CloudFormation templates can be written on JSON or YML
* The CloudFormation service lives in the AWS Cloud - no agents or installation of any sort required. It keeps track of deployment inherently; Use need not worry.
* Offers signaling resources for insfrastructure bootstraping ousing cfn utility in tandem with cloud-init. Also offers built-in functions e.g Fn::GetAtt
* Offers easy deployments across AWS realm using StackSets and has features such as drift detection

<strong>Ansible</strong>

* A hybrid configuration management and infrasctructute deployment tool. Popular for config management
* YAML
* Does not keep track of state of infrastructure deployment like CloudFormation & Terraform
* Offers both procedural (ad-hoc tasks, playbooks) and declarative modules (AWS etc)
* Offers a vast array of modules for most OS-level utilities as well as cloud and on-prem infrastructure venders
* Agentless, accesses infrasctructure APIs for infra deployment and SSH for OS configuration management

![Terraform VS CloudFormation VS Ansible](images/terraform_cloudformation_ansible.jpg?raw=true "Title")

<strong>References</strong>

* [How to download and install terraform on windows](https://www.youtube.com/watch?v=HNOIXPpBQWg)
* [Terraform Course - Automate your AWS cloud infrastructure](https://www.youtube.com/watch?v=SLB_c_ayRMo)