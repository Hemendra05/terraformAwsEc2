variable "aws_key" {}
variable "VPC_cidrBlock" {}
variable "instanceTenancy" {}
variable "Subnet_cidrBlock" {}
variable "availabilityZone" {}
variable "mapPublicIpOnLaunch" {
  type = bool
}
variable "awsAmiId" {}
variable "awsInstanceTpye" {}
variable "vpcTags" {
    type = map
    default = {
        Auther = "Hemendra",
        Name = "myVPC",
        ENV = "test"
    }
}

variable "subnetTags" {
    type = map
    default = {
        Auther = "Hemendra",
        Name = "mySubnet",
        ENV = "test"
    }
}

variable "internetGatewayTags" {
    type = map
    default = {
        Auther = "Hemendra",
        Name = "myGTW",
        ENV = "test"
    }
}

variable "routeTableTags" {
    type = map
    default = {
        Auther = "Hemendra",
        Name = "myRT",
        ENV = "test"
    }
}

variable "securityGroupsTags" {
    type = map
    default = {
        Auther = "Hemendra",
        Name = "AllowAll",
        ENV = "test"
    }
}

variable "instanceTags" {
    type = map
    default = {
        Auther = "Hemendra",
        Name = "myInstance",
        ENV = "test"
    }
}
