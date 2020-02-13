# Hive Devops Assessment
# Pre-requisites
 - Azure account create with a active subscription
 - Terraform installed
 - Git module installed
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
    - If the install is required please type install and hit the enter otherwise hit enter to continue with the deployment
- Performs a login to Azure
- Initilises Terraform
- Creates a Resource Group called Assessment
- Creates a Container registry called devopsassessment
- builds the docker image and pushes it to the container regsitry
-  Creates the remaining components
- Performs a curl command to confirm the site is up and running
- Requests for input to perform a terraform destory