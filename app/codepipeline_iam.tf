

# data "aws_iam_policy_document" "assume_codepipeline" {
#   statement {
#     effect = "Allow"

#     principals {
#       type        = "Service"
#       identifiers = ["codepipeline.amazonaws.com"]
#     }

#     actions = ["sts:AssumeRole"]
#   }
# }

# resource "aws_iam_role" "codepipeline_role" {
#   name               = "test-role"
#   assume_role_policy = data.aws_iam_policy_document.assume_codepipeline.json
# }

# data "aws_iam_policy_document" "codepipeline_policy" {
#   statement {
#     effect = "Allow"

#     actions = [
#         "codepipeline:*",
#         "cloudformation:DescribeStacks",
#         "cloudformation:ListStacks",
#         "cloudformation:ListChangeSets",
#         "cloudtrail:DescribeTrails",
#         "codebuild:BatchGetProjects",
#         "codebuild:CreateProject",
#         "codebuild:ListCuratedEnvironmentImages",
#         "codebuild:ListProjects",
#         "codecommit:ListBranches",
#         "codecommit:GetReferences",
#         "codecommit:ListRepositories",
#         "codedeploy:BatchGetDeploymentGroups",
#         "codedeploy:ListApplications",
#         "codedeploy:ListDeploymentGroups",
#         "ec2:DescribeSecurityGroups",
#         "ec2:DescribeSubnets",
#         "ec2:DescribeVpcs",
#         "ecr:DescribeRepositories",
#         "ecr:ListImages",
#         "ecs:ListClusters",
#         "ecs:ListServices",
#         "iam:ListRoles",
#         "iam:GetRole",
#         "lambda:ListFunctions",
#         "events:ListRules",
#         "events:ListTargetsByRule",
#         "events:DescribeRule",
#         "opsworks:DescribeApps",
#         "opsworks:DescribeLayers",
#         "opsworks:DescribeStacks",
#         "s3:ListAllMyBuckets",
#         "sns:ListTopics",
#     ]

#     resources = [
#       aws_s3_bucket.codepipeline_bucket.arn,
#       "${aws_s3_bucket.codepipeline_bucket.arn}/*"
#     ]
#   }

#   statement {
#     effect    = "Allow"
#     actions   = ["codestar-connections:UseConnection"]
#     resources = [aws_codestarconnections_connection.example.arn]
#   }

#   statement {
#     effect = "Allow"

#     actions = [
#       "codebuild:BatchGetBuilds",
#       "codebuild:StartBuild",
#     ]

#     resources = ["*"]
#   }
# }

# resource "aws_iam_role_policy" "codepipeline_policy" {
#   name   = "codepipeline_policy"
#   role   = aws_iam_role.codepipeline_role.id
#   policy = data.aws_iam_policy_document.codepipeline_policy.json
# }
