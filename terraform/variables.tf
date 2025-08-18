variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "github_repo" {
  description = "GitHub repository URL (without 'https://')"
  type        = string
  default     = "prishita-code/zurich-demo"
}

variable "ssh_cidr_blocks" {
  description = "Allowed IPs for SSH access"
  type        = list(string)
  default     = ["0.0.0.0/0"]  # Restrict to your IP in production!
}