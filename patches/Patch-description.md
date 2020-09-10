# Patch Description

## Intro

This document explains the reasoning behind each "patch file" listed in this directory required to get the [O-RAN-SC](https://o-ran-sc.org/) [Bronze release](https://wiki.o-ran-sc.org/pages/viewpage.action?pageId=14221635) to work on [OpenShift Container Platform](https://www.openshift.com/) v4.5. The changes listed here are the minimum required changes required to make the software deploy. There are other places for improvement (including updating the application to not require running as root) to better secure the application but can be addressed at a later time.

This document is broken out into four sections the "platform", "ric", "aux" and "xapps" areas. Each will address the patches that were created for that specific portion of the O-RAN.

## Platform

As called out in the Primary readme there are a few cluster changes that are needed to support the running of the RIC.

* Enable sctp
* Enable SEL Context on /mnt

## O-RAN RIC

### Install Script

*File:* dep/ric-dep/bin/install

The ric install script has been updated to add "anyuid" SCC profile to all service accounts used in the ricplt namespace. This is required because the apps running inside the containers expect to be running as root. For some applications, this could be overcome by adding an emptyDir mount on the scratch spaces that the pods write to. 

### Remove file from alarmadapter template

*File:* dep/ric-dep/helm/alarmadapter/templates/appconfig.yaml

There is one file located in the `dep/ric-dep/helm/alarmadapter/templates` directory `appconfig.yaml` that appears to conflict with existing settings. This problem occurs in the "happy-path" install process as well as when installing on OpenShift. If this file is removed, the alarmadapter will deploy successfully.

### Update appmgr deployment template

*File:* dep/ric-dep/helm/appmgr/templates/deployment.yaml

The appmgr application container is set up to run the application as PID0. In order to make this run properly, we need to explicitly call this out for OpenShift to run the pod as root.

### Update e2term deployment templates

*File:* dep/ric-dep/helm/e2term/templates/deployment.yaml

Adds a new environment variable "MY_POD_IP_SERVICE_HOST" to point to the pod IP address. This is a workaround to address the issues with the health checks failing.

*File:* dep/ric-dep/helm/e2term/templates/env.yaml

The entry "RMR_SRC_ID" is updated to "RMR_SRC_IDD" this is a workaround to address the issues with the health checks failing.

### Update job-tiller-secrets file

*File:* dep/ric-dep/helm/infrastructure/templates/job-tiller-secrets.yaml

The job-tiller-secrets file is updated to use an emptyDir volume to act as scratch space for the creation of the pki secrets used by the o-ran ric.

## O-RAN AUX
