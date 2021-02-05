# Cinema - Kubernetes Deployment

## Overview

The Cinema project can be deployed in a kubernetes cluster in order to know the behavior of microservices

## Index

* [Requirements](#requirements)
* [Create Kubernetes Cluster](#create-kubernetes-cluster)
* [Deploy Cinema project in Kubernetes](#deploy-cinema-project-in-kubernetes)
* [Check Cinema services status](#check-cinema-services-status)
* [Populate mongodb cluster with information](#populate-mongodb-cluster-with-information)
* [Test APIs services](#test-apis-services)
* [Remove deployment](#remove-deployment)

## Requirements

* kubectl v1.20.1
* minikube v1.16.0
* virtualbox 6.1.16
* helm v3.5.0

## Create Kubernetes Cluster

A Kubernetes cluster is created using minikube

```bash
$ minikube start --cpus 2 --memory 4096

😄  minikube v1.16.0 on Darwin 11.1
✨  Using the hyperkit driver based on user configuration
👍  Starting control plane node minikube in cluster minikube
🔥  Creating hyperkit VM (CPUs=2, Memory=4096MB, Disk=20000MB) ...
🐳  Preparing Kubernetes v1.20.0 on Docker 20.10.0 ...
    ▪ Generating certificates and keys ...
    ▪ Booting up control plane ...
    ▪ Configuring RBAC rules ...
🔎  Verifying Kubernetes components...
🌟  Enabled addons: storage-provisioner, default-storageclass
🏄  Done! kubectl is now configured to use "minikube" cluster and "default" namespace by default
```

Check the cluster status

```bash
$ minikube status

minikube
type: Control Plane
host: Running
kubelet: Running
apiserver: Running
kubeconfig: Configured
timeToStop: Nonexistent
```

Check the connection between the kubernetes client (kubectl) and the cluster.

```bash
$ kubectl cluster-info

Kubernetes control plane is running at https://192.168.64.173:8443
KubeDNS is running at https://192.168.64.173:8443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```

## Deploy Cinema project in Kubernetes

To deploy this project should be used the `cinema` Helm chart located in `./charts` folder. This chart is an umbrella for all services needed to deploy the project. Take a look at the `dependencies` section in the `Chart.yaml` file.

```bash
$ cat ./charts/cinema/Chart.yaml

apiVersion: v2
name: cinema
description: A Helm chart to deploy Cinema project in Kubernetes
# chart type
type: application
# chart version
version: 0.1.0
# cinema app version
appVersion: "v2.0.1"
dependencies:
  - condition: mongodb.enabled
    name: mongodb
    repository: https://charts.bitnami.com/bitnami
    version: 10.4.0
  - name: users
    version: 0.x.x
  - name: movies
    version: 0.x.x
  - name: showtimes
    version: 0.x.x
  - name: bookings
    version: 0.x.x
```

Dependencies like `users`, `movies`, `showtimes` and `bookings` are charts located inside `charts` folder, and `mongodb` dependency came from Bitnami repository.

First of all is needed update helm dependencies

```bash
$ helm dependency update charts/cinema

Getting updates for unmanaged Helm repositories...
...Successfully got an update from the "https://charts.bitnami.com/bitnami" chart repository
Update Complete. ⎈Happy Helming!⎈
Saving 5 charts
Downloading mongodb from repo https://charts.bitnami.com/bitnami
Dependency users did not declare a repository. Assuming it exists in the charts directory
Dependency movies did not declare a repository. Assuming it exists in the charts directory
Dependency showtimes did not declare a repository. Assuming it exists in the charts directory
Dependency bookings did not declare a repository. Assuming it exists in the charts directory
Deleting outdated charts
```

Then use the following command to deploy the whole project with just one line:

```bash
$ helm upgrade cinema --install  ./charts/cinema

Release "cinema" does not exist. Installing it now.
NAME: cinema
LAST DEPLOYED: Mon Jan 18 15:39:01 2021
NAMESPACE: default
STATUS: deployed
REVISION: 1
```

Then check the deployment status:

```bash
$ helm list

NAME    NAMESPACE       REVISION        UPDATED                                 STATUS          CHART           APP VERSION
cinema  default         1               2021-01-18 15:39:01.74132 +0100 CET     deployed        cinema-0.1.0    v2.0.1
```

## Check Cinema services status

```bash
$ kubectl get po

NAME                                READY   STATUS    RESTARTS   AGE
cinema-bookings-57dd76b7bd-7g2hc    1/1     Running   0          104s
cinema-mongodb-75854c5d9c-hlfz7     1/1     Running   0          104s
cinema-movies-86cf88bb67-khp4h      1/1     Running   0          104s
cinema-showtimes-86b68b6f49-p2h4x   1/1     Running   0          104s
cinema-users-6969d54b86-72fgg       1/1     Running   0          104s
```

## Populate mongodb cluster with information

It is recommended to use this test data to check the apis of the services

```
{
  POD=$(kubectl get po -l app.kubernetes.io/name=mongodb -o jsonpath='{.items[0].metadata.name}')
  kubectl cp backup $POD:/tmp/
  kubectl exec -it $POD -- mongorestore --uri mongodb://localhost:27017 --gzip  /tmp/backup/cinema
}

2021-01-18T19:43:55.343+0000    preparing collections to restore from
2021-01-18T19:43:55.345+0000    reading metadata for movies.movies from /tmp/backup/cinema/movies/movies.metadata.json.gz
2021-01-18T19:43:55.349+0000    reading metadata for showtimes.showtimes from /tmp/backup/cinema/showtimes/showtimes.metadata.json.gz
2021-01-18T19:43:55.353+0000    reading metadata for users.users from /tmp/backup/cinema/users/users.metadata.json.gz
2021-01-18T19:43:55.355+0000    reading metadata for bookings.bookings from /tmp/backup/cinema/bookings/bookings.metadata.json.gz
2021-01-18T19:43:55.382+0000    restoring movies.movies from /tmp/backup/cinema/movies/movies.bson.gz
2021-01-18T19:43:55.388+0000    restoring showtimes.showtimes from /tmp/backup/cinema/showtimes/showtimes.bson.gz
2021-01-18T19:43:55.394+0000    restoring users.users from /tmp/backup/cinema/users/users.bson.gz
2021-01-18T19:43:55.397+0000    no indexes to restore
2021-01-18T19:43:55.397+0000    finished restoring movies.movies (6 documents, 0 failures)
2021-01-18T19:43:55.401+0000    no indexes to restore
2021-01-18T19:43:55.401+0000    finished restoring showtimes.showtimes (3 documents, 0 failures)
2021-01-18T19:43:55.406+0000    no indexes to restore
2021-01-18T19:43:55.406+0000    finished restoring users.users (5 documents, 0 failures)
2021-01-18T19:43:55.407+0000    restoring bookings.bookings from /tmp/backup/cinema/bookings/bookings.bson.gz
2021-01-18T19:43:55.422+0000    no indexes to restore
2021-01-18T19:43:55.423+0000    finished restoring bookings.bookings (2 documents, 0 failures)
2021-01-18T19:43:55.424+0000    16 document(s) restored successfully. 0 document(s) failed to restore.
```

## Test APIs services

To consult the APIs you can use the `port-forward` command to link the cluster service with the local ports

```bash
$ kubectl port-forward svc/cinema-users 4000:80

Forwarding from 127.0.0.1:4000 -> 4000
Forwarding from [::1]:4000 -> 4000
```

Now you can access to the following link: <http://localhost:4000/api/users/>. Use the same approach to the rest of the services.

Use the same approach to the rest of the services

## Remove deployment

```bash
$ helm delete cinema

release "cinema" uninstalled
```

Next: [Endpoints](endpoints.md)