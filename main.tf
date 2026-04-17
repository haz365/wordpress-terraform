terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_security_group" "wordpress" {
  name        = "wordpress-sg"
  description = "Allow HTTP and SSH"

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
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "wordpress-sg"
  }
}

resource "aws_instance" "wordpress" {
  ami                    = "ami-0c7217cdde317cfec"
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.wordpress.id]

  user_data = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y apache2 php php-mysql mysql-server wget
    systemctl start apache2
    systemctl enable apache2
    systemctl start mysql
    systemctl enable mysql
    mysql -e "CREATE DATABASE ${var.db_name};"
    mysql -e "CREATE USER '${var.db_user}'@'localhost' IDENTIFIED BY '${var.db_password}';"
    mysql -e "GRANT ALL PRIVILEGES ON ${var.db_name}.* TO '${var.db_user}'@'localhost';"
    mysql -e "FLUSH PRIVILEGES;"
    cd /var/www/html
    wget https://wordpress.org/latest.tar.gz
    tar -xzf latest.tar.gz
    cp -r wordpress/* .
    rm -rf wordpress latest.tar.gz
    cp wp-config-sample.php wp-config.php
    sed -i "s/database_name_here/${var.db_name}/" wp-config.php
    sed -i "s/username_here/${var.db_user}/" wp-config.php
    sed -i "s/password_here/${var.db_password}/" wp-config.php
    chown -R www-data:www-data /var/www/html
    chmod -R 755 /var/www/html
    systemctl restart apache2
  EOF

  tags = {
    Name = "wordpress-server"
  }
}