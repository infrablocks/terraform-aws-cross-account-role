variable "region" {}

variable "role_name" {}
variable "policy_arn" {}
variable "assumable_by_account_ids" {
  type = list(string)
}
