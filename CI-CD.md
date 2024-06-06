Load balencer - Target group 1 - port 80 
                target group 2 - port 8080

Codecommit: 
    buildspec.yml >> Build stage
    appspec.yml >> Deploy stage
    taskdef.json >> template input for Deploy stage 

Build -> Pushing image to ECR 
Deploy -> Deploy app to ECS cluster >> collect the current task definition of the container
       -> Requirea task definition file in JSON type for using as template 

Application wll be deploy tio target group 1 or 2
In the middle if the deployment 
    + One Target group handles the old version of application
    + The other handles th new version of the application 


# appspec.ymal
Resources:
- TargetService:
   Type: AWS::ECS::Service
   Properties:
     TaskDefinition: <TASK_DEFINITION>
     LoadBalancerInfo:         
       ContainerName: "app"
       ContainerPort: 8080

# buildspec.yml
version: 0.2
phases:
  install:
    runtime-versions:
      docker: 18
  build:
    commands:
      - "printf 'version: 0.0\nResources:\n  - TargetService:\n      Type: AWS::ECS::Service\n      Properties:\n        TaskDefinition: <TASK_DEFINITION>\n        LoadBalancerInfo:\n          ContainerName: \"${container_name}\"\n          ContainerPort: ${container_port}' > appspec.yaml"
      - aws ecs describe-task-definition --output json --task-definition ${task_definition} --query taskDefinition > template.json
      - jq '.containerDefinitions | map((select(.name == "${container_name}") | .image) |= "<IMAGE1_NAME>") | {"containerDefinitions":.}' template.json > template2.json
      - jq -s '.[0] * .[1]' template.json template2.json > taskdef.json
artifacts:
  files:
    - imageDetail.json
    - appspec.yaml
    - taskdef.json

https://dev.to/erozedguy/ci-cd-pipeline-for-amazon-ecs-fargate-with-terraform-33na

terraform plan -var 'access_key=AKIAU6GDWRHMO7X47SKD' -var 'secret-key=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'
terraform apply -var 'access_key=AKIAU6GDWRHMO7X47SKD' -var 'secret-key=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' -auto-approve
terraform destroy -var 'access_key=AKIAU6GDWRHMO7X47SKD' -var 'secret-key=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' -auto-approve

MySideKid-at-339712838104
Z4anwxG/Q1dJGBXbQW88xwhtvCJXGxxeSVYC5KVQoD3jl80JnlozJ7iNUU8=