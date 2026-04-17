output "wordpress_url" {
  description = "WordPress public URL"
  value       = "http://${aws_instance.wordpress.public_ip}"
}

output "instance_ip" {
  description = "EC2 instance public IP"
  value       = aws_instance.wordpress.public_ip
}

output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.wordpress.id
}