version: 0.2
phases:
  install: 
    runtime-versions:
      docker: 18
    commands:       
      - PROJ_NAME="$PROJECT_NAME"
  pre_build:
    commands:
      - echo Logging in to Amazon ECR...
      - login=$(aws ecr get-login --no-include-email --region=us-east-1)
      - login=$(echo $login | sed 's/-e none/ /g' | tee)
      - echo $login | bash
  build:
    commands:
      - echo Build started on `date`
      - echo Building the Docker image...
      - docker build -t $IMAGE_REPO_NAME:$IMAGE_TAG .
      - docker tag $IMAGE_REPO_NAME:$IMAGE_TAG $ECR_ADDRESS/$IMAGE_REPO_NAME:$IMAGE_TAG
  post_build:
    commands:
      - echo Build completed on `date`
      - echo Pushing the Docker image...
      - docker push $ECR_ADDRESS/$IMAGE_REPO_NAME:$IMAGE_TAG
artifacts:
  files: 
    - imagedefinitions.json
    - githash