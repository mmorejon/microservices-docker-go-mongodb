# Cinema - Kubernetes Deployment (Timoni)

## Overview

The Cinema project can be deployed in Kubernetes using Timoni. [Timoni](https://timoni.sh/) is a package manager for Kubernetes, powered by CUE and inspired by Helm.

The Timoni project strives to improve the UX of authoring Kubernetes configs. Instead of mingling Go templates with YAML like Helm, or layering YAML on top of each-other like Kustomize, Timoni relies on cuelang's type safety, code generation and data validation features to offer a better experience of creating, packaging and delivering apps to Kubernetes.

## Index

* [Requirements](#requirements)
* [Create Kubernetes Cluster](#create-kubernetes-cluster)
* [Deploy Cinema project](#deploy-cinema-project)
* [Check Cinema services status](#check-cinema-services-status)
* [Populate mongodb cluster](#populate-mongodb-cluster)
* [Test APIs services](#test-cinema-services)
* [Remove deployment](#remove-cinema-project)

## Requirements

* kubectl >= v1.26.0
* kind >= v0.20.0
* timoni >= 0.11.1

## Create Kubernetes cluster

A cluster is created using [Kind](https://kind.sigs.k8s.io/)

```bash
kind create cluster
```

<details>
  <summary>Result</summary>

  ```bash
  Creating cluster "kind" ...
  ✓ Ensuring node image (kindest/node:v1.27.3) 🖼
  ✓ Preparing nodes 📦
  ✓ Writing configuration 📜
  ✓ Starting control-plane 🕹️
  ✓ Installing CNI 🔌
  ✓ Installing StorageClass 💾
  Set kubectl context to "kind-kind"
  You can now use your cluster with:

  kubectl cluster-info --context kind-kind

  Have a nice day! 👋
  ```
</details>

Check the cluster connection.

```bash
kubectl cluster-info
```

<details>
  <summary>Result</summary>

  ```bash
  Kubernetes control plane is running at https://127.0.0.1:65291
  CoreDNS is running at https://127.0.0.1:65291/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

  To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
  ```
</details>

## Deploy Cinema project

The Cinema project is described as a [bundle](https://timoni.sh/bundles/). From Timoni perspective, a bundle is a declarative way of managing the lifecycle of applications and their infra dependencies.

```bash
cat modules/cinema.bundle.cue
```

<details>
  <summary>Result</summary>

  ```cue
  bundle: {
          apiVersion: "v1alpha1"
          name:       "cinema"
          instances: {
                  website: {
                          module: url:     "oci://ghcr.io/mmorejon/modules/website"
                          module: version: "0.1.0"
                          namespace: "default"
                          values: args: [
                                  "-usersAPI",
                                  "http://users/api/users/",
                                  "-moviesAPI",
                                  "http://movies/api/movies/",
                                  "-showtimesAPI",
                                  "http://showtimes/api/showtimes/",
                                  "-bookingsAPI",
                                  "http://bookings/api/bookings/",
                          ]
                  }
                  users: {
                          module: url:     "oci://ghcr.io/mmorejon/modules/users"
                          module: version: "0.1.0"
                          namespace: "default"
                          values: args: [
                                  "-mongoURI",
                                  "mongodb://mongodb:27017/",
                          ]
                  }
                  movies: {
                          module: url:     "oci://ghcr.io/mmorejon/modules/movies"
                          module: version: "0.1.0"
                          namespace: "default"
                          values: args: [
                                  "-mongoURI",
                                  "mongodb://mongodb:27017/",
                          ]
                  }
                  showtimes: {
                          module: url:     "oci://ghcr.io/mmorejon/modules/showtimes"
                          module: version: "0.1.0"
                          namespace: "default"
                          values: args: [
                                  "-mongoURI",
                                  "mongodb://mongodb:27017/",
                          ]
                  }
                  bookings: {
                          module: url:     "oci://ghcr.io/mmorejon/modules/bookings"
                          module: version: "0.1.0"
                          namespace: "default"
                          values: args: [
                                  "-mongoURI",
                                  "mongodb://mongodb:27017/",
                          ]
                  }
                  mongodb: {
                          module: url:     "oci://ghcr.io/mmorejon/modules/mongodb"
                          module: version: "0.1.0"
                          namespace: "default"
                  }
          }
  }
  ```
</details>

This file has six [instances](https://timoni.sh/#timoni-instances) `website`, `users`, `movies`, `showtimes`, `bookings`, and `mongodb`. Each instance represents a [module](https://timoni.sh/#timoni-modules) instantiation on a Kubernetes cluster.

All instances make reference to OCI artifacts stored in GitHub container registry and [linked to this repository](https://github.com/mmorejon?tab=packages&repo_name=microservices-docker-go-mongodb).

> Note: the `mongodb` is not ready for production. This module was created for testing the Cinema project.

Deploy the cinema bundle:

```bash
timoni bundle apply --file modules/cinema.bundle.cue
```

<details>
  <summary>Result</summary>

  ```bash
  11:19PM INF b:cinema > applying 6 instance(s)
  11:19PM INF b:cinema > applying instance website
  11:19PM INF b:cinema > i:website > pulling oci://ghcr.io/mmorejon/modules/website:0.1.0
  11:19PM INF b:cinema > i:website > using module timoni.sh/website version 0.1.0
  11:19PM INF b:cinema > i:website > installing website in namespace default
  11:19PM INF b:cinema > i:website > ServiceAccount/default/website created
  11:19PM INF b:cinema > i:website > Service/default/website created
  11:19PM INF b:cinema > i:website > Deployment/default/website created
  11:19PM INF b:cinema > i:website > resources are ready
  11:19PM INF b:cinema > applying instance users
  11:19PM INF b:cinema > i:users > pulling oci://ghcr.io/mmorejon/modules/users:0.1.0
  11:19PM INF b:cinema > i:users > using module timoni.sh/users version 0.1.0
  11:19PM INF b:cinema > i:users > installing users in namespace default
  11:19PM INF b:cinema > i:users > ServiceAccount/default/users created
  11:19PM INF b:cinema > i:users > Service/default/users created
  11:19PM INF b:cinema > i:users > Deployment/default/users created
  11:19PM INF b:cinema > i:users > resources are ready
  11:19PM INF b:cinema > applying instance movies
  11:19PM INF b:cinema > i:movies > pulling oci://ghcr.io/mmorejon/modules/movies:0.1.0
  11:19PM INF b:cinema > i:movies > using module timoni.sh/movies version 0.1.0
  11:19PM INF b:cinema > i:movies > installing movies in namespace default
  11:19PM INF b:cinema > i:movies > ServiceAccount/default/movies created
  11:19PM INF b:cinema > i:movies > Service/default/movies created
  11:19PM INF b:cinema > i:movies > Deployment/default/movies created
  11:19PM INF b:cinema > i:movies > resources are ready
  11:19PM INF b:cinema > applying instance showtimes
  11:19PM INF b:cinema > i:showtimes > pulling oci://ghcr.io/mmorejon/modules/showtimes:0.1.0
  11:19PM INF b:cinema > i:showtimes > using module timoni.sh/showtimes version 0.1.0
  11:19PM INF b:cinema > i:showtimes > installing showtimes in namespace default
  11:19PM INF b:cinema > i:showtimes > ServiceAccount/default/showtimes created
  11:19PM INF b:cinema > i:showtimes > Service/default/showtimes created
  11:19PM INF b:cinema > i:showtimes > Deployment/default/showtimes created
  11:19PM INF b:cinema > i:showtimes > resources are ready
  11:19PM INF b:cinema > applying instance bookings
  11:19PM INF b:cinema > i:bookings > pulling oci://ghcr.io/mmorejon/modules/bookings:0.1.0
  11:19PM INF b:cinema > i:bookings > using module timoni.sh/bookings version 0.1.0
  11:19PM INF b:cinema > i:bookings > installing bookings in namespace default
  11:19PM INF b:cinema > i:bookings > ServiceAccount/default/bookings created
  11:19PM INF b:cinema > i:bookings > Service/default/bookings created
  11:19PM INF b:cinema > i:bookings > Deployment/default/bookings created
  11:19PM INF b:cinema > i:bookings > resources are ready
  11:19PM INF b:cinema > applying instance mongodb
  11:19PM INF b:cinema > i:mongodb > pulling oci://ghcr.io/mmorejon/modules/mongodb:0.1.0
  11:19PM INF b:cinema > i:mongodb > using module timoni.sh/mongodb version 0.1.0
  11:19PM INF b:cinema > i:mongodb > installing mongodb in namespace default
  11:19PM INF b:cinema > i:mongodb > ServiceAccount/default/mongodb created
  11:19PM INF b:cinema > i:mongodb > Service/default/mongodb created
  11:19PM INF b:cinema > i:mongodb > Deployment/default/mongodb created
  11:20PM INF b:cinema > i:mongodb > resources are ready
  11:20PM INF b:cinema > applied successfully
  ```
</details>

Then, list all instances created inside `default` namespace.

```bash
$ timoni list --bundle cinema

NAME            MODULE                                          VERSION LAST APPLIED            BUNDLE
bookings        oci://ghcr.io/mmorejon/modules/bookings         0.1.0   2023-08-22T21:19:56Z    cinema
mongodb         oci://ghcr.io/mmorejon/modules/mongodb          0.1.0   2023-08-22T21:20:07Z    cinema
movies          oci://ghcr.io/mmorejon/modules/movies           0.1.0   2023-08-22T21:19:42Z    cinema
showtimes       oci://ghcr.io/mmorejon/modules/showtimes        0.1.0   2023-08-22T21:19:49Z    cinema
users           oci://ghcr.io/mmorejon/modules/users            0.1.0   2023-08-22T21:19:35Z    cinema
website         oci://ghcr.io/mmorejon/modules/website          0.1.0   2023-08-22T21:19:28Z    cinema
```

## Check Cinema services status

```bash
kubectl get po
```

<details>
  <summary>Result</summary>

  ```bash
  NAME                         READY   STATUS    RESTARTS   AGE
  bookings-744f576dfb-rtddx    1/1     Running   0          3m7s
  mongodb-77cc88b944-rf52n     1/1     Running   0          3m1s
  movies-848ffd8cd9-mjx85      1/1     Running   0          3m21s
  showtimes-8679b6c95f-8dpfm   1/1     Running   0          3m14s
  users-9f675d99f-mzx97        1/1     Running   0          3m28s
  website-55448c4fd9-zpvvg     1/1     Running   0          3m35s
  ```
</details>

## Populate mongodb cluster

It is recommended to use this test data to check the APIs behaviors.

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
  2023-08-22T21:26:35.834+0000    preparing collections to restore from
  2023-08-22T21:26:35.835+0000    reading metadata for showtimes.showtimes from /tmp/backup/cinema/showtimes/showtimes.metadata.json.gz
  2023-08-22T21:26:35.837+0000    reading metadata for movies.movies from /tmp/backup/cinema/movies/movies.metadata.json.gz
  2023-08-22T21:26:35.837+0000    reading metadata for bookings.bookings from /tmp/backup/cinema/bookings/bookings.metadata.json.gz
  2023-08-22T21:26:35.838+0000    reading metadata for users.users from /tmp/backup/cinema/users/users.metadata.json.gz
  2023-08-22T21:26:35.848+0000    restoring showtimes.showtimes from /tmp/backup/cinema/showtimes/showtimes.bson.gz
  2023-08-22T21:26:35.850+0000    no indexes to restore
  2023-08-22T21:26:35.850+0000    finished restoring showtimes.showtimes (3 documents, 0 failures)
  2023-08-22T21:26:35.851+0000    restoring bookings.bookings from /tmp/backup/cinema/bookings/bookings.bson.gz
  2023-08-22T21:26:35.852+0000    no indexes to restore
  2023-08-22T21:26:35.852+0000    finished restoring bookings.bookings (2 documents, 0 failures)
  2023-08-22T21:26:35.853+0000    restoring movies.movies from /tmp/backup/cinema/movies/movies.bson.gz
  2023-08-22T21:26:35.862+0000    restoring users.users from /tmp/backup/cinema/users/users.bson.gz
  2023-08-22T21:26:35.872+0000    no indexes to restore
  2023-08-22T21:26:35.872+0000    finished restoring movies.movies (6 documents, 0 failures)
  2023-08-22T21:26:35.872+0000    no indexes to restore
  2023-08-22T21:26:35.872+0000    finished restoring users.users (5 documents, 0 failures)
  2023-08-22T21:26:35.872+0000    16 document(s) restored successfully. 0 document(s) failed to restore.
  ```
</details>

## Test Cinema services

Use the `port-forward` command to access the website or the APIs from your localhost.

### Website

```bash
kubectl port-forward svc/website 8000:80
```

<details>
  <summary>Result</summary>

  ```bash
  Forwarding from 127.0.0.1:8000 -> 8000
  Forwarding from [::1]:8000 -> 8000
  ```
</details>

Open this link in your browser: <http://localhost:8000/>

![website home page](images/website-home.jpg)

### APIs

```bash
kubectl port-forward svc/users 4000:80
```

<details>
  <summary>Result</summary>

  ```bash
  Forwarding from 127.0.0.1:4000 -> 4000
  Forwarding from [::1]:4000 -> 4000
  ```
</details>

Open this link in your browser: <http://localhost:4000/api/users/>. Use the same pattern with other services.

## Remove Cinema project

```bash
timoni bundle delete --name cinema
```

<details>
  <summary>Result</summary>

  ```bash
  11:34PM INF b:cinema > deleting instance bookings from bundle cinema
  11:34PM INF b:cinema > deleting 3 resource(s)...
  11:34PM INF b:cinema > Deployment/default/bookings deleted
  11:34PM INF b:cinema > Service/default/bookings deleted
  11:34PM INF b:cinema > ServiceAccount/default/bookings deleted
  11:34PM INF b:cinema > all resources have been deleted
  11:34PM INF b:cinema > deleting instance mongodb from bundle cinema
  11:34PM INF b:cinema > deleting 3 resource(s)...
  11:34PM INF b:cinema > Deployment/default/mongodb deleted
  11:34PM INF b:cinema > Service/default/mongodb deleted
  11:34PM INF b:cinema > ServiceAccount/default/mongodb deleted
  11:34PM INF b:cinema > all resources have been deleted
  11:34PM INF b:cinema > deleting instance movies from bundle cinema
  11:34PM INF b:cinema > deleting 3 resource(s)...
  11:34PM INF b:cinema > Deployment/default/movies deleted
  11:34PM INF b:cinema > Service/default/movies deleted
  11:34PM INF b:cinema > ServiceAccount/default/movies deleted
  11:34PM INF b:cinema > all resources have been deleted
  11:34PM INF b:cinema > deleting instance showtimes from bundle cinema
  11:34PM INF b:cinema > deleting 3 resource(s)...
  11:34PM INF b:cinema > Deployment/default/showtimes deleted
  11:34PM INF b:cinema > Service/default/showtimes deleted
  11:34PM INF b:cinema > ServiceAccount/default/showtimes deleted
  11:34PM INF b:cinema > all resources have been deleted
  11:34PM INF b:cinema > deleting instance users from bundle cinema
  11:34PM INF b:cinema > deleting 3 resource(s)...
  11:34PM INF b:cinema > Deployment/default/users deleted
  11:34PM INF b:cinema > Service/default/users deleted
  11:34PM INF b:cinema > ServiceAccount/default/users deleted
  11:34PM INF b:cinema > all resources have been deleted
  11:34PM INF b:cinema > deleting instance website from bundle cinema
  11:34PM INF b:cinema > deleting 3 resource(s)...
  11:34PM INF b:cinema > Deployment/default/website deleted
  11:34PM INF b:cinema > Service/default/website deleted
  11:34PM INF b:cinema > ServiceAccount/default/website deleted
  11:34PM INF b:cinema > all resources have been deleted
  ```
</details>

Next: [Endpoints](endpoints.md)
