#!/bin/bash
echo Updating job-tiller-secrets template
cp patches/job-tiller-secrets.yaml dep/ric-dep/helm/infrastructure/templates
echo Updating e2term template files
cp patches/e2term-deployment.yaml dep/ric-dep/helm/e2term/templates/deployment.yaml
cp patches/e2term-env.yaml dep/ric-dep/helm/e2term/templates/env.yaml
echo Updating appmgr deployment template
cp patches/appmgr-deployment.yaml dep/ric-dep/helm/appmgr/templates/deployment.yaml
echo Updating installer
cp patches/ric-dep-bin-install dep/ric-dep/bin/install
echo Removing appconfig file from alarm adapter templates
rm dep/ric-dep/helm/alarmadapter/templates/appconfig.yaml
