variable "aws_region" {
  default = "us-west-1"
  type    = string
}

variable "ami" {
  default = "ami-0118dc74bd8f98b13"
  type    = string
}

variable "instance_type" {
  default = "t2.micro"
  type    = string
}

variable "key_name" {
  default = "princeKeypair"
  type    = string
}

variable "associate_public_ip_address" {
  default = "true"
  type    = bool
}

variable "jenkins-tag-name" {
  default = "Jenkins-Server"
  type    = string
}

variable "bucket" {
  default = "jenkins-s3-bucket-mario-moyo20"
  type    = string
}

variable "acl" {
  default = "private"
  type    = string
}

variable "policy_arn" {
  default = "arn:aws:iam::aws:policy/AmazonS3ReadWriteAccess"
  type    = string
}