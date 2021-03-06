# On Permise Deployment
yes you can also deploy openstack on local machines 
## Deploy your cloud
1. first of all you need to prepare 4 machines with these specs
    - one controller node with 2 cores cpu and 8GB of ram as minimum
    - two compute nodes with 4 cores cpu and 8GB of ram for each node as minimum
    - all compute nodes must support virtualization
    - one storage node with 2GB of ram as minimum
    - all nodes must be in the same network and have internet access
    - you must be able to ssh to these machines without password `hint: use ssh-copy-id command`
2. install ansible
```
pip3 install ansible --upgrade
```
3. clone this repo
```
git clone https://github.com/clocare/cloud
```
4. change to ansible directory
```
cd ansible
```
5. update ips in [inventory](/ansible/inventory) file with public ips of your machines   
if the computer you running ansible playbooks on is in the same network with cluster machines, you can use private ips in [inventory](/ansible/inventory) file
6. run the ansible playbook
```
ansible-playbook -u ubuntu -i inventory deploy.yml -e " \
subnet=<subnet-address> \
controller_ip=<ip-address> \
compute1_ip=<ip-address> \
compute2_ip=<ip-address> \
storage_ip=<ip-address> "
```
change `<ip-address>` with your machine private ip, `<subnet-address>` with your private subnet CIDER and `ubuntu` with a sudo username