# Terraform-homework-1 
![app-test workflow](https://github.com/likvipavel/Terraform-homework-1/actions/workflows/app-test-deploy-to-aws_ecr.yml/badge.svg)
![app-test workflow](https://github.com/likvipavel/Terraform-homework-1/actions/workflows/terraform-test-deploy-to-aws.yml/badge.svg)<br>
![readme architecture](https://user-images.githubusercontent.com/16730122/170968486-2e5e7659-d67a-43c9-a5bc-9bc696caa244.jpg)

Infrastructure definition project in Terraform deploying a failover cluster on AWS.  Source code in Python.
 Implemented by me:
 - checking code syntax using linters
 - application containerization with Docker
 - pushing container image to AWS repository (ECR)
 - Deploying an AWS Failover Cluster (ECS)
 - changing the current state of the infrastructure in case of changes in the application or configuration files
 - automation of all processes of integration and delivery of code to the production environment using CI / CD (GitHub Actions)
