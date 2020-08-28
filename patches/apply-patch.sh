#!/bin/bash
echo Updating job-tiller-secrets template
cp patches/job-tiller-secrets.yaml dep/ric-dep/helm/infrastructure/templates
echo Updating vespamgr deployment template
cp patches/vespamgr-deployment.yaml dep/ric-dep/helm/vespamgr/templates/deployment.yaml
echo Updating e2term deployment template
cp patches/e2term-deployment.yaml dep/ric-dep/helm/e2term/templates/deployment.yaml
cp patches/e2term-values.yaml dep/ric-dep/helm/e2term/templates/values.yaml
echo Updating o1mediator deployment template
cp patches/o1mediator-deployment.yaml dep/ric-dep/helm/o1mediator/templates/deployment.yaml
