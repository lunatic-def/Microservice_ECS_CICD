resource "aws_codecommit_repository" "test" {
  repository_name = "test"
  description     = "This is the Sample App Repository"
}

output "aws_codecommit_repository" {
  value = aws_codecommit_repository.test.clone_url_http
}
