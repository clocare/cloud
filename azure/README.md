# Azure Deployment
## Requirements
1. [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
2. [Install azure Cli](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
3. log in to your azure account 
    ```bash
    az login
    ```
4. Make Sure that your subscription is active 
    ```bash
    $ az account list

    [
      {
        "cloudName": "AzureCloud",
        "homeTenantId": "f6****22-84be-48a6-b**c-c0*******1f1",
        "id": "b7*****1-475c-41a6-a**2-d********f1c",
        "isDefault": true,
        "managedByTenants": [],
        "name": "Azure for Students",
        "state": "Enabled",
        "tenantId": "f6****22-84be-48a6-b**c-c0*******1f1",
        "user": {
          "name": "foo@ex.com",
          "type": "user"
        }
      }
    ]
    ```
5. [Install Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

## Deploy your cloud
1. Clone this repo
    ```bash
    git clone https://github.com/clocare/cloud
    ```
2. Change your directory to azure deployment directory
    ```bash
    cd cloud/azure
    ```
3. Change default variables in [variables.tf](/azure/variables.tf) and make sure that your machines specs meet these requirements 
    - controller node : 2 cores cpu and 8GB of ram as minimum
    - compute nodes : 4 cores cpu and 8GB of ram for each node as minimum
    - storage node : 2GB of ram as minimum
4. deploy your cloud in One Command
```bash
./create-infra.sh
```
### SSH to your machines
```
ssh -i ../ansible/private_key.pem azureuser@<macine-public-ip>
```
## Destroy Infra Whenever you want
```bash
./destroy-infra.sh
```