#!/bin/bash
######## Output options

TXT_RED='\033[0;31m'
TXT_GRN='\033[0;32m'
TXT_BLU='\033[0;36m'
TXT_YEL='\033[1;33m'
TXT_NC='\033[0m'

###############Install of AZ CLI

echo -e ${TXT_YEL}"Installing homebrew package manager onto your machine followed by azure cli."${TXT_NC}

echo -e ${TXT_BLU}"Do you have the azure CLI installed on your machine - If not please type install followed by enter to install the cli. If you have the cli installed please press enter to continue."${TXT_NC}
read cli_response

if [[ $cli_response = "install" ]] ; then
  python setup.py
else
  echo -e "${TXT_YEL}Continuing to with assessment criteria${TXT_NC}"
fi

################ Login to Azure

echo -e "${TXT_YEL} Logging into your Azure subscription ${TXT_NC}"
az login

################# Initialise terraform

echo -e "${TXT_YEL}Intializing terraform....${TXT_NC}"
cd terraform
terraform init

echo -e "${TXT_YEL}Creating Azure resource group and Azure Container Registry....${TXT_NC}"
terraform apply -target azurerm_resource_group.devopsassessment -target azurerm_container_registry.acr --auto-approve
################ Build docker image
cd ..
echo -e "${TXT_YEL}Building docker image and pushing to acr....${TXT_NC}"

az acr build --registry devopsassessment --image devops-assessment .

############### Deploy ACR Image to App service
cd terraform
echo -e "${TXT_YEL}Creating app service and deploying image....${TXT_NC}"
#terraform apply -target azurerm_app_service_plan.assessment -target azurerm_app_service.assessment --auto-approve
#terraform apply -target azurerm_monitor_autoscale_setting.assessment -target azurerm_application_insights.appinsight --auto-approve
terraform apply --auto-approve

echo -e "${TXT_BLU} You can browse to the webapp via the URL https://cwdevops-appservice.azurewebsites.net/hive ${TXT_NC}"
echo -e "${TXT_GRN}Terraform deployment has successfully succeeded. ${TXT_NC}"

echo -e ${TXT_BLU}"A terraform destroy is due to prevent the application running and using further free credit. Please type yes followed by enter. Alternatively, please type no followed by enter to keep the infrastructure"${TXT_NC}
read destroy_response

if [[ $destroy_response = "yes" ]] ; then
  echo -e "${TXT_YEL}Destroying resources....${TXT_NC}"
  terraform destroy --auto-approve
  echo -e "${TXT_GRN}Terraform destroy has successfully completed. ${TXT_NC}"
else
  echo -e "${TXT_GRN}Terraform destroy was cancelled by the end user.${TXT_NC}"
fi
