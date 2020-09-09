The following is based on:

https://www.openshift.com/blog/getting-started-helm-openshift
https://docs.o-ran-sc.org/projects/o-ran-sc-it-dep/en/latest/installation-guides.html#prerequisites
https://docs.openshift.com/container-platform/4.5/networking/using-sctp.html


## Prerequisites

### Cluster Configuration

#### Enable SCTP on your Cluster

The E2Term application requires support for SCTP which is NOT enabled by default on OpenShift Clusters. In order to get SCTP enabled follow the instructions listed here https://docs.openshift.com/container-platform/4.4/networking/using-sctp.html OR as cluster admin, create the load-sctp-module.yaml file using the template in the provided URL then run the following:

```
oc login
oc create -f load-sctp-module.yaml
```

*NOTE:* This will restart all your worker nodes!

If you do not do this, you will not be able to deploy the ORAN setup.  This will show up as an error about "sctp protocol not supported" when you deploy the RIC.

#### Enable hostpath SELinux profiles

The E2 application also requires RWO storage. If you do not edit the dep/RECIPE_EXAMPLE/PLATFORM/example_recipe.yaml and set a storage class to use for the e2term config. If you do not set a storage class it will attempt to use "hostpath" which by default does not work on OpenShift without making a configuration change.  When you apply this configuration to your cluster every worker node will have a new patch created `/mnt/pv-ricplt-e2term-alpha` and the SELinux policy for that directory updated to have "container_file_t" settings on it.

```
oc login
oc create -f seconfig_hostpath.yaml
```

### Workstation/Client setup
Before you begin you will need to have helm2 installed on your machine.  Here are instructions for different platforms:

### For OSX
```
brew install helm@2
brew install helm
cd /usr/local/bin
ln -s /usr/local/opt/helm@2/bin/tiller tiller
ln -s /usr/local/opt/helm@2/bin/helm helm
ln -s /usr/local/opt/helm@3/bin/helm helm3
```
### For Linux jumphost
Download the latest Helm v2 package from https://github.com/helm/helm/releases. Example: https://get.helm.sh/helm-v2.16.10-linux-amd64.tar.gz
Run the following commands:
```
tar -zxvf helm-v2.16.10-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm
```

### Using Ceph for persistent storage - Optional
If you would like to use OpenShift Container Storage (Ceph) for persistent storage, please follow the instructions in https://github.com/xphyr/ocp-ric/blob/master/persistent_storage.md

## Instructions

1. Start by cloning this repo:  https://github.com/xphyr/ocp-ric.git
2. cd ocp-ric
3. git submodule update --init --recursive --remote

## Install Tiller

```
oc login <>
oc new-project tiller
export TILLER_NAMESPACE=tiller
helm init --client-only
oc process -f tiller-template.yaml -p TILLER_NAMESPACE="${TILLER_NAMESPACE}" -p HELM_VERSION=v2.16.10 | oc create -f -
# wait a minute ish for helm to rollout
helm version
# the output should show both client and server versions

# This allows tiller full access to the cluster, which appears to be needed by the ric deployment
oc adm policy add-cluster-role-to-user cluster-admin "system:serviceaccount:${TILLER_NAMESPACE}:tiller"
```

Helm is now ready.  We will deploy RIC in a different namespace (maybe?)

### Deploy RIC

## Instructions

We now need to patch some of the Helm charts and update the installer script to update the default security context used by the ricplt namespace.

```
patches/apply-ric-patch.sh
dep/bin/deploy-ric-platform dep/RECIPE_EXAMPLE/PLATFORM/example_recipe.yaml
```

## Networking Notes

The ORAN RIC uses [kong](https://github.com/Kong/kubernetes-ingress-controller?itm_source=website&itm_medium=nav) as its ingress controller. It exposes kong using node-ports. Depending on your hosting platform (AWS, GCP, Azure, VMWare, Bare Metal, etc) some additional configuration may be necessary. Configurations such as an IPI install on VMWare or RHV will not require any additional configuration and will leverage the "*.apps.<clustername>" IP address. If you are in an environment that is fronted by a load balancer (haproxy or platform load balancer such as ELB, etc) you will need to do some additional configuration to allow the following ports into the cluster "32080/TCP,32443/TCP" and point them to one or more worker nodes to complete the network connection.

## Cleanup

dep/bin/undeploy-ric-platform

### Deploy the AUX

The AUX installer requires that nodes be labeled to deploy the components if you are using local-storage. If you are using a different storage class, be sure to update that in the ../RECIPE_EXAMPLE/AUX/example_recipe.yaml before running the install.

```
patches/apply-aux-patch.sh
dep/bin/deploy-ric-aux dep/RECIPE_EXAMPLE/AUX/example_recipe.yaml
```

## Undeploy the AUX

dep/bin/undeploy-ric-aux


# Scratchspace
