# 3tier-aws-tf

![1](https://github.com/Vairavmoorthy/3tier-aws-tf/blob/2012a9dc2ab0abd67069a9dd625a20add374a7a2/aws-3ttf.png)

## Prerequisites:
Basic knowledge of AWS & Terraform
AWS account
AWS Access & Secret Key

**Step 1:- Create a file for the VPC**
Create a new directory.
Inside the directory, create a file named network.tf and write a code for create vpc, sunbnet,IGW,Route table,Route table association.

# Provider
provider "aws" {
  region = var.region
}
# Defining VPC
resource "aws_vpc" "cloudvpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "3tvpc"
  }
}
# Defining Subnet for instance
resource "aws_subnet" "publicsubnet" {
    vpc_id = aws_vpc.cloudvpc.id
    cidr_block = var.subnet_cidr
    availability_zone = var.availability_zone
    tags = {
      Name = "instance_subnet1"
    }
}
# Defining Subnet for instance 2
resource "aws_subnet" "publicsubnet2" {
     vpc_id = aws_vpc.cloudvpc.id
    cidr_block = var.subnet1_cidr
    availability_zone = var.availability_zone2
    tags = {
      Name = "instance_subnet2"
    }
}
# Defining Subnet for Applications
resource "aws_subnet" "applicationsubnet" {
   vpc_id = aws_vpc.cloudvpc.id
  cidr_block = var.subnet2_cidr
  availability_zone = var.availability_zone2
  tags = {
      Name = "Application_subnet1"
    }
}
resource "aws_subnet" "applicationsubnet2" {
   vpc_id = aws_vpc.cloudvpc.id
  cidr_block = var.subnet3_cidr
  availability_zone = var.availability_zone
  tags = {
      Name = "Application_subnet2"  
       }
}
# Defining Subnet for databases
resource "aws_subnet" "database_subnet" {
     vpc_id = aws_vpc.cloudvpc.id
    cidr_block = var.subnet4_cidr
    availability_zone = var.availability_zone2
    tags = {
      Name = "Database_subnet2"  
       }
}
# Defining Subnet for databases
resource "aws_subnet" "database_subnet2" {
     vpc_id = aws_vpc.cloudvpc.id
    cidr_block = var.subnet5_cidr
    availability_zone = var.availability_zone
    tags = {
      Name = "Database_subnet2"   
       }
}
# Defining subnet groups
resource "aws_db_subnet_group" "db_subnets" {
  subnet_ids = [aws_subnet.database_subnet.id,aws_subnet.database_subnet2.id]
  tags = {
    Name = "db_subnet_group"
  }
}
# Defining IGW
resource "aws_internet_gateway" "awsigt" {
   vpc_id = aws_vpc.cloudvpc.id
}
# Defining Route table
resource "aws_route_table" "Public_rt" {
  vpc_id = aws_vpc.cloudvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.awsigt.id
  }
}
# Defing routetable association 
resource "aws_route_table_association" "rt1" {
  subnet_id = aws_subnet.publicsubnet.id
  route_table_id = aws_route_table.Public_rt.id
}
# Defing routetable association 
resource "aws_route_table_association" "rt2" {
  subnet_id = aws_subnet.publicsubnet2.id
  route_table_id = aws_route_table.Public_rt.id
}

**Step 2:- Create a file for the Security**


# Defining security group for  appsec
resource "aws_security_group" "appsec" {
  vpc_id = aws_vpc.cloudvpc.id
   # Inbound rules
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress  {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    # Outbound rules
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "Web_sec"
    }
}
# Defining security group for db
resource "aws_security_group" "db_sec" {
    vpc_id = aws_vpc.cloudvpc.id
  # Inbound rules
  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp""Please remember that I have declared the variables separately; please refer to var.tf."
    security_groups = [aws_security_group.appsec.id]
  }
  # Outbound rules
  egress {
    from_port = 0
    to_port = 0
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "db_sec"
  }
}
**Step 3:- Create a file for RDS**

resource "aws_db_instance" "masterdb" {
  engine                = "mysql"
  allocated_storage     = 10
  engine_version        = "8.0.31"
  storage_type          = "gp2"
  identifier            = "vmdb"
  username              = "admin"
  password              = "adelaide64"
  instance_class        = "db.t2.micro"
  multi_az              = false
  db_subnet_group_name  = aws_db_subnet_group.db_subnets.id
  vpc_security_group_ids = [aws_security_group.db_sec.id]
  deletion_protection   = false
  publicly_accessible   = false
  backup_retention_period = 7

  skip_final_snapshot  = true  # Set to false to create a final snapshot
  #final_snapshot_identifier = "masterdb-final-snapshot"  # Unique name for the final snapshot

  tags = {
    Environment = "free tier"
  }
}

resource "aws_db_instance" "replica-masterdb" {
  instance_class       = "db.t3.micro"
  backup_retention_period = 7

  #skip_final_snapshot  = false # Set to false to create a final snapshot
  #final_snapshot_identifier = "replica-masterdb-final-snapshot"  # Unique name for the final snapshot
  replicate_source_db = aws_db_instance.masterdb.identifier
}

**Step 4:- Create a file for Insance**

resource "aws_instance" "ubuntu_20" {
    ami = "ami-08e5424edfe926b43"
    instance_type = "t2.micro"
    key_name= "vm"
    vpc_security_group_ids = [aws_security_group.appsec.id]
    subnet_id = aws_subnet.publicsubnet.id
    associate_public_ip_address = true
    user_data = file("wp.sh")
  tags = {
    Name = "access_point1"
  }
}
resource "aws_instance" "ubuntu_20a" {
    ami = "ami-08e5424edfe926b43"
    instance_type = "t2.micro"
    key_name= "vm"
    vpc_security_group_ids = [aws_security_group.appsec.id]
    subnet_id = aws_subnet.publicsubnet.id
    associate_public_ip_address = true
    user_data = file("wp.sh")
  tags = {
    Name = "access_point2"
  }
}
**Step 5:- Create a file for Insance**
I have created a data file to install the WordPress application.
resource "aws_instance" "ubuntu_20" {
    ami = "ami-08e5424edfe926b43"
    instance_type = "t2.micro"
    key_name= "vm"
    vpc_security_group_ids = [aws_security_group.appsec.id]
    subnet_id = aws_subnet.publicsubnet.id
    associate_public_ip_address = true
    user_data = file("wp.sh")
  tags = {
    Name = "access_point1"
  }
}
resource "aws_instance" "ubuntu_20a" {
    ami = "ami-08e5424edfe926b43"
    instance_type = "t2.micro"
    key_name= "vm"
    vpc_security_group_ids = [aws_security_group.appsec.id]
    subnet_id = aws_subnet.publicsubnet.id
    associate_public_ip_address = true
    user_data = file("wp.sh")
  tags = {
    Name = "access_point2"
  }
}

**Step 6:- Create a file for Load Balancer**
resource "aws_lb" "ext-alb" {
  name               = "External-Lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.appsec.id]
  subnets            = [aws_subnet.publicsubnet.id, aws_subnet.publicsubnet2.id]
}

resource "aws_lb_target_group" "elb-target" {
  name     = "ALB-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.cloudvpc.id
}

resource "aws_lb_target_group_attachment" "attached" {
  target_group_arn = aws_lb_target_group.elb-target.arn
  target_id        = aws_instance.ubuntu_20.id
  port             = 80
  depends_on       = [aws_instance.ubuntu_20]
}

resource "aws_lb_target_group_attachment" "attached1" {
  target_group_arn = aws_lb_target_group.elb-target.arn
  target_id        = aws_instance.ubuntu_20a.id
  port             = 80
  depends_on       = [aws_instance.ubuntu_20a]
}

resource "aws_lb_listener" "ext-elb" {
  load_balancer_arn = aws_lb.ext-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.elb-target.arn
  }
}

**Step 7:- Create a file for Output**
output "lb_dns_name" {
  value = aws_lb.ext-alb.dns_name
}

output "aws_instance_ubuntu_20" {
  value = aws_instance.ubuntu_20.public_ip
}

output "aws_instance_ubuntu_20_1" {
  value = aws_instance.ubuntu_20a.public_ip
}

**Step 7:- Create a Jenkinsfile for CI/CD setup**

pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/Vairavmoorthy/3tier-aws-tf.git'
            }
        }

        stage('Build Infrastructure') {
            steps {
                withAWS(credentials: '113') {
                     sh 'terraform init'
                   // sh 'terraform plan -out=tfplan'
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Create Infrastructure') {
            steps {
                sh 'echo "Creating jenkins Instance"'
                
            }
        }
    }
}


**"Please remember that I have declared the variables separately; please refer to var.tf."**
