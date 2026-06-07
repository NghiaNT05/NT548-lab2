# NT548 - Bài Tập Thực Hành 01

Triển khai hạ tầng AWS bằng **Terraform** và **CloudFormation**.

## Kiến trúc

```
Internet
    │
    ▼
Internet Gateway
    │
    ▼
Public Subnet (10.0.1.0/24)
    ├── Public EC2 (Bastion Host) ─── Public EC2 SG (SSH từ MY_IP)
    └── NAT Gateway ─── Elastic IP
            │
            ▼
    Private Subnet (10.0.11.0/24)
        └── Private EC2 ─── Private EC2 SG (SSH từ Public EC2 SG)
```

## Cấu trúc thư mục

```
NT548-Lab01/
├── terraform/
│   ├── modules/
│   │   ├── vpc/            # VPC, Subnets, IGW, Route Tables
│   │   ├── nat_gateway/    # NAT Gateway + Elastic IP
│   │   ├── security_groups/ # Public & Private EC2 SGs
│   │   └── ec2/            # EC2 Instances + Key Pair
│   └── environments/
│       └── dev/            # Root module gọi các module con
└── cloudformation/
    └── infrastructure.yaml # Template tương đương
```

## Yêu cầu

- [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 1.5.0
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) đã cấu hình credentials
- SSH key pair (`~/.ssh/id_rsa` + `~/.ssh/id_rsa.pub`)

## Chạy với Terraform

### 1. Chuẩn bị

```bash
# Cấu hình AWS credentials
aws configure

# Tạo SSH key nếu chưa có
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa

# Lấy IP hiện tại của bạn
curl https://checkip.amazonaws.com
```

### 2. Cập nhật terraform.tfvars

```bash
cd terraform/environments/dev
# Mở terraform.tfvars và thay YOUR_IP bằng IP thực của bạn
```

### 3. Deploy

```bash
cd terraform/environments/dev

terraform init
terraform plan
terraform apply
```

### 4. Kết nối SSH

```bash
# SSH vào Public EC2 (Bastion)
ssh -i ~/.ssh/id_rsa ec2-user@<PUBLIC_EC2_IP>

# Từ Bastion, SSH vào Private EC2
ssh -i ~/.ssh/id_rsa ec2-user@<PRIVATE_EC2_IP>
```

### 5. Dọn dẹp

```bash
terraform destroy
```

## Chạy với CloudFormation

### 1. Tạo Key Pair trên AWS Console

Truy cập **EC2 → Key Pairs → Create key pair**, tạo key tên `nt548-lab01-key`.

### 2. Deploy stack

```bash
aws cloudformation deploy \
  --template-file cloudformation/infrastructure.yaml \
  --stack-name nt548-lab01 \
  --parameter-overrides \
    ProjectName=nt548-lab01 \
    MyIp=$(curl -s https://checkip.amazonaws.com)/32 \
    KeyPairName=nt548-lab01-key \
  --capabilities CAPABILITY_IAM \
  --region ap-southeast-1
```

### 3. Xem outputs

```bash
aws cloudformation describe-stacks \
  --stack-name nt548-lab01 \
  --query "Stacks[0].Outputs" \
  --region ap-southeast-1
```

### 4. Dọn dẹp

```bash
aws cloudformation delete-stack --stack-name nt548-lab01 --region ap-southeast-1
```

## Test Cases

| Test | Lệnh | Kết quả mong đợi |
|------|------|-----------------|
| SSH vào Public EC2 từ MY_IP | `ssh ec2-user@<PUBLIC_IP>` | Thành công |
| SSH vào Public EC2 từ IP khác | (dùng IP khác) | Bị từ chối (timeout) |
| SSH vào Private EC2 từ Bastion | `ssh ec2-user@<PRIVATE_IP>` | Thành công |
| Private EC2 ping google.com | `ping google.com` (từ Private EC2) | Thành công (qua NAT GW) |
| SSH trực tiếp vào Private EC2 từ Internet | `ssh ec2-user@<PRIVATE_IP>` | Không có public IP, không kết nối được |
