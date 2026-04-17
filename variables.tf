variable "region" {
  description = "AWS region to deploy in"
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t3.micro"
}

variable "key_name" {
  description = "Name of your AWS key pair"
  default     = "wordpress-key"
}

variable "db_name" {
  description = "WordPress database name"
  default     = "wordpress"
}

variable "db_user" {
  description = "WordPress database user"
  default     = "wpuser"
}

variable "db_password" {
  description = "WordPress database password"
  default     = "wppassword123"
}