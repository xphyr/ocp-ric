The following is based on:

https://www.openshift.com/blog/getting-started-helm-openshift
https://docs.o-ran-sc.org/projects/o-ran-sc-it-dep/en/latest/installation-guides.html#prerequisites
https://docs.openshift.com/container-platform/4.4/networking/using-sctp.html


## Prerequisites

### Cluster

The E2Term applciation requires support for SCTP which is NOT enabled by default on OpenShift Clusters. In order to get SCTP enabled follow the instructions listed here https://docs.openshift.com/container-platform/4.4/networking/using-sctp.html OR as cluster admin run the following:

```
oc login
oc create -f load-sctp-module.yaml
```

*NOTE:* This will restart all your worker nodes!

If you do not do this, you will not be able to deploy the ORAN setup.


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



We now need to patch some of the Helm charts.

```
patches/apply-patch.sh
dep/bin/deploy-ric-platform dep/RECIPE_EXAMPLE/PLATFORM/example_recipe.yaml
```



## Cleanup

dep/bin/undeploy-ric-platform