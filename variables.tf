variable "role_name" {
  default = "cross-account-role"
  type = string
  description = "The name to use for the cross account role."
}

variable "policy_arn" {
  default = "arn:aws:iam::aws:policy/ReadOnlyAccess"
  type = string
  description = "The ARN of the policy to attach to the created cross account role."
}

variable "assumable_by_account_ids" {
  type = list(string)
  description = "A list of account IDs for accounts that are allowed to assume this role."
}
