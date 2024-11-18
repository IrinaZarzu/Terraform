variable "aws_regions" {
  type        = string
  description = "Regions to use for AWS resources"
  default     = "us-east-1"
}

variable "vpc_cidr_block" {
  type        = string
  description = "Base CIDR block for my_site_vpc"
  default     = "10.0.0.0/16"
}

variable "public_subnets_cidr_blocks" {
  type        = list(string)
  description = "Cidr blocks for 2 public subnets"
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "private_subnets_cidr_blocks" {
  type        = list(string)
  description = "Cidr blocks for 6 private subnets"
  default     = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]
}


variable "instance_type" {
  type        = string
  description = "Type of the EC2 instance"
  default     = "t2.micro"
}

variable "company" {
  type        = string
  description = "Company name for the resource tagging"
  default     = "ThreadCraft"
}

variable "project" {
  type        = string
  description = "Project name for resource tagging"
  default     = "3-tier-architecture"
}

variable "name" {
  type        = string
  description = "The base name for resources."
  default     = "app1"
}

variable "tier1_sg" {
  type        = list(string)
  description = "Security groups for tier1"
  default     = ["endpoint-sg", "ec2-tier1", "alb-tier1", "asg-sg1"]
}

variable "tier1_subnets" {
  type        = list(string)
  description = "Subnets for tier1"
  default     = ["private_subnet1", "private_subnet2"]
}

variable "db_name" {
  type        = string
  description = "Name for DB tier 3"
  default     = "ThreadCraftDB"
}

variable "db_allocated_storage" {
  type        = string
  description = "Storage for DB tier 3"
  default     = "20"
}

variable "db_engine_version" {
  type        = string
  description = "MySQL engine version for DB tier 3"
  default     = "8.0"
}

variable "db_instance_type" {
  type        = string
  description = "Instance type for DB tier 3"
  default     = "db.t3.micro"
}

variable "db_username" {
  type        = string
  description = "Username for DB tier 3"
  default     = "yourname"
}

variable "db_password" {
  type        = string
  description = "Password for DB tier 3"
  default     = "set password"
}

variable "db_parameter_group" {
  type        = string
  description = "Configuration settings for DB engine"
  default     = "default.mysql8.0"
}

variable "bucket_name_oac" {
  type        = string
  description = "Name of the bucket"
  default     = "thread-bucket-oac-unique-string"
}

variable "bucket_name" {
  type        = string
  description = "Name of the bucket"
  default     = "thread-bucket-unique-string"
}

variable "account_id" {
  type        = string
  description = "account id"
  default     = "your account ID"
}

variable "domain_name" {
  type        = string
  description = "Domain name for website"
  default     = "s3-origin.threadcraft.link"
} 

variable "domain_name_alborigin" {
  type        = string
  description = "domain name for alb origin"
  default     = "alb-origin.threadcraft.link"
}

variable "domain_name_alb" {
  type        = string
  description = "domain name for alb"
  default     = "threadcraft.link"
}

variable "hosted_zone_name" {
  type = string
  description = "DNS hosted zone name"
  default     = "threadcraft.link"
}

variable "origin_verify_secret" {
  type        = string
  description = "Secret value for X-Origin header"
  default     = "YouGotThis!"
}

variable "map_public_ip_on_launch" {
  type        = bool
  description = "Map a public IP address for Subnet instances"
  default     = true
}

variable "custom_ami" {
  type        = string
  description = "Custom AMI to launch Apache web server"
  default     = "Apache_server"
}

