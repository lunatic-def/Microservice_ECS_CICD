
resource "random_string" "random" {
  length = 6
  special = false
  upper = false
} 
locals {
  bucket_name = "s3-bucket-${random_string.random.result}"
}

resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = local.bucket_name
  acl    = "private"
  force_destroy       = true
}

variable "repo_name" {
  description = "The name of the CodeCommit repository (e.g. new-repo)."
  default     = "bookingapp-home"
}

variable "repo_default_branch" {
  description = "The name of the default repository branch (default: master)"
  default     = "master"
}


resource "aws_codepipeline" "codepipeline" {
  name     = "tf-test-pipeline"
  role_arn = aws_iam_role.cicd_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        RepositoryName = "${aws_codecommit_repository.this.repository_name}"
        BranchName     = "${var.repo_default_branch}"
      }
    }
  }
  
  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = "${aws_codebuild_project.codebuild.name}"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      input_artifacts = ["build_output"]
      version         = "1"

      configuration = {
        ClusterName = "${module.ecs_cluster.name}"
        ServiceName = "${module.bookingapp-home.name}"
        FileName    = "imagedefinitions.json"
      }
    }
  }

}

#https://medium.com/@kay.renfa/aws-ecs-bluegreen-codepipeline-with-private-git-repository-9268a3a65da6
#https://www.youtube.com/watch?v=jEtP30tnh8g&t=2407s