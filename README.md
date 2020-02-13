# Hive Devops Assessment
# Pre-requisites
 - Macbook / Linux Device
 - Azure account created with an active subscription
 - Terraform module installed on macbook
 - Git module installed on macbook

# Instructions

Please clone this repository down to your local mac device and follow the below:
 - cd into the repo on your machine
 - The details below listed in overview explain input required for the deployment.

# Overview
This Repo is used with the intentions to deploy the below into a Azure subscription:

- Azure Container Registry
- App Service Plan
- App Service (Web App)
- Auto Scaling on App Service
- App Insights (Logging)

The Script performs the below actions:

- Clones the repo holding the source code
- Prompts for input in regards to whether to install the Azure CLI
    - If the install is required please type install and hit enter, otherwise hit enter to continue with the deployment
        - Performs a install of the azure cli into /usr/local/opt/azure-cli and configures path to allow the az commands used later in this to run from any location.
- Performs a login to Azure
- Initilises Terraform
- Creates a Resource Group called Assessment
- Creates a Container registry called devopsassessment
- builds the docker image and pushes it to the container regsitry
-  Creates the remaining components
- Performs a curl command to confirm the site is up and running
- Requests for input to perform a terraform destory

