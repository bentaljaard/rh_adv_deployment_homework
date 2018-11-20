#!/bin/bash


for item in "build" "dev" "test" "prod"
do
	if (( $(oc get projects|grep tasks-${item}|wc -l) == 0 )); then
		oc new-project tasks-${item}
	fi
done
