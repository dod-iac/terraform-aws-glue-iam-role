## Usage

Creates an IAM Role for use as a Glue service role that can read from any bucket and use any KMS key.

```hcl
module "glue_iam_role" {
  source = "dod-iac/glue-iam-role/aws"

  name = "glue-iam-role"
  buckets = ["*"]
  keys = ["*"]
  tags = {
    Automation  = "Terraform"
  }
}
```

Creates an IAM Role for use as a Glue service role that can read from a specific bucket and use any KMS key.

```hcl

module "glue_iam_role" {
  source = "dod-iac/glue-iam-role/aws"

  name = format("app-%s-glue-%s", var.application, var.environment)
  buckets = [aws_s3_bucket.main.arn]
  keys = ["*"]
  tags = {
    Application = var.application
    environment = var.environment
    Automation  = "Terraform"
  }
}
```

## Terraform Version

Terraform 0.13. Pin module version to ~> 1.0.0 . Submit pull-requests to master branch.

Terraform 0.11 and 0.12 are not supported.

## License

This project constitutes a work of the United States Government and is not subject to domestic copyright protection under 17 USC § 105.  However, because the project utilizes code licensed from contributors and other third parties, it therefore is licensed under the MIT License.  See LICENSE file for more information.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| aws | >= 2.55.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.55.0 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [aws_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) |
| [aws_iam_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) |
| [aws_iam_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) |
| [aws_iam_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) |
| [aws_partition](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| assume\_role\_policy | The assume role policy for the AWS IAM role.  If blank, allows EC2 instances in the account to assume the role. | `string` | `""` | no |
| buckets | The ARNs of the AWS S3 buckets the role is allowed to read from.  Use ["*"] to allow all buckets. | `list(string)` | `[]` | no |
| description | The description of the AWS IAM role. | `string` | `""` | no |
| keys | The ARNs of the AWS KMS keys the role is allowed to use to decrypt files.  Use ["*"] to allow all keys. | `list(string)` | `[]` | no |
| name | The name of the AWS IAM role. | `string` | n/a | yes |
| policy\_description | The description of the AWS IAM policy. Defaults to "The policy for [NAME]". | `string` | `""` | no |
| policy\_name | The name of the AWS IAM policy.  Defaults to "[NAME]-policy". | `string` | `""` | no |
| tags | Tags applied to the AWS IAM role. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | The Amazon Resource Name (ARN) of the AWS IAM Role. |
| name | The name of the AWS IAM Role. |
