#!/bin/sh

# Setup users and groups

# Check if projects already exist before trying to create them
# Create Alpha project
if (( $(oc get projects|grep alpha-project|wc -l) != 1 )); then
	oc adm new-project alpha-project --display-name='Alpha Corp' --node-selector='client=alpha'
fi

# Create Beta project
if (( $(oc get projects|grep beta-project|wc -l) != 1 )); then
	oc adm new-project beta-project --display-name='Beta Corp' --node-selector='client=beta'
fi

# Create groups
if (( $(oc get groups alpha 2>&1 |grep NotFound|wc -l) == 1 )); then
	oc adm groups new alpha
	oc policy add-role-to-group edit alpha -n alpha-project
	oc adm groups add-users alpha amy andrew
fi

if (( $(oc get groups beta 2>&1 |grep NotFound|wc -l) == 1 )); then
	oc adm groups new beta
	oc policy add-role-to-group edit beta -n beta-project
	oc adm groups add-users beta brian betty
fi

# Create cluster admin
if (( $(oc get groups ocp-platform 2>&1 |grep NotFound|wc -l) == 1 )); then
	oc admn groups new ocp-platform
	oc adm policy add-cluster-role-to-group cluster-admin ocp-platform
	oc adm groups add-users ocp-platform bob
fi
