resource "aws_key_pair" "jenkins-ec2" {
  key_name   = "jenkins-ec2"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDXO+HPN1OV9poMyrVw/HbfvhVB7NzW2AqjFIws1wOsgd+kC2nYbmDsjtleQG6Hl98zPchJk5Vj6ENFzmVmZTBgReCxJECIML3G50y7pzGRT7HnrRPaQxVV7g4zGhYA2cBoQ7N/IahuELz0aQriVCVtKmHIVcE6FdNLPklMfwg/3FJdoh/SXEKrvHvFGsvdTHpfQVKSKiutDmJjIRZQXlQcEt9auhooUCMVuRTtVV7RMR5ESnapqi5q1M+jentk+xSkLnZ5XrXrSrnlaxcXXORTq8ogiHpAvusaZb7pENQGDtEIGbmsU7fF6CMdous7Bt3mBjnonU9mAULy25gIHJIP yorg@DESKTOP-QJUE2VM"
}

resource "aws_instance" "microk8s" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.xlarge"
  key_name = aws_key_pair.jenkins-ec2.key_name

//  provisioner "file" {
//    source      = "./bootstrap.sh"
//    destination = "/home/ubuntu/bootstrap.sh"
//  }

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = "24"
    volume_type = "gp2"
  }

  user_data = file("bootstrap.sh")

  tags = {
    Name = "Krystian Jenkins on microk8s"
  }

}
