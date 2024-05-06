# environment variables
region       = ""
project_name = ""
aws_profile  = ""

#VPC vars
vpc_cidr               = "x.x.x.x/16"
public_subnet_az1_cidr = "x.x.x.x/24"

#ec2 server variables
instance_type    = ""
ami_id           = ""
ssh_key          = "" # Make sure this ssh key exists in the account and region you will be provisioning to
ms_teams_webhook = "" # Optional but recommended

#acm and Route53 variables
domain_name    = ""
hosted_zone_id = ""


