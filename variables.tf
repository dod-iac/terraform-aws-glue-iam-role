variable "assume_role_policy" {
  type        = string
  description = "The assume role policy for the AWS IAM role.  If blank, allows EC2 instances in the account to assume the role."
  default     = ""
}

variable "buckets" {
  type        = list(string)
  description = "The ARNs of the AWS S3 buckets the role is allowed to read from.  Use [\"*\"] to allow all buckets."
  default     = []
}

variable "description" {
  type        = string
  description = "The description of the AWS IAM role."
  default     = ""
}

variable "keys" {
  type        = list(string)
  description = "The ARNs of the AWS KMS keys the role is allowed to use to decrypt files.  Use [\"*\"] to allow all keys."
  default     = []
}

variable "policy_description" {
  type        = string
  description = "The description of the AWS IAM policy. Defaults to \"The policy for [NAME]\"."
  default     = ""
}

variable "policy_name" {
  type        = string
  description = "The name of the AWS IAM policy.  Defaults to \"[NAME]-policy\"."
  default     = ""
}

variable "name" {
  type        = string
  description = "The name of the AWS IAM role."
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to the AWS IAM role."
  default     = {}
}
