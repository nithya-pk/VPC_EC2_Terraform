 # VPC named "NK_VPC" with CIDR mentioned in tfvars file
 resource "aws_vpc" "NK_VPC" {
   cidr_block       = var.NK_VPC_cidr
   instance_tenancy = "default"
   tags = {Name = "NK_VPC"}
 }

  # Internet Gateway and attach it to NK_VPC
  resource "aws_internet_gateway" "IGW" {
    vpc_id =  aws_vpc.NK_VPC.id
    tags = {Name = "NK_VPC_IGW"}

 }

# public subnet with CIDR mentioned in tfvars file
 resource "aws_subnet" "publicsubnets" {
   vpc_id =  aws_vpc.NK_VPC.id
   cidr_block = "${var.public_subnets}"
   tags = {Name = "NK_VPC_pubsub"}
 }

# private subnet with CIDR mentioned in tfvars file
 resource "aws_subnet" "privatesubnets" {
   vpc_id =  aws_vpc.NK_VPC.id
   cidr_block = "${var.private_subnets}"
   tags = {Name = "NK_VPC_privsub"}
 }

# Use elastic IP for NAT
 resource "aws_eip" "natIP" {
   vpc   = true
 }

 # NAT gateway with publicsubnets and elastic IP
 resource "aws_nat_gateway" "NATgw" {
   allocation_id = aws_eip.natIP.id
   subnet_id = aws_subnet.publicsubnets.id
   tags = {Name = "NK_VPC_NATgw"}
 }

# Route table for publicsubnets. Traffic from public subnet reaches internet via IGW
 resource "aws_route_table" "PublicRT" {
    vpc_id =  aws_vpc.NK_VPC.id
    route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
    }
    tags = {Name = "NK_VPC_PublicRT"} 
 }

 # Route table for privatesubnets. Traffic from private subnet reaches internet via NAT
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
    subnet_id = aws_subnet.publicsubnets.id
    route_table_id = aws_route_table.PublicRT.id
 }
 
 # Route table association with privatesubnets
 resource "aws_route_table_association" "PrivateRTassociation" {
    subnet_id = aws_subnet.privatesubnets.id
    route_table_id = aws_route_table.PrivateRT.id
 }

