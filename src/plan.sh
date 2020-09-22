terraform init
terraform plan -var-file=./env.tfvars 
terraform apply -var-file=./env.tfvars --auto-approve