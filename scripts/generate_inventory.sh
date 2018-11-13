#!/usr/bin/env bash

echo "Copy a new hosts file to /etc/ansible/hosts"
cp /root/rh_adv_deployment_homework/ocp_inventory /etc/ansible/hosts

echo "Set the current GUID to generate the inventory"
#GUID=`hostname|awk -F. '{print $2}'`
GUID=$1
sed -i "s/GUID/$GUID/g" /etc/ansible/hosts
