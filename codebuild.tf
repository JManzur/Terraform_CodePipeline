/*
Docker images provided by CodeBuild
Ref.: https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-available.html
*/

/* Build Spec files */
data "local_file" "terraform_validate" {
  filename = "${path.module}/buildspec/terraform_validate.yml"
}

data "local_file" "terraform_plan" {
  filename = "${path.module}/buildspec/terraform_plan.yml"
}

data "local_file" "terraform_apply" {
  filename = "${path.module}/buildspec/terraform_apply.yml"
}

/* Terraform Validate Project */
resource "aws_codebuild_project" "validate" {
  name         = "terraform-validate"
  description  = "Execute a Terraform Validate"
  service_role = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = var.compute_type
    image                       = "aws/codebuild/standard:5.0" #Ubuntu 20.04
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  source {
    buildspec = data.local_file.terraform_validate.content
    type      = "CODEPIPELINE"
  }

  tags = { Name = "${var.name-prefix}-validation-step" }
}

/* Terraform Plan Project */
resource "aws_codebuild_project" "plan" {
  name         = "terraform-plan"
  description  = "Execute a Terraform Plan"
  service_role = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = var.compute_type
    image                       = "aws/codebuild/standard:5.0" #Ubuntu 20.04
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  source {
    buildspec = data.local_file.terraform_validate.content
    type      = "CODEPIPELINE"
  }

  tags = { Name = "${var.name-prefix}-plan-step" }
}

/* Terraform Apply Project */
resource "aws_codebuild_project" "apply" {
  name         = "terraform-apply"
  description  = "Execute a Terraform Apply"
  service_role = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = var.compute_type
    image                       = "aws/codebuild/standard:5.0" #Ubuntu 20.04
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  source {
    buildspec = data.local_file.terraform_apply.content
    type      = "CODEPIPELINE"
  }

  tags = { Name = "${var.name-prefix}-apply-step" }
}