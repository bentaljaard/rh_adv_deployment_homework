# Red Hat Advanced Deployment Homework

Date: 29.10.2018-2.11.2018
Location: Breda, Netherlands
Instructor Name: Jindřich Káňa / +420 739 343 908 (Jindra) / jindrich.kana@elostech.cz

## Environment Details

Openshift version: *3.10.34*

Infrastructure environment: *OpenTLC Openshift HA Homework Lab*

OS: RHEL 7.5

Domain Suffix DNS: GUID.example.opentlc.com

App Suffix DNS: apps.GUID.example.opentlc.com

### Server Layout

#### Master Nodes
* master1.GUID.internal
* master2.GUID.internal
* master3.GUID.internal

#### Infrastructure Nodes
* infranode1.GUID.internal
* infranode2.GUID.internal

#### Application Nodes
* node1.GUID.internal
* node2.GUID.internal
* node3.GUID.internal
* node4.GUID.internal

#### Storage Server
* support1.GUID.internal

#### Loadbalancer
* loadbalancer1.GUID.internal



## Instructions

* Login to Bastion Host

 ``` 
 	ssh username@bastion.$GUID.example.opentlc.com 
 ```

* Switch to root user

 ``` 
 	sudo -i 
 ```

* Clone Repo: https://github.com/bentaljaard/rh_adv_deployment_homework.git

 ``` 
 	git clone https://github.com/bentaljaard/rh_adv_deployment_homework.git 
 	cd /root/rh_adv_deployment_homework 
 ```

* Start the installation and configuration process
 
 ```
 	ansible-playbook -f 20 one_click_deploy.yaml
 ```

* Login to web console:  https://loadbalancer.GUID.example.opentlc.com/

* A cluster admin account was provisioned:

 ```
 	username: bob
 	password: r3dh4t!1
 ```

## What does the One Click Deploy playbook do?



The `one_click_deploy.yaml` ansible playbook will be invoked to run the following tasks:

* Prepare GUID environment variable across all hosts
* Verify Installation and Configuration of Docker
* Verify NFS Shared Volumes on Hosts
* Install packages
* Generate Inventory Hosts File
* Execute the openshift-ansible prerequisites
* Execute the openshift-ansible Deployer
* Verify OpenShift Cluster
* Verify HA configuration
* Configure bastion to run cluster admin commands
* Create PVs for Users
* Create 25 definitions files for PVs 5G size
* Create 25 definitions files for PVs 10G size
* Create all PVs from definitions files
* Fix NFS Persistent Volume Recycling
* Configure the platform from multitenancy
* Creation of users for Alpha and Beta clients
* Assigning labels to the users according to its group
* Setup the environment for Alpha and Beta clients
* Setup the default project template
* Create the project namespace for Alpha and Beta clients
* Creating users
* Create a console admin user
* Smoke Test (nodejs-mongo-persistent)
* Configure a jenkins instance, network policies and permissions
* Setup environment projects for tasks app
* HPA configuration on production deployment of tasks app
* Setup CI/CD pipeline (openshift-tasks)
* Kick off the Jenkins openshift-tasks pipeline
