# environment variables
variable "region" {
  description = "region to create resources"
  type        = string
}

variable "project_name" {
  description = "project name"
  type        = string
}

#VPC variable
variable "vpc_cidr" {
  description = "IPv4 VPC CIDR block"
  type        = string
}

#public subnet availabilty zone 1 cidr variable
variable "public_subnet_az1_cidr" {
  description = "IPv4 CIDR block for the public subnet in availabilty zone one"
  type        = string
}

variable "instance_type" {
  description = "The EC2 instance type to provision. Use an x86 based instance type to avoid Docker Build issues. Avoid Gravitron/ARM instances"
  type    = string
}

variable "ami_id" {
  description = "The ID of the AMI to use. AMI IDs are region specific. It is recommended to Use the Amazon Linux 2023, or any Fedora/RHEL based Linux distro"
  type        = string
}

# The Route53 registered domain name and associated Route53 Hosted Zone ID that 
# you would like to serve the web app from are very important for the 
# Traefik reverse proxy to identify the fqdn to register 
# a LetsEncrypt SSL certificate for. 

variable "hosted_zone_id" {
  description = "The hosted zone where the Domain is managed in Route 53"
  type = string
}

variable "domain_name" {
   description = "The Route53 Registered Domain"
  type = string
}

variable "ssh_key" {
  description = "The ssh key to connect to the EC2 server hosting the solution with. This ssh key must exist in the account and region that this stack will be provisioned to beforehand"
  type = string
}

variable "aws_profile" {
  description = "The awscli profile that has the credentials to connect to the account that this stack will be provisioned to"
  type = string
}

variable "ms_teams_webhook" {
  description = "Optional. An MS Teams webhoot to notify you when the User Data script has deployed the web app on the EC2 server"
  type = string
}