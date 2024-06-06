

variable "repo_name" {
  description = "The name of the CodeCommit repository (e.g. new-repo)."
  default     = "test"
}

variable "repo_default_branch" {
  description = "The name of the default repository branch (default: master)"
  default     = "master"
}


resource "aws_codepipeline" "codepipeline" {
  name     = "tf-test-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

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
      output_artifacts = ["source"]

      configuration = {
        RepositoryName = var.repo_name
        BranchName     = var.repo_default_branch
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
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["BuildArtifact"]
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
      provider        = "CodeDeployToECS"
      input_artifacts = ["BuildArtifact"]
      version         = "1"

      configuration = {
        ApplicationName = "service-deploy"
        DeploymentGroupName = "${aws_codedeploy_deployment_group.this.deployment_group_name}"
        TaskDefinitionTemplateArtifact = "BuildArtifact"
        TaskDefinitionTemplatePath = "imagedefinitions.json"
        # AppSpecTemplateArtifact = "BuildArtifact"
        # AppSpecTemplatePath = "buildspec.yml"
      }
    }
  }

}

#https://medium.com/@kay.renfa/aws-ecs-bluegreen-codepipeline-with-private-git-repository-9268a3a65da6
#https://www.youtube.com/watch?v=jEtP30tnh8g&t=2407s