
# This file declares the information we want to display after our infrastructure is created.

output "account_alias_url" {
  description = "The sign-in URL for the AWS account."
  # We can make this dynamic by referencing the variable from variables.tf
  value       = "https://${var.account_alias}.signin.aws.amazon.com/console"
}

output "admin_group_name" {
  description = "The name of the administrators group."
  value       = module.admins_group.iam_group_name
}

output "developer_group_name" {
  description = "The name of the developers group."
  value       = module.developers_group.iam_group_name
}

# --- REPLACED with this single, looping output ---
output "created_users" {
  description = "A map of the users that were created and their encrypted passwords."
  sensitive   = true # Mark as sensitive because it contains passwords

  # This 'for' loop iterates over the map of users created by the iam_user module.
  value = {
    for key, user in module.iam_user : user.iam_user_name => {
      "encrypted_password" = user.iam_user_login_password_encrypted
    }
  }
}

