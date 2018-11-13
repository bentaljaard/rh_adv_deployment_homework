#!/usr/bin/env bash

mkdir -p /srv/nfs/user-vols/pv{1..200}

echo "Creating PV for users.."

#Empty out the exports file so that this script can be run multiple times
echo "# Openshift User Volumes" > /etc/exports.d/openshift-uservols.exports

for pvnum in {1..50} ; do
  echo '/srv/nfs/user-vols/pv${pvnum} *(rw,root_squash)' >> /etc/exports.d/openshift-uservols.exports
  chown -R nfsnobody.nfsnobody /srv/nfs
  chmod -R 777 /srv/nfs
done
