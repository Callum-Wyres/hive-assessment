#!/bin/bash

################ Clone of Project

echo "Clone of github project"

git clone git@github.com:Callum-Wyres/devops-assessment.git

cd devops-assessment

###############Install of AZ CLI

echo "Do you have the azure CLI installed on your machine - If not please type yes followed by enter to install the cli onto your machine. If you have the cli installed please press enter to continue."
read cli_response

if [ [$cli_response = "yes"] ] ; then
  python setup.py
else
  echo "Continuing to with assessment criteria"
fi

################ Login to Azure

az login

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
terraform apply -target azurerm_monitor_autoscale_setting.assessment --auto-approve
terraform apply -target azurerm_application_insights.appinsight --auto-approve

curl https://cwdevops-appservice.azurewebsites.net/healthcheck
