# Call the IAM Users and Groups Module
module "iam_users_groups" {
  source = "/Users/benrobertbrowning/Desktop/terraform/iam_module" # Path to the module directory
}

# Output the created IAM groups
output "iam_groups" {
  value = module.iam_users_groups.iam_groups
}

# Output the created IAM users
output "iam_users" {
value = module.iam_users_groups.iam_users
}
