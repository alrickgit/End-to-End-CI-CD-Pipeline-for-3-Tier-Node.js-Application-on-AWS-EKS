resource "aws_key_pair" "my-key" {
  key_name = "test-key"
  public_key = file("demo-key.pub")
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_security_group" "primary-sg" {
  name = "primary-sg"
  description = "Common security group"
  vpc_id = aws_default_vpc.default.id
}


resource "aws_vpc_security_group_ingress_rule" "allow_HTTP" {
  security_group_id = aws_security_group.primary-sg.id
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_SSH" {
  security_group_id = aws_security_group.primary-sg.id
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}

resource "aws_vpc_security_group_ingress_rule" "common_range" {
  security_group_id = aws_security_group.primary-sg.id
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 3000
  ip_protocol = "tcp"
  to_port     = 9000
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.primary-sg.id
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.primary-sg.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_instance" "jenkins-instance" {
    ami = "ami-0f918f7e67a3323f0"
    instance_type = "t2.medium"
    key_name = aws_key_pair.my-key.key_name
    vpc_security_group_ids = [aws_security_group.primary-sg.id]
    availability_zone = "ap-south-1a"
    user_data = file("jenkins_installer.sh")
    depends_on = [ aws_key_pair.my-key, aws_security_group.primary-sg ]

    tags = {
    Name = "Jenkins"
  }
}

resource "aws_instance" "sonar-instance" {
    ami = "ami-0f918f7e67a3323f0"
    instance_type = "t2.medium"
    key_name = aws_key_pair.my-key.key_name
    vpc_security_group_ids = [aws_security_group.primary-sg.id]
    availability_zone = "ap-south-1a"
    user_data = file("sonarqube_installer.sh")
    depends_on = [ aws_key_pair.my-key, aws_security_group.primary-sg ]

    tags = {
    Name = "SonarQube"
  }
}
