# Using persistent storage with Ceph (OpenShift Container Storage)

## Intro

This document explains how to deploy OpenShift Container Storage (OCS) on OpenShift Container Platform (OCP), in order to use persistent volumes with a Ceph backend for a given application running on OpenShift.

This document is broken out into three sections: deploying OCS, making Ceph RBD (block device) the default storage class, and updating the O-RAN RIC/AUX Helm charts to use that storage class for persistent volumes.

## Deploying OCS

You can follow the documentation here as a reference: https://access.redhat.com/documentation/en-us/red_hat_openshift_container_storage/4.4/html-single/deploying_openshift_container_storage/index.

In this setup, we assume a 3-node cluster with master/worker colocated on the same node.

#### Label the OCP nodes: 
```
oc label nodes master-0 cluster.ocs.openshift.io/openshift-storage=''
oc label nodes master-1 cluster.ocs.openshift.io/openshift-storage=''
oc label nodes master-2 cluster.ocs.openshift.io/openshift-storage=''
```

#### Create two namespaces, openshift-storage and local-storage, then annotate the nodes
```
oc create namespace openshift-storage 
oc create namespace local-storage
oc annotate namespace openshift-storage openshift.io/node-selector=
```

#### Apply this daemon set to extract the disk IDs to be used by OCS. Then identify the disks to be used for OCS (Ceph).
```
oc apply -f https://raw.githubusercontent.com/dmoessne/ocs-disk-gather/master/ocs-disk-gatherer.yaml
oc logs --selector name=ocs-disk-gatherer --tail=-1 --since=10m --namespace default
```

#### Create the local storage to be used by OCS by creating a yaml with the disk ID extracted from the previous commands. You will need to choose the disks on which you would like to have Ceph or OCS.
```
vi local-storage-block.yaml
oc create -f local-storage-block.yaml
```

## Making Ceph RBD the default storage class

#### Follow the reference below
https://docs.openshift.com/container-platform/4.5/storage/dynamic-provisioning.html#change-default-storage-class_dynamic-provisioning


## Updating the O-RAN Helm charts

