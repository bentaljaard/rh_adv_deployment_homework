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
	oc -n tasks-build new-build --name=tasks jboss-eap70-openshift:1.7~https://github.com/OpenShiftDemos/openshift-tasks.git
fi

# Add policies to allow image promotion
oc policy add-role-to-group system:image-puller system:serviceaccounts:tasks-prod -n tasks-test
oc policy add-role-to-group system:image-puller system:serviceaccounts:tasks-test -n tasks-dev
oc policy add-role-to-group system:image-puller system:serviceaccounts:tasks-dev -n tasks-build

# Setup objects in projects
if (( $(oc get dc -n tasks-dev|wc -l) == 0 )); then
	oc new-app tasks-build/tasks:0.0-0 --name=tasks-dev --allow-missing-imagestream-tags=true --allow-missing-images=true -n tasks-dev
	oc set triggers dc/tasks-dev --remove-all -n tasks-dev
	oc set resources dc/tasks-dev --limits=cpu=250m,memory=512Mi --requests=cpu=100m,memory=300Mi -n tasks-dev
	oc set probe dc/tasks-dev -n tasks-dev --liveness --failure-threshold 3 --initial-delay-seconds 40 -- echo ok
	oc set probe dc/tasks-dev -n tasks-dev --readiness --failure-threshold 3 --initial-delay-seconds 30 --get-url=http://:8080/ws/healthz/
	oc expose dc tasks-dev --port 8080 -n tasks-dev
	oc expose svc/tasks-dev -n tasks-dev
fi

if (( $(oc get dc -n tasks-test|wc -l) == 0 )); then
	oc new-app tasks-dev/tasks:0.0-0 --name=tasks-test --allow-missing-imagestream-tags=true --allow-missing-images=true -n tasks-test
	oc set triggers dc/tasks-test --remove-all -n tasks-test
	oc set resources dc/tasks-test --limits=cpu=250m,memory=512Mi --requests=cpu=100m,memory=300Mi -n tasks-test
	oc set probe dc/tasks-test -n tasks-test --liveness --failure-threshold 3 --initial-delay-seconds 40 -- echo ok
	oc set probe dc/tasks-test -n tasks-test --readiness --failure-threshold 3 --initial-delay-seconds 30 --get-url=http://:8080/ws/healthz/
	oc expose dc tasks-test --port 8080 -n tasks-test
	oc expose svc/tasks-test -n tasks-test
fi

if (( $(oc get dc -n tasks-prod|wc -l) == 0 )); then
	oc new-app tasks-test/tasks:0.0-0 --name=tasks-prod --allow-missing-imagestream-tags=true --allow-missing-images=true -n tasks-prod
	oc set triggers dc/tasks-prod --remove-all -n tasks-prod
	oc set resources dc/tasks-prod --limits=cpu=250m,memory=512Mi --requests=cpu=100m,memory=300Mi -n tasks-prod
	oc set probe dc/tasks-prod -n tasks-prod --liveness --failure-threshold 3 --initial-delay-seconds 40 -- echo ok
	oc set probe dc/tasks-prod -n tasks-prod --readiness --failure-threshold 3 --initial-delay-seconds 30 --get-url=http://:8080/ws/healthz/
	oc expose dc tasks-prod --port 8080 -n tasks-prod
	oc expose svc/tasks-prod -n tasks-prod
fi

# Setup pipeline


