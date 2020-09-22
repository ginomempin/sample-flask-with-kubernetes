# Understanding Kubernetes (K8s)

These are my notes from tutorials on using K8s to deploy applications.

## Contents

* [Services](#services)
    * [ClusterIP](#clusterip)
    * [NodePort](#nodeport)
    * [LoadBalancer](#loadbalancer)
    * [ExternalName](#externalname)
* [Volumes](#volumes)
    * [PersistentVolume](#persistentvolume)
    * [StorageClass](#storageclass)
* [ConfigMap](#configmap)
* [Secrets](#secrets)
    * [Creating a Secret](#creating-a-secret)
    * [Accessing Secrets](#accessing-secrets)
    * [Best Practices](#best-practices)
* [References](#references)

## Services

Services abstract pod IP addresses from consumers. Pods are accessed instead via the service's name and configured domain name (same as service name) and port.

### ClusterIP

* Lets pods within the same cluster talk to each other
* Useful for accessing apps on other pods by referencing the service name instead of each pod's IP

![ClusterIP Diagram](./docs/service.clusterip.diagram.png)

### NodePort

* Exposes the node at the node's IP and a static port
* Useful for debugging specific pods by attaching a NodePort and referencing the service

![NodePort Diagram](./docs/service.nodeport.diagram.png)

### LoadBalancer

* Exposes the nodes externally
* Automatically creates NodePort and ClusterIP services
* Useful for auto-selecting "free" nodes from a pool of all nodes (replicas)

![LoadBalancer Diagram 1](./docs/service.loadbalancer.1.diagram.png)
![LoadBalancer Diagram 2](./docs/service.loadbalancer.2.diagram.png)

### ExternalName

* Acts as an alias for an external service
* Hides the details of the external service from the cluster
* Useful for apps by referencing the alias instead of the actual external domain

![External Name Diagram](./docs/service.externalname.diagram.png)

## Volumes

### PersistentVolume

A **PersistentVolume (PV)** is a cluster-wide storage unit provisioned by an administrator with a lifecycle **independent** from a Pod.
A **PersistentVolumeClaim (PVC)** is a request for a storage unit **PV**.

![PV and PVC 1](./docs/volume.pvandpvc.1.png)

![Pods and PV](./docs/volume.pvandpvc.2.png)

Step-by-Step Setup:

1. Create network storage resources (NFS, cloud, etc.)
1. Create a **PV** and send to the Kubernetes API
1. Create a **PVC** to use the **PV**
1. Bind the **PVC** to the **PV** using Kubernetes API
1. Reference the **PVC** from the Pod or Deployment
    * Define a `spec:volumes:persistentVolumeClaim:` for each claim
    * Reference the `volumes:name:` in the `containers:volumeMounts:`

![PV and PVC 2](./docs/volume.pvandpvc.3.png)

### StorageClass

A **StorageClass (SC)** provides a dynamic provisioning of **PVs**.

![StorageClass Diagram](./docs/volume.storageclass.png)

Step-by-Step Setup:

1. Create **SC**
1. Create **PVC** that references the **SC**
1. Kubernetes uses a **SC** provisioner to provision a **PV**
1. After the storage is provisioned, the **PV** is bound to the **PVC**
1. Reference the **PVC** from the Pod or Deployment (same as in [PVs](#persistentvolume))

### ConfigMap

It provides a way to inject configuration data into a container.

It can be provided in the form of:

* Key-Value pairs passed to `kubectl create configmap <name>`
    ```
    $ kubectl create configmap <name> --from-file=<path-to-file>

    $ kubectl create configmap <name> --from-env-file=<path-to-file>

    $ kubectl create configmap <name> --from-literal=key1=val1 \
                                      --from-literal=key2=val2

    ```
* ConfigMap manifest (YAML file)
    ```
    $ kubectl create|apply -f configmap.manifest.yml

    ```
* Entire files (the filename would be the key, the contents would be the value)

It can be accessed from a Pod using:

* Environment variables (key-value pairs)
* ConfigMap volume (accessed as files)

## Secrets

![Secrets Description](./docs/secrets.description.png)

### Creating Secrets

```
# Create a Secret and store securely in Kubernetes
$ kubectl create secret generic my-secrets --from-literal=pwd=my-password

# Create a Secret from a file
$ kubectl create secret generic my-secrets --from-file=ssh-key=~/.ssh/id_rsa

# Create a Secret for certificates
$ kubectl create secret tls tls-secret --cert=path/to/cert --key=path/to/key
```

Note that secrets can also be declaratively defined in a YAML file, **BUT** any secret data is only base64-encoded in the manifest file, which are easily decoded. Also, manifest files are typically checked-in source control and **it is bad to have secret data available from source control**.

### Accessing Secrets

* As environment variables (similar to [ConfigMaps](#configmap))
    ```
    env:
    - name: DATABASE_PASSWORD
      valueFrom:
        secretKeyRef:
          name: my-secrets
          key: pwd

    ```
* As volumes (similar to [ConfigMaps](#configmap)) where each key-value becomes file-content
    ```
    volumes:
    - name: app-secrets
      secret:
        secretName: my-secrets
    containers:
      volumeMounts:
      - name: app-secrets
        mountPath: /etc/passwd
        readOnly: true
    ```

### Best Practices

See [Best Practices when using Secrets](https://kubernetes.io/docs/concepts/configuration/secret/#best-practices).

## References

* [Kubernetes for Developers: Core Concepts](https://app.pluralsight.com/library/courses/kubernetes-developers-core-concepts)
* [Kubernetes Examples](https://github.com/kubernetes/examples)
