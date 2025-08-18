output "public_ip" {
  description = "Public IP of the Flask server"
  value       = aws_instance.flask_app.public_ip
}

output "app_url" {
  description = "Flask application URL"
  value       = "http://${aws_instance.flask_app.public_ip}"
}

output "ssh_command" {
  description = "Command to SSH into the instance"
  value       = "ssh -i flask-key.pem ec2-user@${aws_instance.flask_app.public_ip}"
}