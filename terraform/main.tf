provider "aws" {
  region = var.aws_region
}

# Fetch the latest Amazon Linux AMI based on the owner and filter
data "aws_ami" "amazon_linux_ami" {
  most_recent = true
  owners      = [var.owners]
  filter {
    name   = "name"
    values = [var.os_filter]
  }

  region = var.aws_region
}

# Security Group configuration
resource "aws_security_group" "ldap_sg" {
  name        = "main-security-group"
  description = "Allow LDAP, API, and SSH (for deployments)"
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Change later to GitHub Actions IPs
  }
  
  ingress {
    from_port   = 636
    to_port     = 636
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow LDAP connections
  }
  
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow API access
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 instance configuration
resource "aws_instance" "ldap_server" {
  ami             = data.aws_ami.amazon_linux_ami.id
  instance_type   = var.instance_type
  key_name        = var.key_name
  security_groups = [aws_security_group.ldap_sg.name]
  
  tags = {
    Name = "LDAPServer"
  }
  
  # Added lifecycle configuration to replace the instance
  lifecycle {
    create_before_destroy = true
  }

  user_data = <<-EOF
              #!/bin/bash
              # Just install system dependencies
              sudo yum update -y
              sudo yum install -y git
              curl -fsSL https://rpm.nodesource.com/setup_18.x | sudo bash -
              sudo yum install -y nodejs
              
              # Prepare the directory - will be populated by GitHub Actions
              if [ -d "/home/ec2-user/LDAPServer" ]; then
                sudo rm -rf /home/ec2-user/LDAPServer
              fi
              
              sudo mkdir -p /home/ec2-user/LDAPServer
              sudo chown -R ec2-user:ec2-user /home/ec2-user/LDAPServer
              EOF
}
