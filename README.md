# Kartoza Assessment Infrastructure

This repository contains Terraform configuration files that provision and deploy Moloko Mokubedi's Kartoza technical assessment submission in an AWS Cloud environment. The setup includes the creation of a Virtual Private Cloud (VPC) with a public subnet, an IAM instance role with least-privilege permissions, and an EC2 instance launched within the VPC. The EC2 instance is configured with a user data script that does various bootstrapping tasks including updating the VM, installing Docker, managing the instance name, making Route53 (DNS) changes, and deploying the web app.

## Features

1. **VPC Creation**: Sets up a Virtual Private Cloud (VPC) with a public subnet, including the necessary networking infrastructure such as route tables and internet gateway.

2. **Instance Role Creation**: Defines an instance role with IAM policies that grant permissions to access, modify and be accessed abd modified by these AWS services
    - EC2
    - EBS 
    - Route53
    - Systems Manager (SSM).

3. **EC2 Instance Provisioning**: Launches an EC2 instance within the VPC and associates the networking infrastructure. The instance is configured with the previously created instance role.

4. **User Data Script**:
    - Updates the VM and downloads Docker, Docker-Compose nd other important packages.
    - Names the EC2 instance.
    - Creates an A record in Route53 (using the Domain and hosted zone provided) and links it to the instance.
    - Clones the [Kartoza_Tech_Assessment](https://github.com/LokoMoloko98/Kartoza_Tech_Assessment) repository from GitHub.
    - Builds, deploys and connects the Docker containers via Docker-Compose

## Virtual Infrastructure Architectural Diagram
![Arch Diagram](./Arch%20Diagram/Architecture_Diagram.jpg)

## Pre-requisites:
These AWS resources have to be created/configured manually via the AWS console (or by another IaC process) before provisioning this IaC stack, especially: 
   - **A remote backend S3 bucket**.
   - **A configured ```awscli``` profile on the machine that will provision the stack.**
   - **A DynamoDB table with the string ```LockID``` as the Primary Key.**
   - **An SSH key in OpenSSH format ```(.pem)``` in the EC2 console.**
   - **The SSM Manage Instance role enabled and activated**

## Assumptions
- The machine that will provision this Terraform stack has installed on it least a version of Terraform from 1.4*.*
- The machine that will provision this IaC stack is a Unix based machine (MacOS or a Linux Distribution).


## Usage
### 1. Clone this repository to your local machine:
```bash
git clone https://github.com/LokoMoloko98/Kartoza-Assessment-Infrastructure
```

### 2. Navigate to the directory:
```
cd Kartoza-Assessment-Infrastructure
```

### 3. Modify the backend.tf file with your AWS profile and needed S3 remote-backend configurations to integrate the IaC config with your AWS environment.

``` 
terraform {
  backend "s3" {
    bucket         = "Provide the name of the S3 bucket name that will hold the statefile"
    key            = "Provide the path to save the state file"
    region         = "Provide the AWS region code where the remote bucket is located"
    profile        = "Provide you currently logged awscli profile. Use aws access and secret keys if the awscli is not configured on your machine. THIS IS NOT RECOMMENDED. Using the awscli is best practice."
    dynamodb_table = "Provide the name of the DynamoDB table that holds the state lock hash.
":  }
}
```

### 4. Initialize the backend for the state management of your Terraform config and download the AWS provider plugin by running this command.
```
terraform init
```
If any errors return check for any misconfigurations in the terraform resource in the backend.tf file and try reinitializing again.

### 5. Configure the AWS Environment you will provision this IaC stack into by making a copy of the  ```tfvars_template.tfvars``` and renaming it to  ```terraform.tfvars``` and providing the values of the variables in that file. The description and datatype of each variable can be found in the ```variables.tf``` file.

The contents of the ```tfvars_template.tfvars``` file look like this:
```
# environment variables
region       = ""
project_name = ""
aws_profile  = ""

#VPC vars
vpc_cidr               = ""
public_subnet_az1_cidr = ""

#ec2 server variables
instance_type    = ""
ami_id           = ""
ssh_key          = "" # Make sure this ssh key exists in the account and region you will be provisioning to
ms_teams_webhook = "" # Optional but recommended

#acm and Route53 variables
domain_name    = ""
hosted_zone_id = ""
```

### 6. Validate the terraform configuration files to ensure that they are free of syntax and dependency errors.

```
terraform validate
```

### 7. Review the virtual infrastructure to be provisioned by producing a terraform plan:
```
terraform plan
```

### 8. If you are satisfied with the plan, go ahead and provision the infrastructure:
```
terraform apply --auto-approve
``` 
Once the apply operation is done you should get an output of the FQDN to access the web app. It will look something like this: 
```kartoza_assessment_output_fqdn = "https://<project_name>.<domain>"```

### 9. Wait for approximately 5 minutes for the EC2 server to be bootstrapped by the user data script and for the web app to be in a healthy state. If you provided a ```MS Teams Webhhook``` to one of your notification channels you will recieve a notification once the User data script has deployed the web-app.

### 9. You should now be able to interact with the Town Survey Mark (TSM) Browser Web App on your browser by following the URL with the domain record created by the stack. 

To view the health and status of your services, loadbalancers and routers you can access the Traefik Dashboard on:

```
http://<project_name>.<domain>:8080
```
You can only access this url from the machine that provisioned the stack (i.e. the machine that ran the command ```terraform apply --auto-approve```, ideally this should be your machine), this is because the security group attached to the server has been configured to only allow access to this port from your machine's IP (refer to the ```security_group.tf``` file).

### 10. Cleaning up the stack
To clean up the stack, destroy the resources that were provisioned by the Terraform files.

```
terraform destroy
```
A destroy plan will be generated and you can accept to destroy the resources if you are satisfied with the plan.

### Basic Troubleshooting:
- SSH into the instance or Use the AWS SSM Session manager to access the EC2 server terminal. It is recommended to change to the super user ```sudo su```. From here you can access the docker container statuses and container IDs to see if there are issues by running:
  ```
  docker ps -a
  ```

- To access the logs of a container run this command:
  ```
  docker logs <container_id>
  ```
  where ```<container_id>``` is the ID of the container in question and can be retrieved by running ```docker ps -a```
   
