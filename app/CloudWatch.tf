resource "aws_cloudwatch_log_group" "service_bookingapp-home_log_group" {
  name = "service_bookingapp-home_log_group"
}

resource "aws_cloudwatch_log_group" "service_bookingapp-movie_log_group" {
  name = "service_bookingapp-movie_log_group"
}

resource "aws_cloudwatch_log_group" "service_bookingapp-movie2_log_group" {
  name = "service_bookingapp-movie2_log_group"
}

resource "aws_cloudwatch_log_group" "service_bookingapp-redis_log_group" {
  name = "service_bookingapp-redis_log_group"
}