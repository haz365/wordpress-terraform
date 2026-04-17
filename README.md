# WordPress on AWS with Terraform

A fully automated WordPress deployment on AWS using Terraform. The entire infrastructure is provisioned with a single `terraform apply` command — no manual clicking in the AWS console.

---

## Overview

Terraform provisions an EC2 instance on AWS with a security group allowing HTTP and SSH traffic. A user data script runs automatically on first boot — installing Apache, PHP, MySQL and WordPress, configuring the database, and starting the web server. The result is a fully working WordPress site accessible via a public IP address.

---

## Stack

- **Terraform** — infrastructure as code
- **AWS EC2** — virtual server (t3.micro)
- **AWS Security Groups** — firewall rules
- **Ubuntu 22.04** — operating system
- **Apache** — web server
- **PHP** — WordPress runtime
- **MySQL** — database
- **WordPress** — CMS

---

## Files

| File | Description |
|---|---|
| `main.tf` | AWS provider, security group and EC2 instance |
| `variables.tf` | All configurable input variables |
| `outputs.tf` | Prints instance IP and WordPress URL after deploy |

---

## How to deploy

**Prerequisites:**
- Terraform installed
- AWS CLI configured with `aws configure`
- An AWS key pair created in your target region

**Deploy:**
```bash
terraform init
terraform plan
terraform apply
```

After apply completes, Terraform prints your WordPress URL:

wordpress_url = "http://your-ip-address"

Wait 3-5 minutes for the user data script to finish installing WordPress, then visit the URL.

**Destroy when done:**
```bash
terraform destroy
```

---

## What Terraform creates

**Security Group** — firewall rules:
- Port 80 (HTTP) — open to the world so anyone can visit the site
- Port 22 (SSH) — open for server access
- All outbound traffic — allowed so the server can download WordPress

**EC2 Instance** — the server:
- AMI: Ubuntu 22.04 LTS
- Instance type: t3.micro
- User data script runs on first boot to install everything automatically

---

## How the user data script works

When the EC2 instance first starts, AWS runs the user data bash script automatically:

1. Updates the package manager
2. Installs Apache, PHP, MySQL and wget
3. Starts and enables Apache and MySQL services
4. Creates the WordPress database and user
5. Downloads the latest WordPress
6. Configures `wp-config.php` with database credentials
7. Sets correct file permissions
8. Restarts Apache

No manual SSH required — the server configures itself.

---

## Variables

| Variable | Description | Default |
|---|---|---|
| `region` | AWS region | `us-east-1` |
| `instance_type` | EC2 instance type | `t3.micro` |
| `key_name` | AWS key pair name | `wordpress-key` |
| `db_name` | WordPress database name | `wordpress` |
| `db_user` | Database username | `wpuser` |
| `db_password` | Database password | `wppassword123` |

---

## Important

- Never commit `.pem` key files or `terraform.tfstate` to Git
- Run `terraform destroy` when done to avoid AWS charges
- Change the default `db_password` before deploying to production