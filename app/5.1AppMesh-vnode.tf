##############################
## HOME
##############################
resource "aws_appmesh_virtual_node" "bookingapp-home" {
  name      = "home-vnode"
  mesh_name = aws_appmesh_mesh.bookingapp-mess.id

  spec {
    listener {
      port_mapping {
        port     = 5000
        protocol = "http"
      }
      health_check {
        protocol            = "http"
        path                = "/healthcheck"
        healthy_threshold   = 2
        unhealthy_threshold = 2
        timeout_millis      = 2000
        interval_millis     = 5000
      }
    }

    backend {
      virtual_service {
        virtual_service_name = aws_appmesh_virtual_service.movie.name
      }
    }

    backend {
      virtual_service {
        virtual_service_name = aws_appmesh_virtual_service.redis.name
      }
    }

    service_discovery {
      aws_cloud_map {
        service_name   = aws_service_discovery_service.bookingapp-home.name
        namespace_name = aws_service_discovery_private_dns_namespace.local_sd_dns.name
      }
    }

    logging {
      access_log {
        file {
          path = "/dev/stdout"
        }
      }
    }
  }
}
##############################
## Movie
##############################
resource "aws_appmesh_virtual_node" "bookingapp-movie" {
  name      = "movie-vnode"
  mesh_name = aws_appmesh_mesh.bookingapp-mess.id

  spec {
    listener {
      port_mapping {
        port     = 5000
        protocol = "http"
      }
      health_check {
        protocol            = "http"
        path                = "/movie"
        healthy_threshold   = 2
        unhealthy_threshold = 2
        timeout_millis      = 2000
        interval_millis     = 5000
      }
    }

    service_discovery {
      aws_cloud_map {
        service_name   = aws_service_discovery_service.bookingapp-movie.name
        namespace_name = aws_service_discovery_private_dns_namespace.local_sd_dns.name
      }
    }

    backend {
      virtual_service {
        virtual_service_name = aws_appmesh_virtual_service.redis.name
      }
    }

    logging {
      access_log {
        file {
          path = "/dev/stdout"
        }
      }
    }
  }
}


# ##############################
# ## Movie 2
# ##############################
resource "aws_appmesh_virtual_node" "bookingapp-movie2" {
  name      = "movie2-vnode"
  mesh_name = aws_appmesh_mesh.bookingapp-mess.id

  spec {
    listener {
      port_mapping {
        port     = 5000
        protocol = "http"
      }
    }

    service_discovery {
      aws_cloud_map {
        service_name   = aws_service_discovery_service.bookingapp-movie2.name
        namespace_name = aws_service_discovery_private_dns_namespace.local_sd_dns.name
      }
    }

    backend {
      virtual_service {
        virtual_service_name = aws_appmesh_virtual_service.redis.name
      }
    }
  }
}

# ##############################
# ## Redis
# ##############################
resource "aws_appmesh_virtual_node" "bookingapp-redis" {
  name      = "redis-vnode"
  mesh_name = aws_appmesh_mesh.bookingapp-mess.id

  spec {
    listener {
      port_mapping {
        port     = 6379
        protocol = "tcp"
      }
    }

    service_discovery {
      aws_cloud_map {
        service_name   = "redis"
        namespace_name = aws_service_discovery_private_dns_namespace.local_sd_dns.name
      }
    }
  }
}
