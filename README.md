
---

# Azure Pipeline Integration with Terraform Tasks in Release Pipeline

In this lab, we will explore deploying infrastructure using Terraform in an Azure Release pipeline.

## Use the following repository for code:
[Import Release Pipeline](WebAppTerraform.json)

## Overview

We will configure an Azure Release pipeline to automate the deployment of resources using Terraform. This involves setting up a storage account, defining the Terraform configuration, and using Azure Pipelines to manage the infrastructure.

### Initial Step:

- **Create a Storage Account**  
  You need to create a storage account to store the Terraform state file. This allows Terraform to manage your infrastructure's state across different environments.
  
- **Create a Container Named 'terraform'**  
  Inside the storage account, create a container named `terraform` and enable Blob Read-Only Access. 

**Why do we have a storage account?**  
*Terraform uses the storage account to store the state file, which is essential for tracking the resources it manages. By storing the state file in a remote location (like an Azure Blob storage container), multiple team members or CI/CD pipelines can access it, ensuring consistent infrastructure management and avoiding conflicts.*

## Tasks:

### 1. Clone the Repository
- Clone the main branch of the repository and edit `main.tf` as required.

### 2. Create a New Azure Build Pipeline
- Use the `azure-pipeline.yml` file in the repository to create a new Azure Build Pipeline.

### 3. Create a New Release Pipeline
- You can use the `WebAppTerraform.json` file in the repository to import the entire pipeline without creating it from scratch.

## Task Execution Order:

### 1. **Agent Job:**
   - Keep as default.

### 2. **Install Terraform:**
   - Go to **Azure Pipelines** → **Releases** → **Edit Pipeline** → **Stage** → **Add Task**.
   - Install Terraform from the marketplace if it's not already installed. This will make Terraform tasks available in your pipeline.

### 3. **Terraform: init**

   **Display Name:** Terraform: init  
   **Provider:** `azurerm`  
   **Command:** `init`  
   **Configuration Directory:** Browse the directory where the `main.tf` file is located.

   **Azure RM Backend Configuration:**

   - **Azure Backend Service Connection:** `Service_Connection_Name`
   - **Resource Group:** The resource group where the storage account resides.
   - **Storage Account:** Reference the storage account created earlier.
   - **Container:** `terraform` (Referring to the Blob container).
   - **Key:** Path to the Terraform remote state file inside the container, e.g., `terraform.tfstate`.

   - **Save the task.**

### 4. **Terraform: plan**

   **Display Name:** Terraform: plan  
   **Command:** `plan`  
   **Configuration Directory:** Select the directory used in the earlier step.  
   **Azure Subscription:** Select the appropriate subscription.

### 5. **Terraform: apply**

   **Display Name:** Terraform: apply  
   **Command:** `apply`  
   **Configuration Directory:** Use the same configuration directory as before.  
   **Subscription:** Specify your Azure subscription.  
   **Additional Commandline Argument:** `-auto-approve` (This automatically approves the changes to be applied).

### 6. **SQL Table Creation**

   **Azure SQL Server:** Provide the `sqlserver_name`.  
   **Connection String:** Update the server name and password in the connection string.

### 7. **Web App Deployment**

   **App Name:** Specify the name of the web app as given in the Terraform file.

### 8. **Web App Service Settings**

   **App Service Name:** Use the name of the web app as given in the Terraform file.  
   **Resource Group:** Specify the resource group where the web app resides.

### 9. **Create a Release**

   After configuring all tasks, create the release. This will execute the deployment pipeline, provisioning the infrastructure and deploying the application using Terraform.

## Conclusion

We have successfully used a Terraform configuration file to deploy resources using Azure Pipelines. By integrating Terraform into your CI/CD pipeline, you can automate the provisioning and management of your infrastructure, ensuring consistency and efficiency across environments.

---

