# Terraform AWS IAM Baseline

This project provides a secure and scalable baseline for managing AWS Identity and Access Management (IAM) using Terraform. It leverages public Terraform modules to configure account-wide settings, create users, and manage group memberships in a data-driven way.

The configuration is designed to be modular and environment-aware, supporting separate configurations for development and production environments.

## Features

- **Account Security**: Sets a custom AWS account alias and a strong, configurable password policy.
- **Data-Driven User Management**: Creates and manages multiple IAM users by defining them as data in a `.tfvars` file.
- **Group-Based Permissions**: Automatically creates administrators and developers groups.
- **Automated Group Assignment**: Assigns users to the appropriate group based on their configuration.
- **Multi-Environment Support**: Manages distinct configurations for dev and prod environments from a single codebase.

## Project Structure

```
iam-project/
├── environments/
│   ├── dev.tfvars
│   └── prod.tfvars
├── main.tf
├── variables.tf
├── versions.tf
└── outputs.tf
```

- **main.tf**: The core logic that calls the modules to build the infrastructure.
- **variables.tf**: Defines all the inputs and configurable options for the project.
- **versions.tf**: Locks the required versions for Terraform and AWS provider.
- **outputs.tf**: Declares the outputs to be displayed after deployment.
- **environments/**: Contains the specific variable values for each environment.

## Prerequisites

Before you begin, ensure you have the following:

1. **Terraform**: Version 1.0.0 or later.
2. **AWS Account**: An AWS account with administrative access.
3. **AWS Credentials**: Your AWS credentials must be configured in a way that Terraform can use them (e.g., via environment variables `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`, or an `~/.aws/credentials` file).
4. **PGP Key**: A PGP key is required to encrypt the initial IAM user passwords. You can use a service like [Keybase.io](https://keybase.io) to get one easily.

## How to Use

### Step 1: Configure Your Environment

The primary configuration happens in the `.tfvars` files inside the `environments/` directory.

1. Open `environments/dev.tfvars` or `environments/prod.tfvars`.
2. Update the `iam_user_pgp_key`: This is the only mandatory change. Set it to your PGP key ID or your `keybase:username`.
3. Manage Users: Add, remove, or modify users and their group assignments in the `users` map:

```hcl
users = {
  "new_user_key" = {
    name  = "new.user.name"
    group = "developers" # or "admins"
  }
}
```

### Step 2: Initialize Terraform

Navigate to the root of the `iam-project/` directory in your terminal and run this command once. This will download the necessary providers and modules.

```bash
terraform init
```

### Step 3: Plan and Apply

Use the `-var-file` flag to specify which environment you want to deploy.

**To deploy the development environment:**

```bash
# See what changes Terraform will make
terraform plan -var-file="environments/dev.tfvars"

# Apply the changes
terraform apply -var-file="environments/dev.tfvars"
```

**To deploy the production environment:**

```bash
# See what changes Terraform will make
terraform plan -var-file="environments/prod.tfvars"

# Apply the changes
terraform apply -var-file="environments/prod.tfvars"
```

Terraform will prompt for confirmation before making any changes. Type `yes` to proceed.

## Inputs (Variables)

The following variables are defined in `variables.tf` and can be customized in your `.tfvars` files.

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `aws_region` | The AWS region to create resources in. | string | `us-east-1` |
| `account_alias` | The alias for the AWS account. | string | `cyber-security-project` |
| `users` | A map of user objects to create and assign to groups. | map(object) | `{}` |
| `iam_user_pgp_key` | The PGP key used to encrypt initial user passwords. | string | (required) |
| `admin_group_name` | The name of the IAM group for administrators. | string | `administrators` |
| `developer_group_name` | The name of the IAM group for developers. | string | `developers` |
| `developer_group_policies` | A map of IAM policies to attach to the developer group. | map(string) | `{ PowerUserAccess = ... }` |
| `minimum_password_length` | Minimum length to require for user passwords. | number | `14` |
| `max_password_age` | The number of days that a password is valid. | number | `90` |

## Outputs

After a successful apply, the following outputs will be displayed:

| Name | Description |
|------|-------------|
| `account_alias_url` | The generated sign-in URL for the AWS account. |
| `admin_group_name` | The name of the created administrators group. |
| `developer_group_name` | The name of the created developers group. |
| `created_users` | A map of the created users and their encrypted initial passwords. |
