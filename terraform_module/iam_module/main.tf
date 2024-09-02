provider "aws" {
  region = "ap-southeast-2"
}

locals {
  users = {
    "user1" = {
      username = "jerome"
      groups   = ["group1", "group2"]
    },
    "user2" = {
      username = "marc"
      groups   = ["group2", "group3"]
    }
  }
}

# Create IAM groups
resource "aws_iam_group" "this" {
  for_each = toset(flatten([for user in local.users : user.groups]))

  name = each.value
}

# Create IAM users
resource "aws_iam_user" "this" {
  for_each = local.users

  name = each.value.username
}

# Attach users to their groups
resource "aws_iam_user_group_membership" "this" {
  for_each = {
    for user_key, user_value in local.users : user_key => user_value
  }

  user = aws_iam_user.this[each.key].name
  groups = [
    for group in each.value.groups : aws_iam_group.this[group].name
  ]
}
