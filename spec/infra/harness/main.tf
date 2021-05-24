data "terraform_remote_state" "prerequisites" {
  backend = "local"

  config = {
    path = "${path.module}/../../../../state/prerequisites.tfstate"
  }
}

module "cross_account_role" {
  # This makes absolutely no sense. I think there's a bug in terraform.
  source = "./../../../../../../../"

  role_name = var.role_name
  policy_arn = var.policy_arn
  assumable_by_account_ids = var.assumable_by_account_ids
}
