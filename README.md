The following is based on:

https://www.openshift.com/blog/getting-started-helm-openshift
https://docs.o-ran-sc.org/projects/o-ran-sc-it-dep/en/latest/installation-guides.html#prerequisites


## Prerequisites

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

```
oc login <>
oc new-project tiller
export TILLER_NAMESPACE=tiller
helm init --client-only
oc process -f tiller-template.yaml -p TILLER_NAMESPACE="${TILLER_NAMESPACE}" -p HELM_VERSION=v2.16.10 | oc create -f -
# wait a minute ish for helm to rollout
helm version
# the output should show both client and server versions
```

Helm is now ready.  We will deploy RIC in a different namespace (maybe?)

### Deploy RIC

```
oc new-project ricdeploy
oc policy add-role-to-user edit "system:serviceaccount:${TILLER_NAMESPACE}:tiller"
oc new-project ricplt
oc policy add-role-to-user edit "system:serviceaccount:${TILLER_NAMESPACE}:tiller"
oc new-project ricxapp
oc policy add-role-to-user edit "system:serviceaccount:${TILLER_NAMESPACE}:tiller"
oc new-project ricinfra
oc policy add-role-to-user edit "system:serviceaccount:${TILLER_NAMESPACE}:tiller"
oc new-project ricaux
oc policy add-role-to-user edit "system:serviceaccount:${TILLER_NAMESPACE}:tiller"

cd ../dep/bin
./deploy-ric-platform ../RECIPE_EXAMPLE/PLATFORM/example_recipe.yaml
```



## Cleanup

helm del --purge r4-a1mediator
helm del --purge r4-alarmadapter
helm del --purge r4-dbaas
helm del --purge r4-e2mgr
helm del --purge r4-e2term
helm del --purge r4-jaegeradapter
helm del --purge r4-o1mediator
helm del --purge r4-rtmgr
helm del --purge r4-submgr
helm del --purge r4-vespamgr
helm del --purge r4-xapp-onboarder
helm del --purge r4-appmgr
helm del --purge r4-infrastructure

oc delete project ricxapp
oc delete project ricplt
oc delete project ricinfra
oc delete project ricaux