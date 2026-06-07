# NT548 - Lab 2

Hạ tầng của Lab 1 được sử dụng lại gồm:

- VPC
- public subnet và private subnet
- Internet Gateway và NAT Gateway
- public route table và private route table
- security group cho public EC2 và private EC2
- public EC2 và private EC2

## Câu 1

Terraform được chia thành các module:

```text
terraform/modules/vpc
terraform/modules/nat_gateway
terraform/modules/security_groups
terraform/modules/ec2
```

Workflow `.github/workflows/terraform.yml` gồm:

```text
terraform fmt
terraform init
terraform validate
checkov
terraform plan
terraform apply
terraform destroy
```

`apply` và `destroy` chỉ chạy bằng `workflow_dispatch`. Terraform state được
lưu trong S3 backend.

Workflow được kích hoạt khi:

- Có pull request thay đổi thư mục `terraform/` hoặc file workflow.
- Có push vào nhánh `main` thay đổi các file trên.
- Chạy thủ công bằng `workflow_dispatch`.

Pull request chỉ chạy kiểm tra. Push vào `main` chạy kiểm tra và plan. Khi chạy
thủ công có thể chọn `plan`, `apply` hoặc `destroy`.

Kết quả được lưu trong GitHub Actions Artifacts trong 7 ngày:

- `checkov-report`: báo cáo Checkov dạng JSON.
- `terraform-plan`: kết quả plan dạng text.
- `terraform-outputs`: output sau khi apply.

Phần cuối của plan và output cũng được ghi vào Job Summary.

GitHub environment `aws-dev` cần các secret:

```text
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_REGION
TF_STATE_BUCKET
MY_IP
SSH_PUBLIC_KEY
```

## Câu 2

`cloudformation/infrastructure.yaml` triển khai lại hạ tầng của Lab 1 bằng
CloudFormation.

`cloudformation/pipeline.yaml` tạo:

- CodeCommit repository
- CodeBuild project
- CodePipeline
- S3 artifact bucket
- IAM role cho CodeBuild, CodePipeline và CloudFormation

`buildspec.yml` cài và chạy `cfn-lint`, Taskcat. Cấu hình test của Taskcat nằm
trong `.taskcat.yml`.

Luồng pipeline:

```text
CodeCommit -> CodeBuild -> CloudFormation
```

CodeBuild kiểm tra template bằng `cfn-lint`, sau đó Taskcat tạo stack kiểm thử.
Khi bước kiểm tra thành công, CodePipeline triển khai
`cloudformation/infrastructure.yaml`.

## Xóa tài nguyên

Hạ tầng Terraform được xóa bằng action `destroy` trong GitHub Actions.

Hạ tầng CloudFormation và pipeline được quản lý bởi hai stack:

```text
nt548-lab2-infrastructure
nt548-lab2-pipeline
```

S3 artifact bucket có `DeletionPolicy: Retain` và cần được xóa sau khi pipeline
stack đã bị xóa.
