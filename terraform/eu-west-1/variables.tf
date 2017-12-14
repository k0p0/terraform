variable "aws_access_key" {
  type    = "string"
  default = ""
}

variable "aws_secret_key" {
  type    = "string"
  default = ""
}

# debian-stretch-hvm-x86_64-gp2-2017-10-08-48016
variable "image" {
  type    = "string"
  default = "ami-ce76a7b7" # eu-west-1
}

variable "region" {
  type    = "string"
  default = "eu-west-1"
}
