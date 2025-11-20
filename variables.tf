# This file defines every customizable input for our entire project, with sensible defaults.

# --- General Settings ---
variable "aws_region" {
  description = "The AWS region to create resources in."
  type        = string
  default     = "us-east-1"
}

variable "account_alias" {
  description = "The alias for the AWS account. Must be lowercase and contain no spaces."
  type        = string
  default     = "cyber-security-project"
}

# --- User Definitions ---
variable "users" {
  description = "A map of user objects to create, where the key is a unique identifier."
  type = map(object({
    name  = string
    group = string # The group they will be assigned to ('admins' or 'developers')
  }))
  default = {}
}

variable "iam_user_pgp_key" {
  description = "The PGP key to use for all new users to encrypt their password."
  type        = string
  # This has no default because it's unique to you. It must be in your .tfvars file.
}

# --- Group Definitions ---
variable "admin_group_name" {
  description = "The name of the IAM group for administrators."
  type        = string
  default     = "administrators"
}

# --- ADDED: Missing variable for the developer group name ---
variable "developer_group_name" {
  description = "The name of the IAM group for developers."
  type        = string
  default     = "developers"
}

# --- ADDED: Missing variable for the developer group policies ---
variable "developer_group_policies" {
  description = "A map of IAM policies to attach to the developer group."
  type        = map(string)
  default = {
    PowerUserAccess = "arn:aws:iam::aws:policy/PowerUserAccess"
  }
}

# --- Password Policy Settings ---
variable "minimum_password_length" {
  description = "Minimum length to require for user passwords."
  type        = number
  default     = 14
}

variable "max_password_age" {
  description = "The number of days that a password is valid. 0 = passwords do not expire."
  type        = number
  default     = 90
}

