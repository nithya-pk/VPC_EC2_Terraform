# EC2 instance in public subnet2
resource "aws_instance" "webserver" {
 ami = "${var.ami_ver}"
 instance_type = "${var.ec2_type}"
 subnet_id = aws_subnet.public_subnets[1].id
 vpc_security_group_ids = [aws_security_group.allow_ssh_tcp.id]
 key_name = var.ssh_key_pair
 user_data = "${file("install_wp.sh")}"
 associate_public_ip_address = true
 depends_on = [aws_db_instance.rds_db, aws_subnet.public_subnets[1], aws_subnet.public_subnets[0]]
 tags = {Name = "webserver"}
}  