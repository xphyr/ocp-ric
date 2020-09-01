#!/bin/bash
# echo Updating example_recipe.yaml file
# cp patches/example_recipe.yaml dep/ric-dep/RECIPE_EXAMPLE/example_recipe.yaml
echo Updating job-tiller-secrets template
cp patches/job-tiller-secrets.yaml dep/ric-dep/helm/infrastructure/templates
echo Updating vespamgr deployment template
cp patches/vespamgr-deployment.yaml dep/ric-dep/helm/vespamgr/templates/deployment.yaml
echo Updating e2term deployment template
cp patches/e2term-deployment.yaml dep/ric-dep/helm/e2term/templates/deployment.yaml
# cp patches/e2term-values.yaml dep/ric-dep/helm/e2term/templates/values.yaml
echo Updating appmgr deployment template
cp patches/appmgr-deployment.yaml dep/ric-dep/helm/appmgr/templates/deployment.yaml
echo Updating installer
cp patches/ric-dep-bin-install dep/ric-dep/bin/install
echo Removing something
rm dep/ric-dep/helm/alarmadapter/templates/appconfig.yaml
