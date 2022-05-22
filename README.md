# Terraform-homework-1
Install Terraform

Sign up for an AWS account

Create two ECR repositories, django-app and nginx.

Fork/Clone

Build the Django and Nginx Docker images and push them up to ECR:

$ cd app
$ docker build -t <AWS_ACCOUNT_ID>.dkr.ecr.us-west-1.amazonaws.com/django-app:latest .
$ docker push <AWS_ACCOUNT_ID>.dkr.ecr.us-west-1.amazonaws.com/django-app:latest
$ cd ..

$ cd nginx
$ docker build -t <AWS_ACCOUNT_ID>.dkr.ecr.us-west-1.amazonaws.com/nginx:latest .
$ docker push <AWS_ACCOUNT_ID>.dkr.ecr.us-west-1.amazonaws.com/nginx:latest
$ cd ..
Update the variables in terraform/variables.tf.

Set the following environment variables, init Terraform, create the infrastructure:

$ cd terraform
$ export AWS_ACCESS_KEY_ID="YOUR_AWS_ACCESS_KEY_ID"
$ export AWS_SECRET_ACCESS_KEY="YOUR_AWS_SECRET_ACCESS_KEY"

$ terraform init
$ terraform apply
$ cd ..
Terraform will output an ALB domain. Create a CNAME record for this domain for the value in the allowed_hosts variable.

Open the EC2 instances overview page in AWS. Use ssh ec2-user@<ip> to connect to the instances until you find one for which docker ps contains the Django container. Run docker exec -it <container ID> python manage.py migrate.

Now you can open https://your.domain.com/admin. Note that http:// won't work.

You can also run the following script to bump the Task Definition and update the Service:

$ cd deploy
$ python update-ecs.py --cluster=production-cluster --service=production-service
