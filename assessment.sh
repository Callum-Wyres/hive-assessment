#!/bin/bash
######## Output options

TXT_RED='\033[0;31m'
TXT_GRN='\033[0;32m'
TXT_BLU='\033[0;34m'
TXT_YEL='\033[1;33m'
TXT_NC='\033[0m'

################ Clone of Project

echo -e "${TXT_YEL}Clone of terraform deployment project${TXT_NC}"

#git clone git@github.com:Callum-Wyres/devops-assessment.git

#cd devops-assessment

###############Install of AZ CLI

#echo ${TXT_BLU}"Do you have the azure CLI installed on your machine - If not please type yes followed by enter to install the cli onto your machine. If you have the cli installed please press enter to continue."${TXT_NC}
#read cli_response
#if [[ $cli_response = "install" ]] ; then
#  python setup.py
#else
#  echo "Continuing to with assessment criteria"
#fi

################ Login to Azure

#az login

################# Initialise terraform

echo "Intializing terraform...."
cd terraform
terraform init

echo "Creating Azure resource group and Azure Container Registry...."
terraform apply -target azurerm_resource_group.devopsassessment -target azurerm_container_registry.acr --auto-approve
################ Build docker image
cd ..
echo "Building docker image and pushing to acr...."

az acr build --registry devopsassessment --image devops-assessment .

############### Deploy ACR Image to App service
cd terraform
terraform apply -target azurerm_app_service_plan.assessment -target azurerm_app_service.assessment --auto-approve
terraform apply -target azurerm_monitor_autoscale_setting.assessment -target azurerm_application_insights.appinsight --auto-approve

curl https://cwdevops-appservice.azurewebsites.net/healthcheck

echo "Terraform deployment has successfully succeeded. "

read -p "Please press enter to perform a terraform destroy to prevent the application running and using further free credit."

terraform destroy --auto-approve