# Create Infra
echo "Creating infra on azure"
terraform init
terraform plan
terraform apply -auto-approve

# Grapping VMs IPs
echo "Grapping VMs IPs"
rm -f ../ansible/inventory
echo "[controller]" >> ../ansible/inventory
az vm show --resource-group $(terraform output -raw rg_name) \
    --name $(terraform output -raw controller_vm_name) \
    -d --query [publicIps] -o tsv >> ../ansible/inventory
echo "[compute]" >> ../ansible/inventory
az vm show --resource-group $(terraform output -raw rg_name) \
    --name $(terraform output -raw compute1_vm_name) \
    -d --query [publicIps] -o tsv >> ../ansible/inventory
echo "
[all:children]
controller
compute
" >> ../ansible/inventory

# Run Ansible tasks
export ANSIBLE_HOST_KEY_CHECKING=False
echo "Run Ansible tasks"
chmod 400 ../ansible/private_key.pem
ansible-playbook -u azureuser -i ../ansible/inventory \
--private-key ../ansible/private_key.pem ../ansible/deploy.yml -e " \
subnet=$(terraform output -raw subnet_prefix) \
controller_ip=$(terraform output -raw controller_vm_private_ip) \
compute1_ip=$(terraform output -raw compute1_vm_private_ip) "

echo "***** Finshed Deployment ******"