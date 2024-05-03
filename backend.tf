# store the terraform state file in s3 and lock with dynamodb
terraform {
  backend "s3" {
    bucket         = "<remote bucket>"
    key            = "location to store state file witin bucket"
    region         = "region where the bucket is"
    profile        = "aws profile for deployment creds, use aws access and secret key if aws cli is not configured"
    dynamodb_table = "<state lock dynamodb table>"
  }
}