resource "aws_iam_role" "cicd_role" {
  name = "codebuild_role"
  assume_role_policy = jsonencode({
   Version = "2012-10-17"
   Statement = [
    {
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = [
          "codebuild.amazonaws.com",
          "codedeploy.amazonaws.com",
          "codepipeline.amazonaws.com",
          "ecs-tasks.amazonaws.com"
        ]
      }
    }
   ]
 })
 managed_policy_arns = [
   "arn:aws:iam::aws:policy/AWSCodeCommitPowerUser",
   "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
 ]
}

data "aws_iam_policy_document" "this" {
  statement {
    effect = "Allow"

    actions = [
        "codebuild:*",
        "codecommit:*",
        "cloudwatch:*",
        "ec2:*",
        "ecr:*",
        "elasticfilesystem:DescribeFileSystems",
        "events:*",
        "logs:*",
        "s3:*",
        "ecs:*",
        "elasticloadbalancing:*",
        "lambda:InvokeFunction",
        "codedeploy:*",
        "codepipeline:*",
        "cloudformation:DescribeStacks",
        "cloudformation:ListStacks",
        "cloudformation:ListChangeSets",
        "cloudtrail:DescribeTrails",
        "iam:ListRoles",
        "iam:GetRole",
        "lambda:ListFunctions",
        "opsworks:DescribeApps",
        "opsworks:DescribeLayers",
        "opsworks:DescribeStacks",
        "sns:Publish",
        "sns:ListTopics",
    ]
    resources = ["*"]
  }

}

resource "aws_iam_role_policy" "example" {
  role   = aws_iam_role.cicd_role.name
  policy = data.aws_iam_policy_document.this.json
}
