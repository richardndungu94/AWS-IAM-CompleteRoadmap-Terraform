 #This file provides the values for our production environment.



aws_region           = "us-west-2"
account_alias        = "cyber-security-prod"
admin_group_name     = "administrators"
developer_group_name = "developers"

# This PGP key will be used for all users created in this environment.
iam_user_pgp_key = "keybase:richardndungu94"

# Defines all production users and their primary group assignments.
# The 'main.tf' file will use this map to create the users and
# automatically place them in the correct group.
users = {
  "richard_prod" = {
    name  = "richard.ndungu"
    group = "admins"
  },
  "auditor_prod" = {
    name  = "auditor.user"
    group = "developers" # As an example, we'll place the auditor in the developers group
  }
}

