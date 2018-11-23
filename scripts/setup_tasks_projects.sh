#!/bin/bash

# Create projects
for item in "build" "dev" "test" "prod"
do
	if (( $(oc get projects|grep tasks-${item}|wc -l) == 0 )); then
		# Create projects
		oc new-project tasks-${item}
		# Assign policies
		oc policy add-role-to-user edit system:serviceaccount:cicd-dev:jenkins -n tasks-${item}
	fi
done

# Create build for openshift-tasks application
if (( $(oc get bc -n tasks-build|wc -l) == 0 )); then
	oc -n tasks-build new-build --binary=true --name=tasks jboss-eap70-openshift:1.7
fi

# Add policies to allow image promotion
oc policy add-role-to-group system:image-puller system:serviceaccounts:tasks-prod -n tasks-test
oc policy add-role-to-group system:image-puller system:serviceaccounts:tasks-test -n tasks-dev
oc policy add-role-to-group system:image-puller system:serviceaccounts:tasks-dev -n tasks-build

# Setup objects in projects
for item in "dev" "test" "prod"
do
	if (( $(oc get dc -n tasks-${item}|wc -l) == 0 )); then
		oc new-app tasks-build/tasks:0.0-0 --name=tasks-${item} --allow-missing-imagestream-tags=true --allow-missing-images=true -n tasks-${item}
		oc set triggers dc/tasks-${item} --remove-all -n tasks-${item}
		oc set resources dc/tasks-${item} --limits=cpu=250m,memory=512Mi --requests=cpu=100m,memory=300Mi -n tasks-${item}
		oc set probe dc/tasks-${item} -n tasks-${item} --liveness --failure-threshold 3 --initial-delay-seconds 40 -- echo ok
		oc set probe dc/tasks-${item} -n tasks-${item} --readiness --failure-threshold 3 --initial-delay-seconds 30 --get-url=http://:8080/ws/healthz/
		oc expose dc tasks-${item} --port 8080 -n tasks-${item}
		oc expose svc/tasks-${item} -n tasks-${item}
	fi
done

# Setup pipeline

if (( $(oc get bc -n cicd-dev|grep tasks-pipeline|wc -l) == 0 )); then
	oc -n cicd-dev apply -f /root/rh_adv_deployment_homework/resources/cicd-pipeline.yaml
fi

