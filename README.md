# CloudShop Infrastructure

AWS infrastructure as code using Terraform for a cloud-native e-commerce platform.

## Architecture

- **VPC** — Multi-AZ network with public and private subnets, NAT Gateway
- **EC2** — Bastion host with IAM role for S3 and CloudWatch access
- **EKS** — Managed Kubernetes cluster with auto-scaling node group
- **RDS** — PostgreSQL 16 on private subnets, not publicly accessible
- **S3** — Versioned and encrypted bucket for logs and artifacts
- **IAM** — Least privilege roles for each service

## Stack

| Tool | Version | Purpose |
|------|---------|---------|
| Terraform | 1.7.5 | Infrastructure as Code |
| AWS Provider | ~> 5.0 | AWS resources |
| PostgreSQL | 16 | Relational database |
| Kubernetes | 1.29 | Container orchestration |

## Remote State

State is stored remotely on S3 with DynamoDB locking:

- **Bucket:** `cloudshop-tfstate-roger`
- **Key:** `cloudshop/terraform.tfstate`
- **Lock table:** `cloudshop-tfstate-lock`

## Prerequisites

- AWS CLI configured (`aws configure`)
- Terraform >= 1.7.0
- kubectl
- eksctl

## Usage
```bash
# Clone the repository
git clone https://github.com/rogerspies/cloudshop-infra.git
cd cloudshop-infra

# Set sensitive variables
export TF_VAR_db_password="your-password"

# Initialize Terraform
terraform init

# Preview changes
terraform plan -out=tfplan

# Apply infrastructure
terraform apply tfplan

# Connect to EKS cluster
aws eks update-kubeconfig --name cloudshop-cluster --region us-east-2
kubectl get nodes
```

## Module Structure
```
cloudshop-infra/
├── main.tf              # Root module — wires all modules together
├── variables.tf         # Input variables
├── outputs.tf           # Output values
├── terraform.tfvars     # Variable values (not committed)
└── modules/
    ├── vpc/             # VPC, subnets, IGW, NAT, route tables
    ├── ec2/             # EC2 instance, security group, IAM role
    ├── eks/             # EKS cluster, node group, IAM roles
    ├── rds/             # RDS PostgreSQL, subnet group, security group
    └── s3/              # S3 bucket, versioning, encryption
```

## Security

- RDS is not publicly accessible — accessible only from EC2 security group
- S3 bucket blocks all public access
- S3 bucket encrypted with AES-256
- EC2 uses IAM role instead of access keys
- Sensitive outputs marked as `sensitive = true`
- `terraform.tfvars` excluded from version control

## Destroy
```bash
terraform destroy
```

> **Note:** Also manually delete the S3 state bucket and DynamoDB lock table after destroy, as they are managed outside Terraform.