# Hello world flask app

## Requirements
> 1. AWS CLI
> 3. Python
> 4. pip
> 5. Docker


## Instructions

## Running application locally

### Running with Docker
Use the following commands to run the application using python

> 1. Build image - `docker build -t flask-api .`
> 2. Run container - `docker run -p 8000:8000`
> 3. Confirm app is running from terminal - `curl http://localhost:8000` or from browser `http://localhost:8000`
> 3. Using docker compose - `docker-compose up` or `docker-compose up -d` for detached mode


## Running application in the cloud (AWS EKS)

### Docker image build
> 1. `docker build -t flask-api .`

### ECR - push image to ECR (from Terraform folder)
> 1. Create repo in AWS ECR named `flask-api`.
> 2. login to ECR - `aws ecr get-login-password --region <aws_region> | docker login --username AWS --password-stdin <aws_account_id>.dkr.ecr.<aws_region>.amazonaws.com`
> 3. Tag image for ECR - `docker tag flask-api:latest <aws_ecr_repository_url>:latest`
> 4. Push image to ECR - `docker push <aws_ecr_repository_url>:latest`

## Updating chart values
> 1. Update ingress hostname in `flask-api-chart\values.yaml` to the desired hostname.
> 2. Update ingress certificate arn for domain in `flask-api-chart\values.yaml`.
> 3. Update the container image repository in the `flask-api-chart\values.yaml` file to the ECR image URL.
   

### Deploy app to EKS cluster 
#### *Note the ingress template was written using AWS load balancer controller** it will not deploy properly if using nginx controller
> 1. Change kubeconfig context to eks cluster - `aws eks --region <aws_region> update-kubeconfig --name <cluster_name>`
> 2. Perform a helm chart dry run - `helm upgrade flask-api flask-api-chart/ --values flask-api-chart/values.yaml --install --dry-run`
> 3. Install helm chart - `helm upgrade flask-api flask-api-chart/ --values flask-api-chart/values.yaml --install`

