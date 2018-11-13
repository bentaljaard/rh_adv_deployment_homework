# Red Hat Advanced Deployment Homework

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

Instructions:
====================
* Login to Bastion Host
* Clone Repo: https://github.com/bentaljaard/rh_adv_deployment_homework.git
* cd /root/rh_adv_deployment_homework
* ansible-playbook -f 20 one_click_deploy.yaml
