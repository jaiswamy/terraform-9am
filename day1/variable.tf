variable "ami" {
    description = "this is the ami for creating an instance"
    type = string
    default = "ami-0ae8f15ae66fe8cda"
}
variable "type" {
    description = "this is the instance type"
    type = string
    default = "t2.micro"  
}
variable "key" {
    type = string
    default = "us"
  
}