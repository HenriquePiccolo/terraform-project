terraform init
terraform plan -var-file=./environments/$(terraform workspace show).tfvars 
terraform apply -var-file=./environments/$(terraform workspace show).tfvars --auto-approve