# Creating My Variables 

variable "region" {
    default = "us-east-1"
}

variable "cidr_blocks" {
    default = "10.0.0.0/16"
}

variable "subnet_pub" {
    default = "10.0.0.0/24"
  
}

variable "subnet_priv" {
    default = "10.0.1.0/24"
  
}

variable "ami" {
    default = "ami-032346ab877c418af"
  
}

variable "instance_type" {
    default = "t2.micro"
  
}

variable "key" {
    default = "clintontest"
  
}

variable "instance" {
    type = number
    default = 2
}