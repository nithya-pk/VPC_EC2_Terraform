# VPC named "NK_VPC" with CIDR mentioned in tfvars file
resource "aws_vpc" "NK_VPC" {
 cidr_block = var.NK_VPC_cidr
 instance_tenancy = "default"
 tags = {Name = "NK_VPC"}
}

# Internet Gateway and attach it to NK_VPC
resource "aws_internet_gateway" "IGW" {
 vpc_id =  aws_vpc.NK_VPC.id
 tags = {Name = "NK_VPC_IGW"}
}

# public subnets with CIDRs mentioned in vars file
resource "aws_subnet" "public_subnets" {
 count = length(var.public_subnets)
 vpc_id =  aws_vpc.NK_VPC.id
 cidr_block = element(var.public_subnets, count.index)
 availability_zone = element(var.az, count.index)
 tags = {Name = "NK_VPC_PubSub${count.index + 1}"}
}

# private subnets with CIDRs mentioned in vars file
resource "aws_subnet" "private_subnets" {
 count = length(var.private_subnets)
 vpc_id =  aws_vpc.NK_VPC.id
 cidr_block = element(var.private_subnets, count.index)
 availability_zone = element(var.az, count.index)
 tags = {Name = "NK_VPC_PriSub${count.index + 1}"}
}

# Assign EIP for NAT gateway
resource "aws_eip" "nat_gateway" {
 vpc = true
 tags = {Name = "NK_VPC_NAT_EIP"}
}

 # NAT gateway with publicsubnets and elastic IP
resource "aws_nat_gateway" "NATgw" {
 allocation_id = aws_eip.nat_gateway.id
 subnet_id = aws_subnet.public_subnets[1].id
 tags = {Name = "NK_VPC_NATgw"}
}

# Route table for publicsubnets. Traffic from public subnets reaches internet via IGW
resource "aws_route_table" "PublicRT" {
 vpc_id =  aws_vpc.NK_VPC.id
  route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.IGW.id
  }
 tags = {Name = "NK_VPC_PublicRT"} 
}

# Route table for privatesubnets. Traffic from private subnets reaches internet via NAT
resource "aws_route_table" "PrivateRT" {
 vpc_id = aws_vpc.NK_VPC.id
  route {
   cidr_block = "0.0.0.0/0"
   nat_gateway_id = aws_nat_gateway.NATgw.id
  }
 tags = {Name = "NK_VPC_PrivateRT"} 
}

# Route table association with publicsubnets
resource "aws_route_table_association" "PublicRTassociation" {
 count = length(var.public_subnets)
 subnet_id = element(aws_subnet.public_subnets[*].id, count.index)
 route_table_id = aws_route_table.PublicRT.id
}

# Route table association with privatesubnets
resource "aws_route_table_association" "PrivateRTassociation" {
 count = length(var.private_subnets)
 subnet_id = element(aws_subnet.private_subnets[*].id, count.index)
 route_table_id = aws_route_table.PrivateRT.id
}
 