#!/bin/bash

# Script to setup Jenkins

# Create CICD project
if (( $(oc get projects|grep cicd-dev|wc -l) == 0 )); then
	oc new-project cicd-dev
	oc label namespace cicd-dev "name=jenkins"
fi

# Check if jenkins is deployed
if (( $(oc get dc -n cicd-dev|grep jenkins|wc -l) == 0 )); then
	# Jenkins is not deployed yet
	oc new-app -f /root/rh_adv_deployment_homework/resources/jenkins_template.yaml \
	-p MEM_REQUESTS=1Gi -p MEM_LIMITS=2Gi -p VOLUME_CAPACITY=4G \
	-p CPU_REQUESTS=1000m -p CPU_LIMITS=1500m -n cicd-dev
fi

# Check if Jenkins is up
while : ; do
  echo "Checking if Jenkins is Ready..."
  oc get pod -n cicd-dev|grep -v deploy|grep -v build|grep "1/1"
  [[ "$?" == "1" ]] || break
  echo "...no. Sleeping 10 seconds."
  sleep 10
done



