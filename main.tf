# This is the "engine" of our project. It uses the variables to configure and call the public modules.

provider "aws" {
  region = var.aws_region
}

# --- IAM Account Alias and Password Policy ---
module "iam_account" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-account"
  version = "5.39.0"

  account_alias = var.account_alias

  minimum_password_length = var.minimum_password_length
  max_password_age        = var.max_password_age
}

# --- Create all IAM users by looping over the 'users' map ---
module "iam_user" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  version = "5.39.0"

  for_each = var.users

  name = each.value.name

  create_login_profile    = true
  password_reset_required = true
  pgp_key                 = var.iam_user_pgp_key

  tags = {
    "ManagedBy" = "Terraform",
    "User"      = each.key
  }
}

# --- Create the Administrators Group ---
module "admins_group" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group"
  version = "5.39.0"

  name  = var.admin_group_name
  users = [
    # Find all users in the map with group = "admins"
    for key, user in var.users : module.iam_user[key].iam_user_name if user.group == "admins"
  ]

  policies = {
    AdministratorAccess = "arn:aws:iam::aws:policy/AdministratorAccess"
  }

  tags = {
    "ManagedBy" = "Terraform"
  }
}

# --- Create the Developers Group ---
module "developers_group" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group"
  version = "5.39.0"

  name = var.developer_group_name
  users = [
    # Find all users in the map with group = "developers"
    for key, user in var.users : module.iam_user[key].iam_user_name if user.group == "developers"
  ]

  policies = var.developer_group_policies

  tags = {
    "ManagedBy" = "Terraform"
  }
}

# CORRECTED: The extra closing brace from the end of the file has been removed.

