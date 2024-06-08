resource "aws_codecommit_repository" "this" {
  repository_name = "ecs_repo"
  description     = "ECS microservices ci-cd"

  
}

output "aws_codecommit_repository" {
  value = aws_codecommit_repository.this.clone_url_http
}
