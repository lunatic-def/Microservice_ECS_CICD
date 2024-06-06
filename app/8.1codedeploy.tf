resource "aws_codedeploy_app" "this" {
  compute_platform = "ECS"
  name             = "service-codedeploy"
}
#https://github.com/gnokoheat/ecs-with-codepipeline-example-by-terraform/blob/master/code-deploy.tf

resource "aws_codedeploy_deployment_group" "this" {
  app_name               = "${aws_codedeploy_app.this.name}"
  deployment_group_name  = "service-codedeploy-group"
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  service_role_arn       = "${aws_iam_role.codedeploy.arn}"

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 60
    }
  }

  ecs_service {
    cluster_name = "${module.ecs_cluster.cluster_name}"
    service_name = "${module.bookingapp-home.name}"
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

#   load_balancer_info {
#     target_group_pair_info {
#       prod_traffic_route {
#         listener_arns = ["${aws_lb_listener.this.arn}"]
#       }

#       target_group {
#         name = "${aws_lb_target_group.this.*.name[0]}"
#       }

#       target_group {
#         name = "${aws_lb_target_group.this.*.name[1]}"
#       }
#     }
#   }
}