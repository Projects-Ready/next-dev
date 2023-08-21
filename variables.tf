# Create 3 instances for jenkins, Docker and jumpserver
variable "instance_count" {
  description = "Number of EC2 instances to create"
  type        = number
  default     = 4
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
  default     = "ami-0dc8c969d30e42996"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default = "t2.macro"
}

variable "key_pair" {
  description = "Name of the EC2 key pair"
  type        = string
}

variable "private_cidr" {
  type    = list(string)
  default = ["10.0.0.0/19", "10.0.32.0/19"]
}
variable "availability_zones" {
  type    = list(string)
  default = ["us-west-1a", "us-west-1b"]
}

variable "public_cidr" {
  type    = list(string)
  default = ["10.0.64.0/19", "10.0.96.0/19"]
}




  
