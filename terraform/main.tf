# Configure AWS Provider
provider "aws" {
  region = "eu-west-1"  # Ireland
}

# Get the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Create EC2 Instance
resource "aws_instance" "flask_app" {
  ami           = data.aws_ami.amazon_linux.id  # Auto-updating AMI
  instance_type = "t2.micro"                    # Free tier eligible
  key_name      = "flask-key"                   # Existing SSH key pair

  # Security group allows HTTP/SSH
  vpc_security_group_ids = [aws_security_group.flask_sg.id]

  # User data script to install and run Flask
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install python3 git -y
              pip3 install flask gunicorn
              git clone https://github.com/prishita-code/zurich-demo.git /var/www/flask-app
              cd /var/www/flask-app
              nohup python3 flask-app.py --host=0.0.0.0 --port=80 &
              EOF

  tags = {
    Name = "flask-app-server"
  }
}

# Security Group for Flask App
resource "aws_security_group" "flask_sg" {
  name        = "flask-app-sg"
  description = "Allow HTTP and SSH traffic"

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Restrict to your IP in production!
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Output the Public IP
output "public_ip" {
  description = "Public IP address of the Flask server"
  value       = aws_instance.flask_app.public_ip
}

output "app_url" {
  description = "Flask application URL"
  value       = "http://${aws_instance.flask_app.public_ip}"
}