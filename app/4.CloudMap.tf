resource "aws_service_discovery_private_dns_namespace" "local_sd_dns" {
  name        = "internal-bookingapp.com"
  description = "microservices ' private service discovery "
  vpc         = module.vpc.vpc_id
}

resource "aws_service_discovery_service" "bookingapp-home" {
  name = "home"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.local_sd_dns.id

    dns_records {
      ttl  = 60
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 2
  }

}


resource "aws_service_discovery_service" "bookingapp-movie" {
  name = "movie"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.local_sd_dns.id

    dns_records {
      ttl  = 60
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 2
  }
}

resource "aws_service_discovery_service" "bookingapp-movie2" {
  name = "movie2"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.local_sd_dns.id

    dns_records {
      ttl  = 60
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 2
  }
}

resource "aws_service_discovery_service" "bookingapp-redis" {
  name = "redis"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.local_sd_dns.id

    dns_records {
      ttl  = 60
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 2
  }
}