# Subnet group consisting of private subnets for RDS
resource "aws_db_subnet_group" "rds_subnet_grp" {
 name = "rds_subnet_grp"
 subnet_ids = ["${aws_subnet.private_subnets[0].id}", "${aws_subnet.private_subnets[1].id}"]
 tags = {Name = "rds_subnet_grp"}
}

# Subnet group consisting of private subnets for RDS
resource "aws_db_instance" "rds_db" {
 allocated_storage = 20
 storage_type = "gp2"
 engine  = "mysql"
 engine_version = "5.7"
 instance_class = "db.t3.micro"
 db_name = "rds_db"
 username = "${var.dbuser}"
 password = "${var.dbpassword}"
 parameter_group_name = "default.mysql5.7"
 db_subnet_group_name = "${aws_db_subnet_group.rds_subnet_grp.name}"
 vpc_security_group_ids = ["${aws_security_group.rds_sg.id}"]
 allow_major_version_upgrade = true
 auto_minor_version_upgrade = true
 multi_az = true
 skip_final_snapshot = true
 tags = {Name = "rds_db"}
}

