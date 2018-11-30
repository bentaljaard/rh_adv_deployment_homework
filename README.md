# Red Hat Advanced Deployment Homework

Date: 29.10.2018-2.11.2018
Location: Breda, Netherlands
Instructor Name: Jindřich Káňa / +420 739 343 908 (Jindra) / jindrich.kana@elostech.cz

## Environment Details

Openshift version: 3.10.34
Infrastructure environment: OpenTLC Openshift HA Homework Lab
OS: RHEL 7.5

Server Layout:

master1.GUID.internal
master2.GUID.internal
master3.GUID.internal

infranode1.GUID.internal
infranode2.GUID.internal

node1.GUID.internal
node2.GUID.internal
node3.GUID.internal
node4.GUID.internal

support1.GUID.internal
loadbalancer1.GUID.internal

Domain Suffix DNS: GUID.example.opentlc.com
App Suffix DNS: apps.GUID.example.opentlc.com

## Instructions

* Login to Bastion Host

''' ssh username@bastion.$GUID.example.opentlc.com '''

* Clone Repo: https://github.com/bentaljaard/rh_adv_deployment_homework.git
* cd /root/rh_adv_deployment_homework
* ansible-playbook -f 20 one_click_deploy.yaml



1. Login to the bastion host of the homework environment

# ssh -i @bastion.$GUID.example.opentlc.com

2. Login as root user

# sudo su -

3. Clone Repo

# git clone https://github.com/adnan-drina/ocp_advanced_deployment_homework.git

# cd ocp_advanced_deployment_homework/

4. To start the installation

# ansible-playbook ./homework.yaml


The `homework.yaml` ansible playbook will be invoked to run the following tasks:

* Prepare GUID environment variable across all hosts
* Verify Installation and Configuration of Docker
* Verify NFS Shared Volumes on Hosts
* Install packages and config auth
* Generate Inventory Hosts File
* Execute the openshift-ansible prerequisites
* Execute the openshift-ansible Deployer
* Verify OpenShift Cluster
* Post-installation configuration
* Create PVs for Users
* Create 25 definitions files for PVs 5G size
* Create 25 definitions files for PVs 10G size
* Create all PVs from definitions files
* Fix NFS Persistent Volume Recycling
* Smoke Test (nodejs-mongo-persistent)
* Creating users
* Create a console admin user
* Setup CI/CD pipeline (container-pipelines)
* Kick off the Jenkins openshift-tasks pipeline
* HPA configuration on production deployment of basic-spring-boot-prod
* Creation of users for Alpha and Beta clients
* Assigning labels to the users according to its group
* Setup the environment for Alpha and Beta clients
* Setup the default project template
* Create the project namespace for Alpha and Beta clients