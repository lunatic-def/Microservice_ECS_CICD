locals {
  bookingapp-home = "home"
  bookingapp-movie = "movie"
  bookingapp-movie2 = "movie2"
  bookingapp-redis = "redis"
}

data "template_file" "bookingapp-home" {
  template = file("${path.module}/tasks/bookingapp-home.json")

  vars = {
    service_ecs_container_name     = local.bookingapp-home
    service_image                  = "339712838104.dkr.ecr.us-east-1.amazonaws.com/bookingapp-home:latest"
    service_ecstask_log_group_name = aws_cloudwatch_log_group.service_bookingapp-home_log_group.name
    service_region_name            = var.aws_region
    appmesh_virtual_node_name        = "mesh/${aws_appmesh_mesh.bookingapp-mess.name}/virtualNode/${aws_appmesh_virtual_node.bookingapp-home.name}"
  }
}

data "template_file" "bookingapp-movie" {
  template = file("${path.module}/tasks/bookingapp-movie.json")

  vars = {
    service_ecs_container_name     = local.bookingapp-movie
    service_image                  = "339712838104.dkr.ecr.us-east-1.amazonaws.com/bookingapp-movie:latest"
    service_ecstask_log_group_name = aws_cloudwatch_log_group.service_bookingapp-movie_log_group.name
    service_region_name            = var.aws_region
    appmesh_virtual_node_name        = "mesh/${aws_appmesh_mesh.bookingapp-mess.name}/virtualNode/${aws_appmesh_virtual_node.bookingapp-movie.name}"
  }
}

data "template_file" "bookingapp-movie2" {
  template = file("${path.module}/tasks/bookingapp-movie.json")

  vars = {
    service_ecs_container_name     = local.bookingapp-movie2
    service_image                  = "339712838104.dkr.ecr.us-east-1.amazonaws.com/bookingapp-movie2:latest"
    service_ecstask_log_group_name = aws_cloudwatch_log_group.service_bookingapp-movie2_log_group.name
    service_region_name            = var.aws_region
    appmesh_virtual_node_name        = "mesh/${aws_appmesh_mesh.bookingapp-mess.name}/virtualNode/${aws_appmesh_virtual_node.bookingapp-movie2.name}"
  }
}


data "template_file" "bookingapp-redis" {
  template = file("${path.module}/tasks/bookingapp-redis.json")

  vars = {
    service_ecs_container_name     = local.bookingapp-redis
    service_image                  = "339712838104.dkr.ecr.us-east-1.amazonaws.com/redis-alpine:latest"
    service_ecstask_log_group_name = aws_cloudwatch_log_group.service_bookingapp-redis_log_group.name
    service_region_name            = var.aws_region
    appmesh_virtual_node_name        = "mesh/${aws_appmesh_mesh.bookingapp-mess.name}/virtualNode/${aws_appmesh_virtual_node.bookingapp-redis.name}"
  }
}

