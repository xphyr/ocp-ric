# Multus Networking

The O-RAN RIC Bronze release relies on [DANM](https://github.com/nokia/danm) for connecting pods to multiple networks. This functionality is required by the e2 application. OpenShift uses [Multus](https://github.com/intel/multus-cni) to achieve a similar result.

## Cluster PreConfiguation

Multus requires the creation of network definitions at the cluster level as admin. These network definitions are Namespace specific. Once the network definition is defined, the e2term deployment configuration needs to be updated to include an annotation as part of the spec to use the additional network defined.

Below are example configurations for creating a new network called "e2ric" and assigning it to a secondary interface on your worker nodes called "ens224", and assigning a static IP address of 191.168.1.23.

### Create a new additionalNetwork

Start by running the following command:

`oc edit networks.operator.openshift.io cluster`

in the "additionalNetworks" section add the following yaml, updating the device name for the secondary card on your hosts and update the IP address with the address you would like to assign.

```
- name: e2ric
    namespace: ricplt
    type: Raw
    rawCNIConfig: '{
        "cniVersion": "0.3.1",
        "name": "e2ric-network-1",
        "type": "host-device",
        "device": "ens224",
        "ipam": {
            "type": "static",
            "addresses": [
            {
                "address": "191.168.1.23/24",
            }
            ]
        }
    }'
```

*NOTE:* you can also use IPv6 static IP addresses. In the example above replace "191.168.1.23/24" with an IPv6 address such as "2001:db8::1234/32" and you will have a static IPv6 address assigned instead.

### Assigning the additional Network to the e2term pod

Once you have created the new network at the cluster level, edit the e2term deployment and add the following to the deployment spec:

```
  template:
    metadata:
      annotations:
        k8s.v1.cni.cncf.io/networks: e2ric
```

The e2term pod will re-deploy and now have the additional network interface with the specified IP address.


