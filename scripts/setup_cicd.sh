#!/bin/bash

# Script to setup Jenkins and CI pipelines

# Create CICD project
if (( $(oc get projects|grep cicd-dev|wc -l) == 0 )); then
	oc new-project cicd-dev
fi

# Check if jenkins is deployed
if (( $(oc get dc -n cicd-dev|grep jenkins|wc -l) == 0 )); then
	# Jenkins is not deployed yet
	oc new-app jenkins-persistent --param ENABLE_OAUTH=true --param MEMORY_LIMIT=2Gi --param VOLUME_CAPACITY=4Gi -n cicd-dev
	oc rollout pause dc/jenkins -n cicd-dev
	oc set resources dc/jenkins --limits=cpu=2 --requests=cpu=1 -n cicd-dev
	oc rollout resume dc/jenkins -n cicd-dev
fi

# Check if Jenkins is up
while : ; do
  echo "Checking if Jenkins is Ready..."
  oc get pod -n ${GUID}-jenkins|grep -v deploy|grep -v build|grep "1/1"
  [[ "$?" == "1" ]] || break
  echo "...no. Sleeping 10 seconds."
  sleep 10
done



