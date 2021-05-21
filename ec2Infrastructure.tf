#Creating VPC
resource "aws_vpc" "terraformVPC" {
  cidr_block       = var.VPC_cidrBlock
  instance_tenancy = var.instanceTenancy

  tags = {
    Auther= var.vpcTags["Auther"]
    ENV   = var.vpcTags["ENV"]
    Name  = var.vpcTags["Name"]
  }
}


# Creating Subnet
resource "aws_subnet" "subnetTerraform" {
  vpc_id     = aws_vpc.terraformVPC.id
  cidr_block = var.Subnet_cidrBlock
  availability_zone = var.availabilityZone
  map_public_ip_on_launch = var.mapPublicIpOnLaunch

  tags = {
    Name = var.subnetTags["Name"]
    ENV  = var.subnetTags["ENV"]
    Auther = var.subnetTags["Auther"]
  }
}


# Creating Internet Gateway
resource "aws_internet_gateway" "terraformGTW" {
  vpc_id = aws_vpc.terraformVPC.id

  tags = {
    Name = var.internetGatewayTags["Name"]
    Auther = var.internetGatewayTags["Auther"]
    ENV = var.internetGatewayTags["ENV"]
  }
}


# Creating Route Table
resource "aws_route_table" "terraformRT" {
  vpc_id = aws_vpc.terraformVPC.id

  tags = {
    Name = var.routeTableTags["Name"]
    Auther = var.routeTableTags["Auther"]
    ENV = var.routeTableTags["ENV"]
  }
}


# Creating Routes for above Route Table
resource "aws_route" "terraformRoute" {
  route_table_id            = aws_route_table.terraformRT.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.terraformGTW.id
}


# Associatiting the Route Table to the Subnet that created above
resource "aws_route_table_association" "terraformRTAssociation" {
  subnet_id      = aws_subnet.subnetTerraform.id
  route_table_id = aws_route_table.terraformRT.id
}


# Creating Security Group that Allow All Inbound and Outbound Traffic
resource "aws_security_group" "allowALL" {
  name        = "AllowALL"
  description = "Allow ALL Inbound Traffic"
  vpc_id      = aws_vpc.terraformVPC.id

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = var.securityGroupsTags["Name"]
    Auther = var.securityGroupsTags["Auther"]
    ENV = var.securityGroupsTags["ENV"]
  }
}


# Create a EC2 Instance
resource "aws_instance" "terraformInstance" {
  ami           = var.awsAmiId
  instance_type = var.awsInstanceTpye
  key_name      = aws_key_pair.keyPair.key_name
  availability_zone = var.availabilityZone
  security_groups = [aws_security_group.allowALL.id]
  subnet_id     = aws_subnet.subnetTerraform.id
# associate_public_ip_address = "true"

  timeouts {
    create = "2m"
    delete = "2m"
  }

  tags = {
    ENV = var.instanceTags["ENV"]
    Auther = var.instanceTags["Auther"]
    Name = var.instanceTags["Name"]
  }
}


# Printing Public IP of Instance
output "instancePublicIP" {
  value = aws_instance.terraformInstance.public_ip
}
