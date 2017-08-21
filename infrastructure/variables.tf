variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "aws_region" {
    description = "EC2 Region"
    default = "eu-central-1"
}

variable "aws_availability_zone" {
    description = "Availability Zone"
    default = "eu-central-1a"
}

variable "vpc_cidr" {
    description = "CIDR of the VPC"
    default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
    description = "CIDR for the Public Subnet"
    default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
    description = "CIDR for the Private Subnet"
    default = "10.0.2.0/24"
}

variable "jenkins_master_instance_type" {
    description = "Jenkins Master EC2 instance type"
    default = "t2.micro"
}
