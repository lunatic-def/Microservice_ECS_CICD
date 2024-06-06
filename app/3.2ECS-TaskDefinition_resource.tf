
################################################################################
# Standalone Task Definition (w/o Service)
################################################################################

# -> aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin id.dkr.ecr.us-east-1.amazonaws.com 
# -> build docker image an upload to repo
# -> docker build -t id.dkr.ecr.us-east-1.amazonaws.com/nginxapp1_ecr:1.0.0 .
# -> docker push id.dkr.ecr.us-east-1.amazonaws.com/nginxapp1_ecr:latest
# id.dkr.ecr.us-east-1.amazonaws.com/nginxapp1_ecr:latest

resource "aws_iam_role" "ecs_task_role" {
  name = "ecs_task_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = ["ecs-tasks.amazonaws.com"]
        }
      },
    ]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/CloudWatchFullAccess",
    "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"
  ]
}


#### TASK EXECUTION ROLE ####

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs_task_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = ["ecs-tasks.amazonaws.com"]
        }
      }
    ]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/CloudWatchFullAccess",
    "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"
  ]
}

resource "aws_iam_policy" "ecs-full" {
  policy = file("${path.module}/tasks/ecsfullaccess.json")
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecs-full.arn
}

resource "aws_iam_role_policy_attachment" "test-attach2" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.ecs-full.arn
}
#### END OF TASK EXECUTION ROLE ####


resource "aws_ecs_task_definition" "bookingapp-home" {
  depends_on               = [module.vpc]
  family                   = "bookingapp-home"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512 #0.5vCPU
  memory                   = 1024 #1Gb
  #ARN of the task execution role that the Amazon ECS container agent and the Docker daemon can assume.
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  proxy_configuration {
    type           = "APPMESH"
    container_name = "envoy"
    properties = {
      AppPorts = 5000
      EgressIgnoredIPs = "169.254.170.2,169.254.169.254"
      IgnoredUID       = "1337"
      ProxyEgressPort  = 15001
      ProxyIngressPort = 15000
    }
  }
//////////////////////// CONTAINER DEFINITION ////////////////////////
  container_definitions = data.template_file.bookingapp-home.rendered

}

#===========================================================================================
resource "aws_ecs_task_definition" "bookingapp-movie" {
  family                   = "bookingapp-movie"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512 #0.5vCPU
  memory                   = 1024 #1Gb

  #ARN of the task execution role that the Amazon ECS container agent and the Docker daemon can assume.
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  proxy_configuration {
    type           = "APPMESH"
    container_name = "envoy"
    properties = {
      AppPorts = 5000
      EgressIgnoredIPs = "169.254.170.2,169.254.169.254"
      IgnoredUID       = "1337"
      ProxyEgressPort  = 15001
      ProxyIngressPort = 15000
    }
  }

//////////////////////// CONTAINER DEFINITION ////////////////////////
  container_definitions = data.template_file.bookingapp-movie.rendered

}
#===========================================================================================
resource "aws_ecs_task_definition" "bookingapp-movie2" {
  family                   = "bookingapp-movie2"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512 #0.5vCPU
  memory                   = 1024 #1Gb

  #ARN of the task execution role that the Amazon ECS container agent and the Docker daemon can assume.
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  proxy_configuration {
    type           = "APPMESH"
    container_name = "envoy"
    properties = {
      AppPorts = 5000
      EgressIgnoredIPs = "169.254.170.2,169.254.169.254"
      IgnoredUID       = "1337"
      ProxyEgressPort  = 15001
      ProxyIngressPort = 15000
    }
  }

//////////////////////// CONTAINER DEFINITION ////////////////////////
  container_definitions = data.template_file.bookingapp-movie2.rendered
}
# #===========================================================================================
resource "aws_ecs_task_definition" "bookingapp-redis" {
  family                   = "bookingapp-redis"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512 #0.5vCPU
  memory                   = 1024 #1Gb


  #ARN of the task execution role that the Amazon ECS container agent and the Docker daemon can assume.
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  proxy_configuration {
    type           = "APPMESH"
    container_name = "envoy"
    properties = {
      AppPorts = 6379
      EgressIgnoredIPs = "169.254.170.2,169.254.169.254"
      IgnoredUID       = "1337"
      ProxyEgressPort  = 15001
      ProxyIngressPort = 15000
    }
  }

//////////////////////// CONTAINER DEFINITION ////////////////////////
  container_definitions = data.template_file.bookingapp-redis.rendered

}
