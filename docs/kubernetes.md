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

* kubectl v1.25.0
* kind v0.16.0
* helm v3.10.0

## Create Kubernetes Cluster

A Kubernetes cluster is created using [Kind](https://kind.sigs.k8s.io/)

```bash
kind create cluster
```

<details>
  <summary>Result</summary>

  ```bash
  Creating cluster "kind" ...
  ✓ Ensuring node image (kindest/node:v1.25.2) 🖼
  ✓ Preparing nodes 📦
  ✓ Writing configuration 📜
  ✓ Starting control-plane 🕹️
  ✓ Installing CNI 🔌
  ✓ Installing StorageClass 💾
  Set kubectl context to "kind-kind"
  You can now use your cluster with:

  kubectl cluster-info --context kind-kind

  Have a question, bug, or feature request? Let us know! https://kind.sigs.k8s.io/#community 🙂
  ```
</details>

Check the connection between the kubernetes client (kubectl) and the cluster.

```bash
kubectl cluster-info
```

<details>
  <summary>Result</summary>

  ```bash
  Kubernetes control plane is running at https://127.0.0.1:63769
  CoreDNS is running at https://127.0.0.1:63769/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

  To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
  ```
</details>

## Deploy Cinema project in Kubernetes

To deploy this project should be used the `cinema` Helm chart located in `./charts` folder. This chart is an umbrella for all services needed to deploy the project. Take a look at the `dependencies` section in the `Chart.yaml` file.

```bash
cat ./charts/cinema/Chart.yaml
```

<details>
  <summary>Result</summary>

  ```bash
  apiVersion: v2
  name: cinema
  description: A Helm chart to deploy Cinema project in Kubernetes
  # chart type
  type: application
  # chart version
  version: 0.2.1
  # cinema app version
  appVersion: "v2.2.0"
  dependencies:
    - condition: mongodb.enabled
      name: mongodb
      repository: https://charts.bitnami.com/bitnami
      version: 13.5.0
    - name: users
      version: 0.x.x
    - name: movies
      version: 0.x.x
    - name: showtimes
      version: 0.x.x
    - name: bookings
      version: 0.x.x
    - name: website
      version: 0.x.x
  ```
</details>

Dependencies like `website`, `users`, `movies`, `showtimes` and `bookings` are charts located inside `charts` folder, and `mongodb` dependency came from Bitnami repository.

First of all is needed update helm dependencies

```bash
helm dependency update charts/cinema
```
<details>
  <summary>Result</summary>

  ```bash
  Getting updates for unmanaged Helm repositories...
  ...Successfully got an update from the "https://charts.bitnami.com/bitnami" chart repository
  Update Complete. ⎈Happy Helming!⎈
  Saving 6 charts
  Downloading mongodb from repo https://charts.bitnami.com/bitnami
  Dependency users did not declare a repository. Assuming it exists in the charts directory
  Dependency movies did not declare a repository. Assuming it exists in the charts directory
  Dependency showtimes did not declare a repository. Assuming it exists in the charts directory
  Dependency bookings did not declare a repository. Assuming it exists in the charts directory
  Dependency website did not declare a repository. Assuming it exists in the charts directory
  Deleting outdated charts
  ```
</details>

Then use the following command to deploy the whole project with just one line:

```bash
helm upgrade cinema --install  ./charts/cinema
```

<details>
  <summary>Result</summary>

  ```bash
  Release "cinema" does not exist. Installing it now.
  NAME: cinema
  LAST DEPLOYED: Wed Feb 24 20:03:09 2021
  NAMESPACE: default
  STATUS: deployed
  REVISION: 1
  ```
</details>

Then check the deployment status:

```bash
helm list

NAME    NAMESPACE       REVISION        UPDATED                                 STATUS          CHART           APP VERSION
cinema  default         1               2022-11-26 23:28:40.745418 +0100 CET    deployed        cinema-0.2.1    v2.2.0
```

## Check Cinema services status

```bash
kubectl get po
```

<details>
  <summary>Result</summary>

  ```bash
  NAME                                READY   STATUS    RESTARTS   AGE
  cinema-bookings-64d56d595c-7vkgj    1/1     Running   0          47s
  cinema-mongodb-75854c5d9c-l9s2z     1/1     Running   0          47s
  cinema-movies-d9fd6f6cd-2l9lr       1/1     Running   0          47s
  cinema-showtimes-5575885ccb-pksxc   1/1     Running   0          47s
  cinema-users-9fb877fb7-zfsb2        1/1     Running   0          47s
  cinema-website-6896897d9-l4dxm      1/1     Running   0          47s
  ```
</details>

## Populate mongodb cluster with information

It is recommended to use this test data to check the apis of the services

```
{
  POD=$(kubectl get po -l app.kubernetes.io/name=mongodb -o jsonpath='{.items[0].metadata.name}')
  kubectl cp backup $POD:/tmp/
  kubectl exec -it $POD -- mongorestore --uri mongodb://localhost:27017 --gzip  /tmp/backup/cinema
}
```

<details>
  <summary>Result</summary>

  ```bash
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
</details>

## Test Cinema services

To consult the website or the APIs you can use the `port-forward` command to link the cluster service with the local ports

### Website

```bash
kubectl port-forward svc/cinema-website 8000:80
```

<details>
  <summary>Result</summary>

  ```bash
  Forwarding from 127.0.0.1:8000 -> 8000
  Forwarding from [::1]:8000 -> 8000
  ```
</details>

Access the following link in your web browser: <http://localhost:8000/>

![website home page](images/website-home.jpg)

### APIs

```bash
kubectl port-forward svc/cinema-users 4000:80
```

<details>
  <summary>Result</summary>

  ```bash
  Forwarding from 127.0.0.1:4000 -> 4000
  Forwarding from [::1]:4000 -> 4000
  ```
</details>

Now you can access to the following link: <http://localhost:4000/api/users/>. Use the same approach to the rest of the services.

Use the same approach to the rest of the services

## Remove deployment

```bash
helm delete cinema

release "cinema" uninstalled
```

Next: [Endpoints](endpoints.md)
