/**
 * ## Usage
 *
 * Creates an IAM Role for use as a Glue service role that can read from any bucket and use any KMS key.
 *
 * ```hcl
 * module "glue_iam_role" {
 *   source = "dod-iac/glue-iam-role/aws"
 *
 *   name = "glue-iam-role"
 *   buckets = ["*"]
 *   keys = ["*"]
 *   tags = {
 *     Automation  = "Terraform"
 *   }
 * }
 * ```
 *
 * Creates an IAM Role for use as a Glue service role that can read from a specific bucket and use any KMS key.
 *
 * ```hcl
 *
 * module "glue_iam_role" {
 *   source = "dod-iac/glue-iam-role/aws"
 *
 *   name = format("app-%s-glue-%s", var.application, var.environment)
 *   buckets = [aws_s3_bucket.main.arn]
 *   keys = ["*"]
 *   tags = {
 *     Application = var.application
 *     environment = var.environment
 *     Automation  = "Terraform"
 *   }
 * }
 * ```
 *
 * ## Terraform Version
 *
 * Terraform 0.13. Pin module version to ~> 1.0.0 . Submit pull-requests to master branch.
 *
 * Terraform 0.11 and 0.12 are not supported.
 *
 * ## License
 *
 * This project constitutes a work of the United States Government and is not subject to domestic copyright protection under 17 USC § 105.  However, because the project utilizes code licensed from contributors and other third parties, it therefore is licensed under the MIT License.  See LICENSE file for more information.
 */

data "aws_partition" "current" {}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = [
        "glue.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "main" {
  name               = var.name
  description        = var.description
  assume_role_policy = length(var.assume_role_policy) > 0 ? var.assume_role_policy : data.aws_iam_policy_document.assume_role_policy.json
  tags               = var.tags
}

resource "aws_iam_role_policy_attachment" "aws_glue_service_role" {
  role       = aws_iam_role.main.name
  policy_arn = format("arn:%s:iam::aws:policy/service-role/AWSGlueServiceRole", data.aws_partition.current.partition)
}

data "aws_iam_policy_document" "main" {

  statement {
    sid = "ListBucket"
    actions = [
      "s3:GetBucketLocation",
      "s3:GetBucketRequestPayment",
      "s3:GetEncryptionConfiguration",
      "s3:ListBucket",
    ]
    effect    = length(var.buckets) > 0 ? "Allow" : "Deny"
    resources = length(var.buckets) > 0 ? var.buckets : ["*"]
  }

  statement {
    sid = "GetObject"
    actions = [
      "s3:GetObject",
    ]
    effect    = length(var.buckets) > 0 ? "Allow" : "Deny"
    resources = length(var.buckets) > 0 ? formatlist("%s/*", var.buckets) : ["*"]
  }

  statement {
    sid = "Decrypt"
    actions = [
      "kms:Decrypt",
    ]
    effect    = length(var.keys) > 0 ? "Allow" : "Deny"
    resources = length(var.keys) > 0 ? var.keys : ["*"]
  }

}

resource "aws_iam_policy" "main" {
  name        = length(var.policy_name) > 0 ? var.policy_name : format("%s-policy", var.name)
  description = length(var.policy_description) > 0 ? var.policy_description : format("The policy for %s.", var.name)
  policy      = data.aws_iam_policy_document.main.json
}

resource "aws_iam_role_policy_attachment" "main" {
  role       = aws_iam_role.main.name
  policy_arn = aws_iam_policy.main.arn
}
