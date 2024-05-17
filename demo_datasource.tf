data "aws_vpc" "existing-vpc" {
    id = "vpc-03d475c0c78eb70f6"
  
}
data "aws_subnet" "existing-subnet" {
    id = "subnet-0d2f8456d76ba239a"
  
}
data "aws_ami" "linuxami" {
  most_recent = true
  owners = [ "amazon" ]

  filter {
    name   = "name"
    values = [ "amzn2-ami-hvm-*-gp2"] 
  }

  filter {
    name   = "root-device-type"
    values = [ "ebs" ]
  }

  filter {
    name   = "virtualization-type"
    values = [ "hvm" ]
  }
  filter {
    name   = "architecture"
    values = [ "x86_64" ]
  }

}
resource "aws_security_group" "datasupportsg" {
    name = "datasupportsg"
    vpc_id = data.aws_vpc.existing-vpc.id
    ingress {
        description = "Allow tls from vpc"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
  
    }
    egress {
        description = "Alltraffic"
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
      
}
resource "aws_instance" "datasource-ec2" {
    ami = data.aws_ami.linuxami.id
    instance_type = "t2.micro"
    key_name = "NVirginia32"
    subnet_id = data.aws_subnet.existing-subnet.id
    vpc_security_group_ids = [ aws_security_group.datasupportsg.id ]
    tags = {
      Name="datasource-ec2"
    }
  
}