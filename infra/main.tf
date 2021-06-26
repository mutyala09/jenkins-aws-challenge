provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

variable "ingressrules" {
  type    = list(number)
  default = [80, 443, 22, 8080]
}

# private key
resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# aws keypair
resource "aws_key_pair" "key_pair" {
  depends_on = [tls_private_key.private_key]
  key_name   = var.key_name
  public_key = tls_private_key.private_key.public_key_openssh
}

variable "key_name" {
  default = "ec2-instance-key"
}

resource "aws_security_group" "web_traffic" {
  name        = "Allow web traffic"
  description = "Allow ssh and standard http/https ports inbound and everything outbound"

  dynamic "ingress" {
    iterator = port
    for_each = var.ingressrules
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Terraform" = "true"
  }
}

resource "aws_instance" "jenkins" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = "t2.small"
  security_groups = [aws_security_group.web_traffic.name]
  key_name        = var.key_name

  provisioner "remote-exec" {
    inline = [
      "wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -",
      "echo deb http://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list",
      "sudo apt update -qq",
      "sudo apt install -y default-jre",
      "sudo apt install -y jenkins",
      "sudo systemctl start jenkins",
      "sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 8080",
      "sudo sh -c \"iptables-save > /etc/iptables.rules\"",
      "echo iptables-persistent iptables-persistent/autosave_v4 boolean true | sudo debconf-set-selections",
      "echo iptables-persistent iptables-persistent/autosave_v6 boolean true | sudo debconf-set-selections",
      "sudo apt-get -y install iptables-persistent",
      "sudo ufw allow 8080",
      "sudo apt install -y apt-transport-https ca-certificates curl software-properties-common",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
      "sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable\"",
      "sudo apt update",
      "sudo apt install -y docker-ce",
      "sudo usermod -aG docker ubuntu",
      "sudo usermod -aG docker jenkins",
      "newgrp docker"
    ]
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = tls_private_key.private_key.private_key_pem
  }

  tags = {
    "Name"      = "Jenkins_Server"
    "Terraform" = "true"
  }
}

resource "aws_instance" "webapp" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.web_traffic.name]
  key_name        = var.key_name

  user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install software-properties-common apt-transport-https ca-certificates curl -y
                sudo add-apt-repository ppa:deadsnakes/ppa
                sudo apt update -y
                sudo apt install python3.8 -y
                curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
                sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
                sudo apt update -y
                sudo apt install docker-ce -y
                sudo usermod -aG docker ubuntu
                newgrp docker
                sudo curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
                sudo chmod +x /usr/local/bin/docker-compose
                cd /home/ubuntu
                git clone https://github.com/mutyala09/jenkins-aws-challenge.git helloapp
                sudo chown -R ubuntu:ubuntu helloapp
                cd helloapp
                docker-compose -p cicd up -d --build
                EOF

  tags = {
    "Name"      = "Webapp_Server"
    "Terraform" = "true"
  }
}

output "ssh_private_key" {
  value = "${tls_private_key.private_key.private_key_pem}"
}

output "jenkins_ip_address" {
  value = "${aws_instance.jenkins.public_ip}"
}

output "webapp_ip_address" {
  value = "${aws_instance.webapp.public_ip}"
}
