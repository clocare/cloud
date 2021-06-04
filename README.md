# CloCare Cloud
Automation Deployment of a private Openstack Cloud on Azure or on premise
## About
we all know that deploying an openstack cloud is a big headache   
so this well help you to deploy a semi-production openstack     
you will deploy a wallaby openstack release on ubuntu 20.04   
you will deploy these components   
- keystone
- glance
- placement
- horizon
- nova
- neutron
- cinder   
- you can also deploy barbican, heat and magnum, just uncomment it's names in [ansible/deploy.yml](/ansible/deploy.yml) lines 48-50
## Deploy your cloud
- [Azure](azure/README.md)
- [On Premise](/on-premise.md)

## Credentials
afetr deployment you will need these credentials 
```
export OS_USERNAME=admin
export OS_PASSWORD=password
export OS_PROJECT_NAME=admin
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_DOMAIN_NAME=Default
export OS_AUTH_URL=http://controller:5000/v3
export OS_IDENTITY_API_VERSION=3
```
### todos
- add clocare theme to horizone
- make it possible to change passwords before deployment
- change nfs with a better storage solution
- make it possible to customize nodes number