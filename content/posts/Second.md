---
title: "Kubernetes"
date: 2020-05-23T16:26:19+02:00
description: Fusce lacus magna, maximus nec sapien eu, porta efficitur neque. Aliquam erat volutpat. Vestibulum enim nibh, posuere eu diam nec, varius sagittis turpis.
---

# Kubernetes

Kubernetes is a software system that allows you to easily deploy and manage containerized applications on top of it. It relies on the features of Linux containers to run heterogenerous applications. 

Deploying applications through Kubernetes is always the same, whether your cluster contains only a couple of nodes or thousands of them.

Kubernetes is composed of a master node and any number of worker nodes. When the developer submits a list of apps to the master node, Kubernetes deploys them to the cluster of worker nodes.

The developer can specify that certain apps must run together and Kubernetes will deploy them on the same worker node.

Kubernetes can be thought of as an operating system for the cluster. It relieves application developers from having to implement certain infrastructure-related services into their apps; Kubernetes provides discovery, scaling, load-balancing, self-healing and leader election. 

Kubernetes will run your containerized app somewhere in the cluster, provide information to its components on how to find each other, and keep all of them running.

## Two types of nodes

A kubernetes cluster is composed of two types of nodes. 

* The master node, which hosts the Kubernetes Control Plane and controls and manages the whole Kubernetes system.

* Worker nodes that run the actual applications you deploy.

## The control plane

The control plane is what controls the cluster and makes it function. It consists of multiple components that can run on a single master node or be split across multiple nodes and replicated to ensure high availability.

* The Kubernetes API server, which you and the other Control Plane components communicate with

* The Scheduler, which schedules your apps (assigns a worker node to each deployable component of your application)

* The controller manager, which performs cluster-level functions, such as replicating components, keeping track of worker nodes, handling node failures and so on.

* etcd, a reliable distributed data store that persistently stores the cluster configuration.

## The Nodes

The worker nodes are the machines that run your containerized applications. The task of running , monitoring, and providing services to your applications is done by the following components:

* Docker, rkt, or another container runtime, which runs your containers.

* The Kubelet, which talks to the API server and manages containers on its node.

* The Kubernetes Service Proxy (kube-proxy), which load-balances network traffic between application components.

## Running an application

To run an application in Kubernetes you need to package it up into one or more container images, push those images to an image registry, and then post a description of your app to the Kubernetes API server.

The description includes

* Container image or images that contain your application components.

* How those components are related to each other.

* Which ones need to run on the same nodes and which don't. 

* For each component, you can specify how many replicas you want to run. Additionally, the description also includes which of those components provide a service to either internal or external client and should be exposed through a single IP address and made discoverable to the other components. 

* Which components that should provide a service to internal or external clients and should be exposed through a single IP address and made discoverable to other components. 

## Description

The workflow applying a description.

1. The API server processes your app's description, the Scheduler schedules the specificed groups of containers onto the available worker nodes based on the computational requirements of each group and the unallocated resources on each node at the time.

2. The Kubelet on those nodes instructs the Container Runtime to pull the required container images and run the containers.

Once the application is running, Kubernetes makes sure that the deployed state of the application always matches the description you provided. So if a node goes down then Kubernetes will redistribute the workload out to the existing nodes.

## Scaling

Kubernetes allows increasing and decreasing the number of copies, and Kubernetes will spin up additional ones or stop the excess ones. It is possible to give the job of optimizing the amount of replicas based on metrics such as CPU load and memory etc.

## Load balancing

To allow clients to find containers that provide a specific service, you tell Kubernetes which containers provide the same service and Kubernetes will expose them all though a single static IP. The kube-proxy will make sure connections to the service are load balanced across all the containers that provide the service.

The IP address of the service is always constant, even if nodes go down.


## Pods

Kubernetes do not deal with individual containers directly. Instead, it uses the concept of multiple co-located containers. The collection of containers is called a Pod.

A pod is a group of one or more tightly related containers that will always run together on the same worker node and in the same Linux namespace(s). Each pod is like a seperate logical machine with its own IP, hostname, processes, and so, running a single application.

All the containers in a pod will appear to be running on the same logical machine, whereas containers in other pods, even if they're running on the same worker node, will appear to be running on a different one.


### Access the Pod

To access a pod from the outside a service object is used. A service of type LoadBalancer is used to expose the Pod to external clients otherwise by using a CluserIp service it can only be accessed from inside the cluster. By creating a LoadBalancer type service, an external load balancer will be created and you can connect to the pod through the load balancers public ip.


### Pod Network

All pods in a Kubernetes cluster reside in a single flat, shared, network-address space, which means every pod can access every other pod at the other pod's IP address. No network address translation gateways exist between them. When two pods send network packets between each other, they'll each see the actual IP address of the other as the source IP in the packet.

This means that communication between pods is always simple. The communication is much like computers on a LAN. Like a computer on a LAN, each pod gets its own IP address and is accessible from all other pods through this network established specifically for pods.

#### Port forward pod to local network

In case of debugging or other reasons you can port-forward a pod to the local machine network using the following command:

```sh
kubectl port-forward $podname $portnumber:$portnumber 
```

### Pod Definition

The pod definition consists of a few parts. First, there's the Kubernetes API version used in the YAML and the type of resource the YAML is describing. Then, three important sections are found in almost all Kubernetes resources:

* Metadata includes the name, namespace, labels, and other information about the pod.
* Spec contains the actual description of the pod's contents, such as the pod's containers, volumes, and other data.
* Status contains the current information about the running pod, such as what condition the pod is in, the description and status of each container, and the pod's internal IP and other basic info.

Specifying ports in the pod defition is purely informational. Ommiting them has no effect on whether clients can connect to the pod through the port or not. If the container is accepting connections through a port bound to the 0.0.0.0 address, other pods can always connect to it, even if the port isn't listed in the pod spec explicitly.

Example of a simple Pod definition

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: kubia-manual
spec:
  containers:
  - image: runeanielsen/kubia
    name: kubia
    ports:
    - containerPort: 8080
      protocol: TCP
```

## Labels

Labels are a Kubernetes feature to organize not only pods but all Kubernetes resources. A label is a key-value pair you attach to a resource, which is then used for label selectors. A resource can have multiple labels, as long as the keys of those labels are unique. It is possible to add and modify labels on an existing resource without having to recreate that resource.

Example of a pod definition with two labels: 'creation_mode: manual', 'env: prod'.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: kubia-manual
  labels:
    creation_method: manual
    env: prod
spec:
  containers:
  - image: runeanielsen/kubia
    name: kubia
    ports:
    - containerPort: 8080
      protocol: TCP
```

To get containers on labels with specific labels the following command can be used, showing how to receive all pods with label creation_method : env.

```sh
kubectl get po -L cration_method,env
```

## Annotations

Kubernetes resources can contain annotations. A annotation is a key-value pair, they're similar to labels, but aren't meant to hold identifying information. A annoation cannot be used to group resources but it is used for holding much bigger information and that information is maent to be used by tools. Certain annotations are automatically added to Kubernetes resources. A great use of annotations are to add descriptions for pods and other resources. 


Example of adding a annotation to a pod.

```sh
kubectl annotate pod kubia-manual mycompany.com/someannotation="foo bar"
```

## Namespaces

Namespaces allow you to split complex systems with numerous components into smaller distinct groups. They can also be used to seperate resources in a multi-tenant environment. A common use-case for namespaces are to split resources up into production, staging and development.

Resource names do only need to be unique within the namespaces - this allows multiple resources to have the same name as long as they're in seperate namespaces. Namespaces do not provide network isolation by default, this means that pods accross different namespaces can talk to each other.

Not all resource types are seperated across namespaces, one of them is the node resource type that is global and is not tied to a single namespace. 

To get resources in a specific namespace, in this example the filtered namespace is 'kube-system'.

```sh
kubectl get po -n kube-system
```


Example of creating a namespace definition in yaml.

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: custom-namespace
```

To create a resource in the namespace you've created you can either add a metadata tag called 'namespace' in the definition file or set it doing the resource creation.

```sh
kubectl create -f resource-definition.yaml -n custom-namespace
```

When having multiple namespaces you're required to use the '-n' flag to manage resources in different namespaces. To quickly switch between namespaces create an alias like this to switch between contexts, you can then switch context by using 'kcd --namespace some-namespace'

```sh
alias kcd='kubectl config set-context $(kubectl config current-context) --namespace'
```

By deleting a namespace all resources in that namespace will also be deleted.

```sh
kubectl delete ns custom-namespace
```

## Replication Controller & Deployments

In the real world you almost never deploy pods directly. Instead you create resources of type Replication Controller and Deployment to handle the pods. The reason for this is that if a node dies and for example a pod is created directly, then the pod wont get restarted but if it is managed by a replication controller the pod will be spun up on another available node.

### Liveness Probe

Kubernetes checks if a pod is alive by using a liveness probe for each container in the pods specification. Kubernetes will periodically run the probe and restart the probe if the probe fails.

Kubernetes can probe a container using one of the three mechanisms:

* An HTTP GET probe performs an HTTP GET request on the containers IP address, a port and path you specify. If the response does not represent an HTTP error the probe is considered successful.

* A TCP Socket probe tries to open a TCP connection to the specified port of the container. If the connection is established successfully, the probe is successful.

* An Exec probe executes an arbitrary command inside the container and checks the commands exit status code. If the status code is 0, the probe is successful.

Adding a liveness probe to a pod

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: kubia-liveness
spec:
  containers:
  -  image: runeanielsen/kubia
  name: kubia
  livenessProbe:
    httpGet:
      path: /
      port: 8080
```

For pods running in production you should always define a liveness probe. Without one, Kubernetes has no way of knowing whether your app is still alive or not. As long as the process is still running, Kubernetes will consider the container to be healthy.

### Replication Controller

A ReplicationController is a Kubernetes resourcae that ensures itsa pods are always kept running. If the pod goes down for any reason, such as in the event of a node disappearing from the cluster or because the pod was evicted from the node, the ReplicationController notices the missing pod and creates a replacement pod. 

A ReplicationController monitors the list of running pods and makes sure the actual number of pods of a "type" always matches the declared number. ReplicationControllers opertes on sets of pods that match a certain label selector.

A ReplicationController has three esential partsas:

* A label selector, which determines what pods are in the ReplicationControllers scope

* A replica count, which specifies the desired number of pods that should be running

* A pod template, which is used when creating new pod replicas

All of the above can be modified at any time, but only changes to the replica count affect existing pods.

Example of a ReplicationController definition file.

```yaml
apiVersion: v1
kind: ReplicationController
metadata:
  name: kubia
spec:
  replicas: 3
  selector:
    app: kubia
  template:
    metadata:
      labels:
        app: kubia
    spec:
      containers:
      - name: kubia
        image: runeanielsen/kubia
        ports:
        - containerPort: 8080
```

To scale an Replication Controller the following command can be used

```sh
kubectl scale rc kubia --replicas=20
```

It is also possible to increase the amount of replicas by editing the Replication Controller using the 'edit' command and increase the replicas in the file.

```sh
kubectl edit rc kubia
```

Anoter way is to increase the replication amount in the yaml file and apply the changes.

```sh
kubectl apply -f my-rc.yaml
```

#### Deleting a Replication Controller

When you delete a Replication Controller through 'kubectl delete', the pods are also deleted. But because pods are created by a Replication Controller aren't an integral part of the ReplicationController, and are only managed by it, you can delete only the Replication Controller and leave the pods running.

This can be done by using the 'cascade' flag and setting it to false.

```sh
kubectl delete rc kubia --cascade=false
```

## ReplicaSets

In the beginning ReplicationController were the only Kubernetes component for replicating pods and rescheduling them when nodes failed. Later, ReplicaSet was introduced. It's a new generation of ReplicationController and replaces it completely (ReplicationController will eventually be deprecated). ReplicaSets are almost identical to ReplicationControllers.

You usually won't create ReplicaSets directly, but instead have them created automatically when you create the higher-level Deployment resource. 

### ReplicaSets vs ReplicationController

A ReplicaSet behaves exactly like a ReplicationController, but it has more expressive pod selectors. Where as a ReplicationController's label selector only allows matching pods that includes a certain label, a ReplicaSet's selector also allows matching pods that lack a certain label or pods that include a certain label key, regardless of its value.

A ReplicationController can't match pods with two different key values as the same time. But a single ReplicaSet can match both at the same time and treat them a single group.

Example of a ReplicaSet.

```yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: kubia
spec: 
  replicas: 3
  selector:
    matchLabels:
      app: kubia
  template:
    metadata:
      labels:
        app: kubia
    spec:
      containers:
      - name: kubia
        image: runeanielsen/kubia
```

The main improvements of ReplicaSets over ReplicaitonControllers are their more expressive label selectors. You can either use the simple 'matchLabels' selector or use the more expressive 'matchExpressions' selector.

Example of ReplicaSet using 'matchExpressions'.

```yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: kubia
spec: 
  replicas: 3
  selector:
    matchExpressions:
      - key: app
        operator: In
        values:
          - kubia
  template:
    metadata:
      labels:
        app: kubia
    spec:
      containers:
      - name: kubia
        image: runeanielsen/kubia
```

The 'matchExpressions' can contain the following four operators:

* In - Labels value mustmatch one of the specified values.

* NotIn - Labels value must not match any of the specified values.

* Exists - Pod must include a label with the specified key (the value isn't important). When using this operator, you shouldn't specify the 'values' field.

* DoesNotExist - Pod must not include a label with the specified key. The 'values' property must not be specified.

If you specify multiple expressions, all those expressions must evaluate to true for the selector to match a pod. 

## DaemonSet

DaemonSet object is much like a ReplicationController or ReplicaSet, expect that pods created by a DaemonSet already have a target node specified and skip the Kubernetes Scheduler. They aren't scattered around the cluster randomly. A DaemonSet makes sure it creates as many pods as there are nodes and deploys each one on its own node. Whereas a ReplicaSet or ReplicationController makes sure that a desired number of pods replicas exist in the cluster, a DaemonSet does not have any notion of a desired replica count it just makes sure that a pod matching its pod selector is running on each node.

DaemonSet automatically deploys a new pod instance when a new node is added to the cluster.

DaemonSet deploys pods to all nodes in the cluster by default, unless you specify that the pods should only run on a subset of all the nodes. To do this the 'nodeSelector' is used.

Example of a DaemonSet that is only deployed on nodes with SSD disks.

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: ssd-monitor
spec:
  selector:
    matchLabels:
      app: ssd-monitor
  template:
    metadata:
      labels:
        app: ssd-monitor
    spec:
      nodeSelector:
        disk: ssd
      containers:
    - name: main
      image: runeanielsen/ssd-monitor
```

## Job resource

Kubernetes includes support for not continious tasks using the 'Job' resource. The 'Job' resources allows you to run a pod whose container isn't restarted when the process running inside finishes successfully. 

In the case of a node failure, the pods on that node that are managed by a Job will be rescheduled to other nodes the way ReplicaSet pods are.

Jobs are useful for ad hoc tasks, where its crucial that the task finishes properly. You could run the task in an unmanaged pod and for it to finish, but in the event of a node failing or the pod being evicted from the node while it is performing its task, you'd need to manually recreate it.

Example of a Job definition

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: batch-job
spec:
  template:
    metadata:
      labels:
        app: batch-job
    spec:
      restartPolicy: OnFailure
      containers:
      - name: main
        image: runeanielsen/batch-job
```


### Jobs in parallel

Jobs may be configured to create more than one pod intance and run them in parallel or sequentially. This is done by setting the completions and parallelism properties in the Job spec.

If you need the Job to run more than once, you can set the completions to the amount of times that you want the Job's pod to run.

This example will run five pods one after the other.

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: multi-completion-batch-job
spec:
  completions: 5
template:
    metadata:
      labels:
        app: batch-job
    spec:
      restartPolicy: OnFailure
      containers:
      - name: main
        image: runeanielsen/batch-job
```

### Cron Jobs

When a job needs to be run at a specific time 'Cron Jobs' are used.

Example of a CronJob

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: batch-job-every-fifteen-minutes
spec:
  schedule: "0,15,30,45 * * * *"
  jobTemplate:
    spec:
      template:
        metadata:
          labels:
            app: periodic-batch-job
        spec:
          restartPolicy: OnFailure
          containers:
          - name: main
            image: runeanielsen/batch-job
```

## Services

A Kubernetes Service is a resource you create to make a single, contant point of entry to a group of pods providing the same service. Each service has an IP address and port that never change while the service exists. Clients can then open a connection to that IP and port, that connection is then routed to one of the pods backing that service. This way, clients of a service don't need to know the location of individual pods providing the service, allowing those pods to be moved around the cluster at any time.

Example of a service definition. The example only exposes the group of pods to other pods in the cluster.

```yaml
apiVersion
kind: Service
metadata:
  name: kubia
spec:
  ports:
  - port: 80
    targetPort: 8080
  selector:
    app: kubia
```

You can send request to your service from within the cluster in a few ways:

* The obvious way is to create a pod that will send the request to the service's cluster IP and log the response. You can then examine the pod's log to see what the service's response was.

* You can ssh into one of the Kubernetes nodes and use the curl command. 

* You can execute the curl command inside one of your existing pods through the kubectl exec command.

Example of kubectl exec command

```sh
kubectl exec pod-name -- curl -s http://pod-ip
```

If you want all requests made by a certain client to be redirected to the same pod every time, you can set the service's 'sessionAffinity' property to 'ClientIp' (instread of 'Node', which is the default).

### Multiple ports

Services can also support multiple ports. Example could be two different ports one for HTTP and one for HTTPS.

Example

```yaml
apiVersion: v1
kind: Service
metadata:
  name: kubia
spec:
  ports:
  - name: http
    port: 80
    targetPort: 8080
  - name: https
    port: 443
    targetPort: 8443
  selector:
    app: kubia
```

### Discovering services through environment variables

When a pod is started, Kubernetes initializes a set of environment variables pointing to each service taht exists at the moment. If you create the service before creating the client pods, processes in those pods can get the IP address and port of the serivce by inspecting their environment variables.

An example of a environment variable for the Kubia service 'KUBIA_SERVICE_HOST', 'KUBIA_SERVICE.PORT'.

### Exposing services to the outside

To create a service with manually managed endpoints, you need to create both a Service and an Endpoint resource.

#### Creating a service without a selector

This example defines a service called 'external-service' that will accept incomming connections on port 80. Notice that a pod selector is not defined for this service.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: external-service
spec:
  ports:
  - port: 80

```

#### Creating an endpoint resource for a service without a selector

Endpoints are a seperate resource and not an attribute of a service. The following shows a definition for an endpoint.

```yaml
apiVersion: v1
kind: Endpoints
metadata:
  name: external-service
subsets:
  - addresses:
    - ip: 11.11.11.11
    - ip: 22.22.22.22
    ports:
    - port: 80
```

Instead of exposing an external service manually configuring the service's Endpoints, a simpler method allows you to refer to an external service by its fully qualified domain name (FQDN).

To create a service that serves as an alias for an external service, you create a Service resource with the type field set to 'ExternalName'.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: external-service
spec:
  type: ExternalName
  externalName: someapi.somecompany.com
  ports:
  - port: 80
```

### Exposing services to external clients

There is a few ways to make a service accessible externally:

* Setting the service type to NodePort - For a NodePort service, each cluster node opens a port on the node itself and redirects traffic received on that port to the underlying service. The service isn't accessible only at the internal cluster IP and port, but also through a dedicated port on all nodes.

* Setting the service type to LoadBalancer, an extension of the NodePort type - This makes the service accessible through a dedicated load balancer, provisioned from the cloud infrastructure Kubernetes is running on. The load balancer redirects traffic to the nod eport across all nodes. Clients connect to the service through the load balancers IP.

* Creating an Ingress resource, a radically different mechanism for exposing multiple services through a single IP address - It operates at the HTTP level and can thus offer more features than layer 4 services can.

#### Using a NodePort Service

By creating a NodePort service, you make Kubernetes reserve a port on all its nodes (the same port number is used across all of them) and forward incoming connections to the pods that are part of the service. This is similar to a regular service(ClusterIp), but a NodePort service can be accessed not only through the service's internal cluster IP, but also through any node's IP and the reserved node port.

Example of a NodePort definition.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: kubia-nodeport
spec:
  type: NodePort
  ports:
  - port: 80
    targetPort: 8080
    nodePort: 30123
  selector:
    app: kubia
```

#### Loadbalancer

If your Kubernetes cluster can provision a LoadBalancer this can be used to connect to the Nodes. The benefit of the LoadBalancer is that if you're using NodePort and the node you're connecting to goes down, then you won't be able to access the service. If you instead use a LoadBalancer then you can still access the services even if the node goes down.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: kubia-loadbalancer
spec:
  type: LoadBalancer
  ports:
  - port: 80
  targetPort: 8080
  selector:
    app: kubia
```

If your Kubernetes cluster cannot provision a LoadBalancer a NodePort will be used instead.

## Volumes

Kubernetes volumes are a component of a pod and are thus defined in the pod's specification, much like containers. They aren't a standalone Kubernetes object and cannot be created or deleted on their own. A volume is available to all containers in the pod, but it must be mounted in each container that needs to access it. In each container, you can mount the volume in any location of the filesystem.

A wide variety of volume types is available. Several are generic, while others are specific to the actual storage technologies. 

* emptyDir - A simple empty directory used for storing transient data.

* hostPath - Used for mounting directories from the workers node's filesystem into the pod.

* gitRepo - A volume initialized by checking out the contents of a Git repository.

* nfs - An NFS share mounted into the pod.

* gcePersistentDisk - (Google Compute Engine Persistent Disk), awsElastic-BlockStore, azureDisk - Used for mounting cloud provider-specific storage.

* cinder (* more) - Used for mounting other types of network storage.

* configMap, secret, downwardAPI - Special types of volumes used to expose certain Kubernetes resources and cluster information to the pod.

* persistentVolumeClaim - A way to use a pre- or dynamically provisioned persistent storage.

### emptyDir

The simplest volume type is the emptyDir volume. As the name suggests, the volume starts out as an empty directory. The app inside the pod can then write any files it needs to it. Because the volumes lifetime is tied to that of the pod, the volumes contents are lost when the pod is deleted. An emptyDir volume is very useful for sharing files between containers running in the same pod.

Example of a pod with two containers sharing the same volume.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: fortune
spec:
  containers:
  - image: runeanielsen/fortune
    name: html-generator
    volumeMounts:
    - name: html
      mountPath: /var/htdocs
  - image: nginx:alpine
    name: web-server
    volumeMounts:
    - name: html
      mountPath: /usr/share/nginx/html
      readOnly: true
    ports:
    - containerPort: 80
      protocol: TCP
    volumes:
    - name: html
      emptyDir: {}
```

### hostPath

A hostPath volume points to a specific file or directory on the node's filesystem. Pods running on the same node and using the same path in their hostPath volume see the same files.

hostPath is a persistent volume. hostPAth volumes are used if you need to read or write system files on the node. Never use them to persist data across pods.

### PersistentVolumes and PersistentVolumeClaims

The enable apps to request storage in a Kubernetes cluster without having to deal with infrastructure specifcs, two new resources were introduced. They are PersistentVolumes and PersistentVolumeClaims. 

Instead of the developer adding a technology-specific volume to their pod, it's the cluster administrator who sets up the underlying storage and then registers it in Kubernetes by creating a PersistentVolume resource through the Kubernetes API server. When creating the PersistentVolume, the admin specifies its size and access modes it supports.

When a cluster user needs to use a persistent storage in one of their pods, they first create a PersistentVolumeClaim manifest, specifying the minimum size and the access mode they require. The User then submits the PersistentVolumeClaim manifest to the Kubernetes API server, and Kubernetes finds the appropriate PersistentVolume and binds the volume to the claim.

Example of PersistentVolume using gcePersistentDisk

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: mongodb-pv
spec:
  capacity:
    storage: 1Gi
  accessModes:
  - ReadWriteOnce
  - ReadOnlyMany
  persistentVolumeReclaimPolicy: Retain
  gcePersistentDisk:
    pdName: mongodb
    fsType: ext4
```

### PersistentVolumeClaim

To use a PersistentVolume you need to claim it first. Claiming a PersistentVolumeClaim is a completely seperate process from creating a pod, because you want the same PersistentVolumeClaim to stay available even if the pod is rescheduled. 

Example of PersistentVolumeClaim

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mongodb-pvc
spec:
  resource:
    requests:
      storage: 1Gi
    accessModes:
    - ReadWriteOnce
    storageClassName: ""
```

#### Using a PersistentVolumeClaim in a Pod

To use a PersistentVolumeClaim inside a pod, you need to reference it by name inside the pod's volume. 

Example:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: mongodb
spec:
  containers:
  - image: mongo
    name: mongodb
    volumeMounts:
    - name: mongodb
      mountPath: /data/db
    ports:
    - containerPort: 27017
      protocol: TCP
  volumes:
  - name: mongodb-data
    persistentVolumeClaim:
      claimName: mongodb-pvc
```

## Thanks to

* [Kubernetes in Action By Marko Luksa](https://www.manning.com/books/kubernetes-in-action-second-edition?a_aid=kubiaML)
* [Getting Started with Kubernetes By Nigel Poulton](https://www.pluralsight.com/courses/getting-started-kubernetes)
