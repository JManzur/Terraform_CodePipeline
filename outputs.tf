output "TERRAFORM_APPLY_ROLE_NAME" {
    value = "${var.terrraform_apply_role}"
}

output "CODEBUILD_ROLE_ARN" {
    value = aws_iam_role.codebuild_role.arn
}