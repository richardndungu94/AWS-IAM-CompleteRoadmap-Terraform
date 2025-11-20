# This file provides the specific values for our development environment.

  iam-project/environments/dev.tfvars
     
    aws_region               = "us-east-1"
     account_alias            = "cyber-security-dev"
     admin_group_name         = "administrators-dev"
     developer_group_name     = "developers-dev"
     iam_user_pgp_key         = "keybase:richardndungu94"
     
    
    
    # --- This map now drives the entire user and group configuration ---
    users = {
      "richard" = {
        name  = "richard.ndungu.dev"
       group = "admins"
      },
      "jane" = {
        name  = "jane.doe.dev"
       group = "developers"
      },
      "sanjay" = {
        name  = "sanjay.patel.dev"
      group = "developers"
      }
    }

iam_user_pgp_key = "keybase:richardndungu94"



