resource "aws_codebuild_project" "codebuild" {
  name         = "test_codebuild"
  description  = "codebuild_project"
  service_role = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:3.0"
    type         = "LINUX_CONTAINER"
    privileged_mode = true # enable this flag if you want to build Docker images or your builds to get elevated prigileges
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec.yml"
  }
  
  logs_config {
    cloudwatch_logs {
      group_name  = aws_cloudwatch_log_group.codebuild-logs.name
      stream_name = aws_cloudwatch_log_stream.codebuild-stream.name
    } 
  }
}  

resource "aws_cloudwatch_log_group" "codebuild-logs" {
  name = "codebuild-logs"
}
resource "aws_cloudwatch_log_stream" "codebuild-stream" {
  name           = "codebuild-stream"
  log_group_name = aws_cloudwatch_log_group.yada.name
}