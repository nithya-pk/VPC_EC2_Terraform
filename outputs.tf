output "VPCName" {
 value = aws_vpc.NK_VPC.id
 description = "Name of the VPC"
}

output "EC2Instance" {
 value = aws_instance.webserver.id
 description = "Name of Webserver"
}

output "WebServerIP" {
 value = aws_instance.webserver.public_ip
 description = "Web Server IP Address"
}

output "rds_address" {
 value = aws_db_instance.rds_db.address
 description = "RDS DB Address"
}

output "rds_dbname" {
  value = var.dbname
  description = "RDS DB Name"
}

output "rds_endpoint" {
 value = aws_db_instance.rds_db.endpoint
 description = "RDS DB Endpoint"
}
