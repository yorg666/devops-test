output "microk8s-public-ip" {
  value = aws_instance.microk8s.public_ip
}

