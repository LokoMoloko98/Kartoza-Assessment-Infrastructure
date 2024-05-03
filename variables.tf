# environment variables
variable "region" {
  description = "region to create resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "project name"
  type        = string
  default     = "KTC"
}

#VPC variable
variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "172.31.0.0/16"
}

#public subnet availabilty zone 1 cidr variable
variable "public_subnet_az1_cidr" {
  description = "public subnet availabilty zone one cidr"
  type        = string
  default     = "172.31.1.0/24"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "ami_id" {
  description = "The AMI to use"
  type        = string
  default     = "ami-0ddda618e961f2270"
}

#security-group variable
variable "ssh_location" {
  description = "ip address that can ssh into the server, it should be manually changed after provisioning"
  type        = string
  default     = "41.216.203.213/32"
}

variable "host_os" {
  type    = string
  default = "linux"
}

variable "hostzone" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "key" {
  type = string
  default = "spacelift"
}