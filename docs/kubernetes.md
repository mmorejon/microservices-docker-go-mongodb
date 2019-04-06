# Cinema - Kubernetes Deployment

### Overview

The Cinema project can be deployed in a kubernetes cluster in order to know the behavior of microservices.

### Requirements

* kubectl v1.14.0
* minikube v1.0.0
* virtualbox v6.0

## Create Kubernetes Cluster

A Kubernetes cluster is created using minikube and with the VirtualBox drive.

```
minikube start --cpus 2 --memory 4096
```

Check the status of the cluster after its creation.

```
minikube status
```

```
host: Running
kubelet: Running
apiserver: Running
kubectl: Correctly Configured: pointing to minikube-vm at 192.168.99.100
```

Check the connection between the kubernetes client (kubectl) and the cluster.

```
kubectl cluster-info
```

```
Kubernetes master is running at https://192.168.99.100:8443
KubeDNS is running at https://192.168.99.100:8443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```

## Install Helm

```
helm init
```

## Deploy MongoDB Service

```
helm upgrade \
  --install \
  mongodb-replicaset \
  --set replicas=1 \
  --version 3.9.2 \
  stable/mongodb-replicaset
```

## Deploy Services

```
{
  helm install --name=cinema-users users/chart
  helm install --name=cinema-movies movies/chart
  helm install --name=cinema-showtimes showtimes/chart
  helm install --name=cinema-bookings bookings/chart
}
```

## Update Services

```
{
  helm upgrade cinema-users users/chart
  helm upgrade cinema-movies movies/chart
  helm upgrade cinema-showtimes showtimes/chart
  helm upgrade cinema-bookings bookings/chart
}

```

## Remove Services

```
{
  helm delete --purge cinema-users
  helm delete --purge cinema-movies
  helm delete --purge cinema-showtimes
  helm delete --purge cinema-bookings
}
```

## Load Service Information

```
{
  kubectl cp backup mongodb-replicaset-0:/tmp/
  kubectl exec mongodb-replicaset-0 -- sh -c 'mongorestore -d users -c users /tmp/backup/users/users/users.bson'
  kubectl exec mongodb-replicaset-0 -- sh -c 'mongorestore -d movies -c movies /tmp/backup/movies/movies/movies.bson'
  kubectl exec mongodb-replicaset-0 -- sh -c 'mongorestore -d showtimes -c showtimes /tmp/backup/showtimes/showtimes/showtimes.bson'
  kubectl exec mongodb-replicaset-0 -- sh -c 'mongorestore -d bookings -c bookings /tmp/backup/bookings/bookings/bookings.bson'
}
```

Next: [Endpoints](endpoints.md)