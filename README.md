# 🚀 Terraform on AWS – State Management and Remote Backend

This repository contains the code and instructions for a hands-on session on using **Terraform with AWS**, **managing Terraform state**, and configuring a **remote backend using S3 (and optional DynamoDB)**.



## 🧭 Session Overview

**Topics Covered:**
- Terraform with AWS: Real-world usage
- Terraform state management: What, why, and how
- Remote backend with AWS S3
- Hands-on Lab: Deploying an EC2 instance with remote state



## 📦 Prerequisites

Before beginning, ensure you have:

- An AWS account with access to EC2, S3
- [Terraform installed](https://developer.hashicorp.com/terraform/downloads)
- [AWS CLI installed and configured](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)

---

# 🌐 Terraform with AWS – Real-World Usage

Terraform is widely used with **Amazon Web Services (AWS)** to automate infrastructure provisioning in a safe, predictable, and repeatable way. By defining your infrastructure as code (IaC), you can version-control your entire AWS environment, enforce consistency across deployments, and simplify collaboration among teams.

![Terraform with AWS](./assets/aws-infra-diagram.JPG)

## 🧱 Why Use Terraform with AWS?

| Feature | Why It Matters |
|--------|----------------|
| **Infrastructure as Code (IaC)** | Version-controlled AWS infrastructure using `.tf` files |
| **Reusable Modules** | Build and share reusable infrastructure blueprints (e.g., for EC2, VPCs) |
| **Automation** | Deploy repeatable environments across dev, staging, and prod |
| **Multi-Region/Multi-Account Support** | Manage all AWS regions and accounts from a single config |
| **Safe Changes** | Terraform plans and applies updates predictably (idempotency) |
| **Team Collaboration** | Use remote state for safe, collaborative work across teams |


## 🛠️ What Can You Manage on AWS with Terraform?

These are some commonly used AWS services you’ll encounter in practice:

- **EC2 Instances** – Virtual machines for running applications  
- **VPC (Virtual Private Cloud)** – Private network setup (subnets, routing, NAT, etc.)  
- **S3 Buckets** – Scalable object storage (including for remote Terraform state)  
- **IAM** – Permissions, roles, and secure access controls  
- **RDS** – Managed relational databases  
- **Lambda** – Serverless functions  
- **ECS/EKS** – Container management at scale  

## 💼 Example Use Cases

| Use Case | How Terraform Helps |
|----------|---------------------|
| **Environment Reusability** | Deploy identical dev/staging/prod with one config and different variable files |
| **CI/CD Pipelines** | Terraform can be triggered from GitHub Actions, GitLab CI, Jenkins, etc. |
| **Secure Access Control** | Manage IAM users/roles consistently and track changes over time |
| **Cost Optimization** | Schedule non-prod EC2 stop/start using tagging and Lambda |
| **Infrastructure Auditing** | Maintain audit logs and track who changed what via version control and remote state |


## 🚀 Getting Started with AWS Provider

To allow Terraform to interact with your AWS account, you need two things:

1. The `aws` provider block
2. Authentication credentials so Terraform can access your account


### 🔧 Step 1: Create `provider.tf`

Although Terraform lets you define the provider block in **any `.tf` file**, it's ideal to keep it in a dedicated file like `provider.tf` for better organization.

```hcl
# provider.tf

provider "aws" {
  region = "us-east-1"
}
---

# 🧾 Terraform State Management

Terraform state is a critical component of any Terraform workflow. It keeps track of the infrastructure Terraform manages and ensures that your configuration files align with real-world resources.


## 🔍 What is Terraform State?

- A **JSON file** (typically named `terraform.tfstate`) that maps your configuration to real infrastructure.
- Contains metadata such as:
  - Resource IDs
  - Attributes of provisioned infrastructure
  - Dependency relationships between resources


## 📁 Where Is the State Stored?

By default, Terraform stores the state **locally** in the directory where you run `terraform apply`.

However, for team collaboration and production environments, it's best practice to use a **remote backend**, like AWS S3, Azure Blob Storage, or HashiCorp Terraform Cloud.


## 🧠 Why Do We Need State?

- **Mapping Resources**: Maps configuration (`main.tf`) to real-world infrastructure.
- **Dependency Management**: Ensures correct order of operations (create/destroy).
- **State Locking**: Prevents concurrent updates from multiple users.
- **Performance**: Speeds up planning by caching resource data.


## ⚠️ Problems with Local State

| Issue               | Description |
|---------------------|-------------|
| No Collaboration    | Hard to share with teammates |
| Risk of Loss        | If deleted or corrupted, can lead to broken infrastructure |
| No Versioning       | Can't roll back to previous states easily |
| No Locking          | Multiple people may apply changes simultaneously |

## 🔐 Best Practices for Managing Terraform State

To ensure your Terraform state remains secure, reliable, and maintainable, follow these best practices:

| Practice                 | Description |
|--------------------------|-------------|
| **Use Remote Backends**  | Always store state remotely (e.g., AWS S3, Azure Blob, Terraform Cloud) in team or production environments. |
| **Enable Encryption**    | When using S3, set `encrypt = true` to encrypt the state file at rest. |
| **Use State Locking**    | Use DynamoDB (for S3), or equivalent services, to prevent concurrent writes and avoid conflicts. |
| **Backup Regularly**     | Schedule regular backups of your state file to protect against accidental deletion or corruption. |
| **Enable Versioning**    | If using S3, enable versioning to recover from accidental overwrites or deletions. |
| **Restrict IAM Access**  | Limit who can read/write to the state backend using IAM policies or access controls. |
| **Avoid Manual Editing** | Never edit `.tfstate` manually unless absolutely necessary and under expert supervision. |
| **Use Workspaces Sparingly** | Prefer separate configurations or modules instead of overusing Terraform workspaces for environment separation. |
| **Monitor and Audit**    | Enable logging and monitoring (e.g., AWS CloudTrail + S3 data events) to track access and changes to the state file. |
| **Separate Environments**| Use different state files or backends for dev/staging/prod environments to avoid cross-environment drift. |

---

## ☁️ Remote State: Using AWS S3 Backend

Storing state remotely improves reliability, security, and team collaboration.

### ✅ Benefits of Remote State (S3)
- Shared access across teams
- Encryption at rest (`encrypt = true`)
- Optional locking via DynamoDB
- Version control (if enabled on the bucket)

### 🛠️ Sample Configuration

```hcl
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "project1/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
  }
}
```


